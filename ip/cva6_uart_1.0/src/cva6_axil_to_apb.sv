// AXI4-Lite to APB3 bridge used only inside legacy-compatible CVA6 IP.
// One transaction is outstanding at a time.  AW and W may arrive in either
// order, and read/write side effects occur exactly once per AXI transaction.
module cva6_axil_to_apb #(
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

  output logic [ADDR_WIDTH-1:0]     paddr,
  output logic                      pwrite,
  output logic                      psel,
  output logic                      penable,
  output logic [DATA_WIDTH-1:0]     pwdata,
  output logic [(DATA_WIDTH/8)-1:0] pstrb,
  input  logic [DATA_WIDTH-1:0]     prdata,
  input  logic                      pready,
  input  logic                      pslverr
);

  typedef enum logic [2:0] {
    IDLE,
    APB_SETUP_WRITE,
    APB_ACCESS_WRITE,
    AXI_WRITE_RESPONSE,
    APB_SETUP_READ,
    APB_ACCESS_READ,
    AXI_READ_RESPONSE
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
    state_d  = state_q;
    aw_hold_d = aw_hold_q;
    w_hold_d  = w_hold_q;
    awaddr_d = awaddr_q;
    wdata_d  = wdata_q;
    wstrb_d  = wstrb_q;
    araddr_d = araddr_q;

    s_axi_awready = 1'b0;
    s_axi_wready  = 1'b0;
    s_axi_bresp   = error_q ? 2'b10 : 2'b00;
    s_axi_bvalid  = 1'b0;
    s_axi_arready = 1'b0;
    s_axi_rdata   = rdata_q;
    s_axi_rresp   = error_q ? 2'b10 : 2'b00;
    s_axi_rvalid  = 1'b0;

    paddr   = (state_q == APB_SETUP_READ || state_q == APB_ACCESS_READ)
              ? araddr_q : awaddr_q;
    pwrite  = (state_q == APB_SETUP_WRITE || state_q == APB_ACCESS_WRITE);
    psel    = (state_q == APB_SETUP_WRITE || state_q == APB_ACCESS_WRITE ||
               state_q == APB_SETUP_READ  || state_q == APB_ACCESS_READ);
    penable = (state_q == APB_ACCESS_WRITE || state_q == APB_ACCESS_READ);
    pwdata  = wdata_q;
    pstrb   = wstrb_q;

    unique case (state_q)
      IDLE: begin
        s_axi_awready = !aw_hold_q;
        s_axi_wready  = !w_hold_q;
        // A partially presented write has priority over a read.
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
          state_d = APB_SETUP_WRITE;
        end else if (ar_fire) begin
          araddr_d = s_axi_araddr;
          state_d  = APB_SETUP_READ;
        end
      end

      APB_SETUP_WRITE: state_d = APB_ACCESS_WRITE;
      APB_ACCESS_WRITE: begin
        if (pready) begin
          aw_hold_d = 1'b0;
          w_hold_d  = 1'b0;
          state_d   = AXI_WRITE_RESPONSE;
        end
      end
      AXI_WRITE_RESPONSE: begin
        s_axi_bvalid = 1'b1;
        if (s_axi_bready) state_d = IDLE;
      end

      APB_SETUP_READ: state_d = APB_ACCESS_READ;
      APB_ACCESS_READ: begin
        if (pready) state_d = AXI_READ_RESPONSE;
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
      if ((state_q == APB_ACCESS_WRITE || state_q == APB_ACCESS_READ) && pready) begin
        rdata_q <= prdata;
        error_q <= pslverr;
      end
    end
  end

  logic unused_prot;
  assign unused_prot = ^{s_axi_awprot, s_axi_arprot};

endmodule
