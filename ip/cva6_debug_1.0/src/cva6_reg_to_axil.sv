// Convert the single-request CVA6 debug system-bus port to AXI4-Lite.
// The request is granted once it has been captured; completion is reported
// only after the corresponding AXI B or R response has been accepted.
module cva6_reg_to_axil #(
  parameter int unsigned ADDR_WIDTH = 32,
  parameter int unsigned DATA_WIDTH = 32
) (
  input  logic                      clk_i,
  input  logic                      rst_ni,

  input  logic                      reg_req_i,
  input  logic [ADDR_WIDTH-1:0]     reg_addr_i,
  input  logic                      reg_write_i,
  input  logic [DATA_WIDTH-1:0]     reg_wdata_i,
  input  logic [(DATA_WIDTH/8)-1:0] reg_wstrb_i,
  output logic                      reg_gnt_o,
  output logic                      reg_rvalid_o,
  output logic [DATA_WIDTH-1:0]     reg_rdata_o,
  output logic                      reg_error_o,

  output logic [ADDR_WIDTH-1:0]     m_axi_awaddr,
  output logic [2:0]                m_axi_awprot,
  output logic                      m_axi_awvalid,
  input  logic                      m_axi_awready,
  output logic [DATA_WIDTH-1:0]     m_axi_wdata,
  output logic [(DATA_WIDTH/8)-1:0] m_axi_wstrb,
  output logic                      m_axi_wvalid,
  input  logic                      m_axi_wready,
  input  logic [1:0]                m_axi_bresp,
  input  logic                      m_axi_bvalid,
  output logic                      m_axi_bready,
  output logic [ADDR_WIDTH-1:0]     m_axi_araddr,
  output logic [2:0]                m_axi_arprot,
  output logic                      m_axi_arvalid,
  input  logic                      m_axi_arready,
  input  logic [DATA_WIDTH-1:0]     m_axi_rdata,
  input  logic [1:0]                m_axi_rresp,
  input  logic                      m_axi_rvalid,
  output logic                      m_axi_rready
);

  typedef enum logic [2:0] {
    IDLE, WRITE_CHANNELS, WRITE_RESPONSE, READ_ADDRESS, READ_RESPONSE
  } state_t;

  state_t state_q, state_d;
  logic [ADDR_WIDTH-1:0] addr_q;
  logic [DATA_WIDTH-1:0] wdata_q;
  logic [(DATA_WIDTH/8)-1:0] wstrb_q;
  logic aw_done_q, aw_done_d;
  logic w_done_q, w_done_d;
  logic aw_fire, w_fire;

  assign aw_fire = m_axi_awvalid && m_axi_awready;
  assign w_fire  = m_axi_wvalid  && m_axi_wready;

  always_comb begin
    state_d   = state_q;
    aw_done_d = aw_done_q;
    w_done_d  = w_done_q;

    reg_gnt_o    = 1'b0;
    reg_rvalid_o = 1'b0;
    reg_rdata_o  = '0;
    reg_error_o  = 1'b0;

    m_axi_awaddr  = addr_q;
    m_axi_awprot  = 3'b000;
    m_axi_awvalid = 1'b0;
    m_axi_wdata   = wdata_q;
    m_axi_wstrb   = wstrb_q;
    m_axi_wvalid  = 1'b0;
    m_axi_bready  = 1'b0;
    m_axi_araddr  = addr_q;
    m_axi_arprot  = 3'b000;
    m_axi_arvalid = 1'b0;
    m_axi_rready  = 1'b0;

    unique case (state_q)
      IDLE: begin
        reg_gnt_o = reg_req_i;
        if (reg_req_i) begin
          aw_done_d = 1'b0;
          w_done_d  = 1'b0;
          state_d   = reg_write_i ? WRITE_CHANNELS : READ_ADDRESS;
        end
      end

      WRITE_CHANNELS: begin
        m_axi_awvalid = !aw_done_q;
        m_axi_wvalid  = !w_done_q;
        if (aw_fire) aw_done_d = 1'b1;
        if (w_fire)  w_done_d  = 1'b1;
        if ((aw_done_q || aw_fire) && (w_done_q || w_fire)) begin
          state_d = WRITE_RESPONSE;
        end
      end

      WRITE_RESPONSE: begin
        m_axi_bready = 1'b1;
        if (m_axi_bvalid) begin
          reg_rvalid_o = 1'b1;
          reg_error_o  = (m_axi_bresp != 2'b00);
          state_d      = IDLE;
        end
      end

      READ_ADDRESS: begin
        m_axi_arvalid = 1'b1;
        if (m_axi_arready) state_d = READ_RESPONSE;
      end

      READ_RESPONSE: begin
        m_axi_rready = 1'b1;
        if (m_axi_rvalid) begin
          reg_rvalid_o = 1'b1;
          reg_rdata_o  = m_axi_rdata;
          reg_error_o  = (m_axi_rresp != 2'b00);
          state_d      = IDLE;
        end
      end

      default: state_d = IDLE;
    endcase
  end

  always_ff @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
      state_q   <= IDLE;
      addr_q    <= '0;
      wdata_q   <= '0;
      wstrb_q   <= '0;
      aw_done_q <= 1'b0;
      w_done_q  <= 1'b0;
    end else begin
      state_q   <= state_d;
      aw_done_q <= aw_done_d;
      w_done_q  <= w_done_d;
      if (state_q == IDLE && reg_req_i) begin
        addr_q  <= reg_addr_i;
        wdata_q <= reg_wdata_i;
        wstrb_q <= reg_wstrb_i;
      end
    end
  end

endmodule

