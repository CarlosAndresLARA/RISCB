module clint_vw #(
    parameter int AxiAddrWidth = -1,
    parameter int AxiDataWidth = -1,
    parameter int AxiIdWidth   = -1,
    parameter int AxiUserWidth = 1,
    parameter int unsigned NR_CORES       = 1
)(
    input  logic       clk           , // Clock
    input  logic       ndmreset_n    , // Asynchronous reset active low

    //AXI_BUS.Slave      clint         ,
    input ariane_axi::req_t    axi_req_i,
    output  ariane_axi::resp_t   axi_resp_o,
    
    input  logic       test_en       ,
    output logic [NR_CORES-1:0] timer_irq,
    output logic [NR_CORES-1:0] ipi     
    );
   
axi_slave_connect_rev axi_slave_connect(
    .axi_req_i ( axi_req_i ),
    .axi_resp_o ( axi_resp_o ),
    .slave ( clint[0] )
);
    
AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth     ),
    .AXI_DATA_WIDTH ( AxiDataWidth     ),
    .AXI_ID_WIDTH   ( AxiIdWidth      ),
    .AXI_USER_WIDTH ( AxiUserWidth     )
) clint[0:0]();
   
logic rtc;
    
always_ff @(posedge clk or negedge ndmreset_n) begin
  if (~ndmreset_n) begin
    rtc <= 0;
  end else begin
    rtc <= rtc ^ 1'b1;
  end
end

clint #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth     ),
    .AXI_DATA_WIDTH ( AxiDataWidth     ),
    .AXI_ID_WIDTH   ( AxiIdWidth ),
    .NR_CORES       ( 1                )
) i_clint (
    .clk_i       ( clk            ),
    .rst_ni      ( ndmreset_n     ),
    .testmode_i  ( test_en        ),
    .axi_req_i   ( axi_req_i  ),
    .axi_resp_o  ( axi_resp_o ),
    .rtc_i       ( rtc            ),
    .timer_irq_o ( timer_irq      ),
    .ipi_o       ( ipi            )
);

endmodule
