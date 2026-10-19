module cva6_uart #(
  parameter int unsigned C_S_AXI_ADDR_WIDTH = 32,
  parameter int unsigned C_S_AXI_DATA_WIDTH = 32
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

  input  logic uart_rx_i,
  output logic uart_tx_o,
  output logic irq_o,
  input  logic cts_ni,
  input  logic dsr_ni,
  input  logic dcd_ni,
  input  logic ri_ni,
  output logic rts_no,
  output logic dtr_no,
  output logic out1_no,
  output logic out2_no
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

  apb_uart i_uart (
    .CLK     ( s_axi_aclk    ),
    .RSTN    ( s_axi_aresetn ),
    .PSEL    ( psel          ),
    .PENABLE ( penable       ),
    .PWRITE  ( pwrite        ),
    .PADDR   ( paddr[4:2]    ),
    .PWDATA  ( pwdata[31:0]  ),
    .PRDATA  ( prdata[31:0]  ),
    .PREADY  ( pready        ),
    .PSLVERR ( pslverr       ),
    .INT     ( irq_o         ),
    .OUT1N   ( out1_no       ),
    .OUT2N   ( out2_no       ),
    .RTSN    ( rts_no        ),
    .DTRN    ( dtr_no        ),
    .CTSN    ( cts_ni        ),
    .DSRN    ( dsr_ni        ),
    .DCDN    ( dcd_ni        ),
    .RIN     ( ri_ni         ),
    .SIN     ( uart_rx_i     ),
    .SOUT    ( uart_tx_o     )
  );

  if (C_S_AXI_DATA_WIDTH > 32) begin : gen_upper_prdata
    assign prdata[C_S_AXI_DATA_WIDTH-1:32] = '0;
  end

  logic unused_pstrb;
  assign unused_pstrb = ^pstrb;

endmodule
