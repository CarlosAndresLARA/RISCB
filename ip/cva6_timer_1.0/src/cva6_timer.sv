module cva6_timer #(
  parameter int unsigned C_S_AXI_ADDR_WIDTH = 32,
  parameter int unsigned C_S_AXI_DATA_WIDTH = 32,
  parameter int unsigned TIMER_COUNT = 2
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
  output logic [(TIMER_COUNT*2)-1:0]        irq_o
);

  logic [C_S_AXI_ADDR_WIDTH-1:0] paddr;
  logic pwrite, psel, penable;
  logic [C_S_AXI_DATA_WIDTH-1:0] pwdata, prdata;
  logic [(C_S_AXI_DATA_WIDTH/8)-1:0] pstrb;
  logic pready, pslverr;

  cva6_axil_to_apb #(
    .ADDR_WIDTH ( C_S_AXI_ADDR_WIDTH ),
    .DATA_WIDTH ( C_S_AXI_DATA_WIDTH )
  ) i_axil_to_apb (
    .clk_i           ( s_axi_aclk    ),
    .rst_ni          ( s_axi_aresetn ),
    .s_axi_awaddr,
    .s_axi_awprot,
    .s_axi_awvalid,
    .s_axi_awready,
    .s_axi_wdata,
    .s_axi_wstrb,
    .s_axi_wvalid,
    .s_axi_wready,
    .s_axi_bresp,
    .s_axi_bvalid,
    .s_axi_bready,
    .s_axi_araddr,
    .s_axi_arprot,
    .s_axi_arvalid,
    .s_axi_arready,
    .s_axi_rdata,
    .s_axi_rresp,
    .s_axi_rvalid,
    .s_axi_rready,
    .paddr,
    .pwrite,
    .psel,
    .penable,
    .pwdata,
    .pstrb,
    .prdata,
    .pready,
    .pslverr
  );

  apb_timer #(
    .APB_ADDR_WIDTH ( C_S_AXI_ADDR_WIDTH ),
    .TIMER_CNT      ( TIMER_COUNT         )
  ) i_timer (
    .HCLK    ( s_axi_aclk    ),
    .HRESETn ( s_axi_aresetn ),
    .PADDR   ( paddr          ),
    .PWDATA  ( pwdata[31:0]   ),
    .PWRITE  ( pwrite         ),
    .PSEL    ( psel           ),
    .PENABLE ( penable        ),
    .PRDATA  ( prdata[31:0]   ),
    .PREADY  ( pready         ),
    .PSLVERR ( pslverr        ),
    .irq_o   ( irq_o          )
  );

  if (C_S_AXI_DATA_WIDTH > 32) begin : gen_upper_prdata
    assign prdata[C_S_AXI_DATA_WIDTH-1:32] = '0;
  end

  logic unused_pstrb;
  assign unused_pstrb = ^pstrb;

endmodule
