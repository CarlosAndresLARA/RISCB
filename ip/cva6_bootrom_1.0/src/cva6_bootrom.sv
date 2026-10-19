module cva6_bootrom #(
  parameter int unsigned C_S_AXI_ADDR_WIDTH = 64,
  parameter int unsigned C_S_AXI_DATA_WIDTH = 64,
  parameter int unsigned XLEN = 32
) (
  input  logic                              s_axi_aclk,
  input  logic                              s_axi_aresetn,
  input  logic [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
  input  logic [2:0]                        s_axi_awprot,
  input  logic                              s_axi_awvalid,
  output logic                              s_axi_awready,
  input  logic [C_S_AXI_DATA_WIDTH-1:0]     s_axi_wdata,
  input  logic [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
  input  logic                              s_axi_wvalid,
  output logic                              s_axi_wready,
  output logic [1:0]                        s_axi_bresp,
  output logic                              s_axi_bvalid,
  input  logic                              s_axi_bready,
  input  logic [C_S_AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
  input  logic [2:0]                        s_axi_arprot,
  input  logic                              s_axi_arvalid,
  output logic                              s_axi_arready,
  output logic [C_S_AXI_DATA_WIDTH-1:0]     s_axi_rdata,
  output logic [1:0]                        s_axi_rresp,
  output logic                              s_axi_rvalid,
  input  logic                              s_axi_rready
);

  typedef enum logic [2:0] {IDLE, ROM_REQUEST, ROM_CAPTURE,
                            AXI_READ_RESPONSE, AXI_WRITE_RESPONSE} state_t;
  state_t state_q, state_d;

  logic aw_hold_q, aw_hold_d;
  logic w_hold_q, w_hold_d;
  logic [C_S_AXI_ADDR_WIDTH-1:0] read_addr_q, read_addr_d;
  logic [63:0] rom_addr;
  logic [63:0] rom_rdata;
  logic [C_S_AXI_DATA_WIDTH-1:0] rdata_q;
  logic rom_req;
  logic aw_fire, w_fire, ar_fire;

  assign aw_fire = s_axi_awvalid && s_axi_awready;
  assign w_fire  = s_axi_wvalid  && s_axi_wready;
  assign ar_fire = s_axi_arvalid && s_axi_arready;
  assign rom_addr = 64'(read_addr_q);

  always_comb begin
    state_d = state_q;
    aw_hold_d = aw_hold_q;
    w_hold_d = w_hold_q;
    read_addr_d = read_addr_q;

    s_axi_awready = 1'b0;
    s_axi_wready  = 1'b0;
    s_axi_bresp   = 2'b10;
    s_axi_bvalid  = 1'b0;
    s_axi_arready = 1'b0;
    s_axi_rdata   = rdata_q;
    s_axi_rresp   = 2'b00;
    s_axi_rvalid  = 1'b0;
    rom_req       = 1'b0;

    unique case (state_q)
      IDLE: begin
        s_axi_awready = !aw_hold_q;
        s_axi_wready  = !w_hold_q;
        s_axi_arready = !aw_hold_q && !w_hold_q &&
                         !s_axi_awvalid && !s_axi_wvalid;
        if (aw_fire) aw_hold_d = 1'b1;
        if (w_fire)  w_hold_d  = 1'b1;
        if ((aw_hold_q || aw_fire) && (w_hold_q || w_fire)) begin
          aw_hold_d = 1'b0;
          w_hold_d  = 1'b0;
          state_d   = AXI_WRITE_RESPONSE;
        end else if (ar_fire) begin
          read_addr_d = s_axi_araddr;
          state_d     = ROM_REQUEST;
        end
      end
      ROM_REQUEST: begin
        rom_req = 1'b1;
        state_d = ROM_CAPTURE;
      end
      ROM_CAPTURE: state_d = AXI_READ_RESPONSE;
      AXI_READ_RESPONSE: begin
        s_axi_rvalid = 1'b1;
        if (s_axi_rready) state_d = IDLE;
      end
      AXI_WRITE_RESPONSE: begin
        s_axi_bvalid = 1'b1;
        if (s_axi_bready) state_d = IDLE;
      end
      default: state_d = IDLE;
    endcase
  end

  always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (!s_axi_aresetn) begin
      state_q     <= IDLE;
      aw_hold_q   <= 1'b0;
      w_hold_q    <= 1'b0;
      read_addr_q <= '0;
      rdata_q     <= '0;
    end else begin
      state_q     <= state_d;
      aw_hold_q   <= aw_hold_d;
      w_hold_q    <= w_hold_d;
      read_addr_q <= read_addr_d;
      if (state_q == ROM_CAPTURE) rdata_q <= C_S_AXI_DATA_WIDTH'(rom_rdata);
    end
  end

  if (XLEN == 32) begin : gen_bootrom_32
    bootrom_32 i_bootrom (
      .clk_i   ( s_axi_aclk ),
      .req_i   ( rom_req    ),
      .addr_i  ( rom_addr   ),
      .rdata_o ( rom_rdata  )
    );
  end else begin : gen_bootrom_64
    bootrom_64 i_bootrom (
      .clk_i   ( s_axi_aclk ),
      .req_i   ( rom_req    ),
      .addr_i  ( rom_addr   ),
      .rdata_o ( rom_rdata  )
    );
  end

  logic unused_write;
  assign unused_write = ^{s_axi_awaddr, s_axi_awprot, s_axi_wdata,
                          s_axi_wstrb, s_axi_arprot};

endmodule
