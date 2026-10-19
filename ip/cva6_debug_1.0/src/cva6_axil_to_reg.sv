// AXI4-Lite to the simple CVA6 register request/response convention.
// The register request is held until reg_ready_i, but each AXI response is
// emitted once even when the AXI master applies backpressure.
module cva6_axil_to_reg #(
  parameter int unsigned ADDR_WIDTH = 32,
  parameter int unsigned DATA_WIDTH = 32
) (
  input  logic                      clk_i,
  input  logic                      rst_ni,

  input  logic [ADDR_WIDTH-1:0]     s_axi_awaddr,
  input  logic [2:0]                s_axi_awprot,
  input  logic                      s_axi_awvalid,
  output logic                      s_axi_awready,
  input  logic [DATA_WIDTH-1:0]     s_axi_wdata,
  input  logic [(DATA_WIDTH/8)-1:0] s_axi_wstrb,
  input  logic                      s_axi_wvalid,
  output logic                      s_axi_wready,
  output logic [1:0]                s_axi_bresp,
  output logic                      s_axi_bvalid,
  input  logic                      s_axi_bready,
  input  logic [ADDR_WIDTH-1:0]     s_axi_araddr,
  input  logic [2:0]                s_axi_arprot,
  input  logic                      s_axi_arvalid,
  output logic                      s_axi_arready,
  output logic [DATA_WIDTH-1:0]     s_axi_rdata,
  output logic [1:0]                s_axi_rresp,
  output logic                      s_axi_rvalid,
  input  logic                      s_axi_rready,

  output logic                      reg_valid_o,
  output logic [ADDR_WIDTH-1:0]     reg_addr_o,
  output logic                      reg_write_o,
  output logic [DATA_WIDTH-1:0]     reg_wdata_o,
  output logic [(DATA_WIDTH/8)-1:0] reg_wstrb_o,
  input  logic                      reg_ready_i,
  input  logic [DATA_WIDTH-1:0]     reg_rdata_i,
  input  logic                      reg_error_i
);

  typedef enum logic [2:0] {
    IDLE, REG_WRITE, AXI_WRITE_RESPONSE, REG_READ, AXI_READ_RESPONSE
  } state_t;

  state_t state_q, state_d;
  logic aw_hold_q, aw_hold_d;
  logic w_hold_q, w_hold_d;
  logic [ADDR_WIDTH-1:0] awaddr_q, awaddr_d;
  logic [DATA_WIDTH-1:0] wdata_q, wdata_d;
  logic [(DATA_WIDTH/8)-1:0] wstrb_q, wstrb_d;
  logic [ADDR_WIDTH-1:0] araddr_q, araddr_d;
  logic [DATA_WIDTH-1:0] rdata_q;
  logic error_q;

  logic aw_fire, w_fire, ar_fire;
  assign aw_fire = s_axi_awvalid && s_axi_awready;
  assign w_fire  = s_axi_wvalid  && s_axi_wready;
  assign ar_fire = s_axi_arvalid && s_axi_arready;

  always_comb begin
    state_d   = state_q;
    aw_hold_d = aw_hold_q;
    w_hold_d  = w_hold_q;
    awaddr_d  = awaddr_q;
    wdata_d   = wdata_q;
    wstrb_d   = wstrb_q;
    araddr_d  = araddr_q;

    s_axi_awready = 1'b0;
    s_axi_wready  = 1'b0;
    s_axi_bresp   = error_q ? 2'b10 : 2'b00;
    s_axi_bvalid  = 1'b0;
    s_axi_arready = 1'b0;
    s_axi_rdata   = rdata_q;
    s_axi_rresp   = error_q ? 2'b10 : 2'b00;
    s_axi_rvalid  = 1'b0;

    reg_valid_o = 1'b0;
    reg_addr_o  = (state_q == REG_READ) ? araddr_q : awaddr_q;
    reg_write_o = (state_q == REG_WRITE);
    reg_wdata_o = wdata_q;
    reg_wstrb_o = wstrb_q;

    unique case (state_q)
      IDLE: begin
        s_axi_awready = !aw_hold_q;
        s_axi_wready  = !w_hold_q;
        s_axi_arready = !aw_hold_q && !w_hold_q &&
                         !s_axi_awvalid && !s_axi_wvalid;
        if (aw_fire) begin
          aw_hold_d = 1'b1;
          awaddr_d  = s_axi_awaddr;
        end
        if (w_fire) begin
          w_hold_d = 1'b1;
          wdata_d  = s_axi_wdata;
          wstrb_d  = s_axi_wstrb;
        end
        if ((aw_hold_q || aw_fire) && (w_hold_q || w_fire)) begin
          state_d = REG_WRITE;
        end else if (ar_fire) begin
          araddr_d = s_axi_araddr;
          state_d  = REG_READ;
        end
      end

      REG_WRITE: begin
        reg_valid_o = 1'b1;
        if (reg_ready_i) begin
          aw_hold_d = 1'b0;
          w_hold_d  = 1'b0;
          state_d   = AXI_WRITE_RESPONSE;
        end
      end
      AXI_WRITE_RESPONSE: begin
        s_axi_bvalid = 1'b1;
        if (s_axi_bready) state_d = IDLE;
      end

      REG_READ: begin
        reg_valid_o = 1'b1;
        if (reg_ready_i) state_d = AXI_READ_RESPONSE;
      end
      AXI_READ_RESPONSE: begin
        s_axi_rvalid = 1'b1;
        if (s_axi_rready) state_d = IDLE;
      end

      default: state_d = IDLE;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q   <= IDLE;
      aw_hold_q <= 1'b0;
      w_hold_q  <= 1'b0;
      awaddr_q  <= '0;
      wdata_q   <= '0;
      wstrb_q   <= '0;
      araddr_q  <= '0;
      rdata_q   <= '0;
      error_q   <= 1'b0;
    end else begin
      state_q   <= state_d;
      aw_hold_q <= aw_hold_d;
      w_hold_q  <= w_hold_d;
      awaddr_q  <= awaddr_d;
      wdata_q   <= wdata_d;
      wstrb_q   <= wstrb_d;
      araddr_q  <= araddr_d;
      if ((state_q == REG_WRITE || state_q == REG_READ) && reg_ready_i) begin
        rdata_q <= reg_rdata_i;
        error_q <= reg_error_i;
      end
    end
  end

  logic unused_prot;
  assign unused_prot = ^{s_axi_awprot, s_axi_arprot};

endmodule
