module rom_vw #(
    parameter int AxiAddrWidth = -1,
    parameter int AxiDataWidth = -1,
    parameter int AxiIdWidth   = -1,
    parameter int AxiUserWidth = 1
)(
    input  logic       clk           , // Clock
    input  logic       ndmreset_n    , // Asynchronous reset active low

    //AXI_BUS.Slave      rom   
    input ariane_axi::req_t    axi_req_i,
    output  ariane_axi::resp_t   axi_resp_o    
    );

axi_slave_connect_rev axi_slave_connect_rev(
    .axi_req_i ( axi_req_i ),
    .axi_resp_o ( axi_resp_o ),
    .slave ( rom[0] )
);
    
AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth     ),
    .AXI_DATA_WIDTH ( AxiDataWidth     ),
    .AXI_ID_WIDTH   ( AxiIdWidth      ),
    .AXI_USER_WIDTH ( AxiUserWidth     )
) rom[0:0]();

logic                    rom_req;
logic [AxiAddrWidth-1:0] rom_addr;
logic [AxiDataWidth-1:0] rom_rdata;

axi2mem #(
    .AXI_ID_WIDTH   ( AxiIdWidth ),
    .AXI_ADDR_WIDTH ( AxiAddrWidth     ),
    .AXI_DATA_WIDTH ( AxiDataWidth     ),
    .AXI_USER_WIDTH ( AxiUserWidth     )
) i_axi2rom (
    .clk_i  ( clk                     ),
    .rst_ni ( ndmreset_n              ),
    .slave  ( rom[0] ),//master[ariane_soc::ROM] ),
    .req_o  ( rom_req                 ),
    .we_o   (                         ),
    .addr_o ( rom_addr                ),
    .be_o   (                         ),
    .data_o (                         ),
    .data_i ( rom_rdata               )
);

bootrom i_bootrom (
    .clk_i   ( clk       ),
    .req_i   ( rom_req   ),
    .addr_i  ( rom_addr  ),
    .rdata_o ( rom_rdata )
);


endmodule
