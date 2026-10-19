`include "typedef.svh"

module cva6_clint #(
  parameter int unsigned C_S_AXI_ADDR_WIDTH = 64,
  parameter int unsigned C_S_AXI_DATA_WIDTH = 64,
  parameter int unsigned CORE_COUNT = 1,
  parameter int unsigned RTC_TOGGLE_DIVIDER = 1
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
  input  logic                              s_axi_rready,

  input  logic                              testmode_i,
  output logic [CORE_COUNT-1:0]             timer_irq_o,
  output logic [CORE_COUNT-1:0]             software_irq_o
);

  typedef logic [C_S_AXI_ADDR_WIDTH-1:0] axi_addr_t;
  typedef logic [C_S_AXI_DATA_WIDTH-1:0] axi_data_t;
  typedef logic [(C_S_AXI_DATA_WIDTH/8)-1:0] axi_strb_t;
  typedef logic axi_id_t;
  typedef logic axi_user_t;
  `AXI_TYPEDEF_ALL(clint_axi, axi_addr_t, axi_id_t, axi_data_t,
                   axi_strb_t, axi_user_t)

  clint_axi_req_t clint_req;
  clint_axi_resp_t clint_rsp;

  localparam int unsigned RTC_COUNT_WIDTH =
    (RTC_TOGGLE_DIVIDER <= 1) ? 1 : $clog2(RTC_TOGGLE_DIVIDER);
  logic [RTC_COUNT_WIDTH-1:0] rtc_count_q;
  logic rtc_q;

  always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
    if (!s_axi_aresetn) begin
      rtc_count_q <= '0;
      rtc_q       <= 1'b0;
    end else if (rtc_count_q == RTC_TOGGLE_DIVIDER-1) begin
      rtc_count_q <= '0;
      rtc_q       <= ~rtc_q;
    end else begin
      rtc_count_q <= rtc_count_q + 1'b1;
    end
  end

  always_comb begin
    clint_req = '0;
    clint_req.aw.addr  = s_axi_awaddr;
    clint_req.aw.prot  = s_axi_awprot;
    clint_req.aw.size  = $clog2(C_S_AXI_DATA_WIDTH/8);
    clint_req.aw.burst = axi_pkg::BURST_INCR;
    clint_req.aw_valid = s_axi_awvalid;
    clint_req.w.data   = s_axi_wdata;
    clint_req.w.strb   = s_axi_wstrb;
    clint_req.w.last   = 1'b1;
    clint_req.w_valid  = s_axi_wvalid;
    clint_req.b_ready  = s_axi_bready;
    clint_req.ar.addr  = s_axi_araddr;
    clint_req.ar.prot  = s_axi_arprot;
    clint_req.ar.size  = $clog2(C_S_AXI_DATA_WIDTH/8);
    clint_req.ar.burst = axi_pkg::BURST_INCR;
    clint_req.ar_valid = s_axi_arvalid;
    clint_req.r_ready  = s_axi_rready;

    s_axi_awready = clint_rsp.aw_ready;
    s_axi_wready  = clint_rsp.w_ready;
    s_axi_bresp   = clint_rsp.b.resp;
    s_axi_bvalid  = clint_rsp.b_valid;
    s_axi_arready = clint_rsp.ar_ready;
    s_axi_rdata   = clint_rsp.r.data;
    s_axi_rresp   = clint_rsp.r.resp;
    s_axi_rvalid  = clint_rsp.r_valid;
  end

  clint #(
    .AXI_ADDR_WIDTH ( C_S_AXI_ADDR_WIDTH ),
    .AXI_DATA_WIDTH ( C_S_AXI_DATA_WIDTH ),
    .AXI_ID_WIDTH   ( 1                  ),
    .NR_CORES       ( CORE_COUNT         ),
    .axi_req_t      ( clint_axi_req_t    ),
    .axi_resp_t     ( clint_axi_resp_t   )
  ) i_clint (
    .clk_i       ( s_axi_aclk     ),
    .rst_ni      ( s_axi_aresetn  ),
    .testmode_i  ( testmode_i     ),
    .axi_req_i   ( clint_req      ),
    .axi_resp_o  ( clint_rsp      ),
    .rtc_i       ( rtc_q          ),
    .timer_irq_o ( timer_irq_o    ),
    .ipi_o       ( software_irq_o )
  );

endmodule
