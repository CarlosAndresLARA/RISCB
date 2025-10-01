module plic_vw #(
    parameter int AxiAddrWidth = -1,
    parameter int AxiDataWidth = -1,
    parameter int AxiIdWidth   = -1,
    parameter int AxiUserWidth = 1
)(
    input  logic       clk_i           , // Clock
    input  logic       rst_ni          , // Asynchronous reset active low

    //AXI_BUS.Slave      plic            ,
    input ariane_axi::req_t    axi_req_i,
    output  ariane_axi::resp_t   axi_resp_o,

    output logic [1:0] irq_o           ,
    input logic  [ariane_soc::NumSources-1:0] irq_sources    
    );

axi_slave_connect_rev axi_slave_connect_rev(
    .axi_req_i ( axi_req_i ),
    .axi_resp_o ( axi_resp_o ),
    .slave ( plic[0] )
);
    
AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth     ),
    .AXI_DATA_WIDTH ( AxiDataWidth     ),
    .AXI_ID_WIDTH   ( AxiIdWidth       ),
    .AXI_USER_WIDTH ( AxiUserWidth     )
) plic[0:0]();

    REG_BUS #(
        .ADDR_WIDTH ( 32 ),
        .DATA_WIDTH ( 32 )
    ) reg_bus (clk_i);

    logic         plic_penable;
    logic         plic_pwrite;
    logic [31:0]  plic_paddr;
    logic         plic_psel;
    logic [31:0]  plic_pwdata;
    logic [31:0]  plic_prdata;
    logic         plic_pready;
    logic         plic_pslverr;

    axi2apb_64_32 #(
        .AXI4_ADDRESS_WIDTH ( AxiAddrWidth  ),
        .AXI4_RDATA_WIDTH   ( AxiDataWidth  ),
        .AXI4_WDATA_WIDTH   ( AxiDataWidth  ),
        .AXI4_ID_WIDTH      ( AxiIdWidth    ),
        .AXI4_USER_WIDTH    ( AxiUserWidth  ),
        .BUFF_DEPTH_SLAVE   ( 2             ),
        .APB_ADDR_WIDTH     ( 32            )
    ) i_axi2apb_64_32_plic (
        .ACLK      ( clk_i          ),
        .ARESETn   ( rst_ni         ),
        .test_en_i ( 1'b0           ),
        .AWID_i    ( plic[0].aw_id     ),
        .AWADDR_i  ( plic[0].aw_addr   ),
        .AWLEN_i   ( plic[0].aw_len    ),
        .AWSIZE_i  ( plic[0].aw_size   ),
        .AWBURST_i ( plic[0].aw_burst  ),
        .AWLOCK_i  ( plic[0].aw_lock   ),
        .AWCACHE_i ( plic[0].aw_cache  ),
        .AWPROT_i  ( plic[0].aw_prot   ),
        .AWREGION_i( plic[0].aw_region ),
        .AWUSER_i  ( plic[0].aw_user   ),
        .AWQOS_i   ( plic[0].aw_qos    ),
        .AWVALID_i ( plic[0].aw_valid  ),
        .AWREADY_o ( plic[0].aw_ready  ),
        .WDATA_i   ( plic[0].w_data    ),
        .WSTRB_i   ( plic[0].w_strb    ),
        .WLAST_i   ( plic[0].w_last    ),
        .WUSER_i   ( plic[0].w_user    ),
        .WVALID_i  ( plic[0].w_valid   ),
        .WREADY_o  ( plic[0].w_ready   ),
        .BID_o     ( plic[0].b_id      ),
        .BRESP_o   ( plic[0].b_resp    ),
        .BVALID_o  ( plic[0].b_valid   ),
        .BUSER_o   ( plic[0].b_user    ),
        .BREADY_i  ( plic[0].b_ready   ),
        .ARID_i    ( plic[0].ar_id     ),
        .ARADDR_i  ( plic[0].ar_addr   ),
        .ARLEN_i   ( plic[0].ar_len    ),
        .ARSIZE_i  ( plic[0].ar_size   ),
        .ARBURST_i ( plic[0].ar_burst  ),
        .ARLOCK_i  ( plic[0].ar_lock   ),
        .ARCACHE_i ( plic[0].ar_cache  ),
        .ARPROT_i  ( plic[0].ar_prot   ),
        .ARREGION_i( plic[0].ar_region ),
        .ARUSER_i  ( plic[0].ar_user   ),
        .ARQOS_i   ( plic[0].ar_qos    ),
        .ARVALID_i ( plic[0].ar_valid  ),
        .ARREADY_o ( plic[0].ar_ready  ),
        .RID_o     ( plic[0].r_id      ),
        .RDATA_o   ( plic[0].r_data    ),
        .RRESP_o   ( plic[0].r_resp    ),
        .RLAST_o   ( plic[0].r_last    ),
        .RUSER_o   ( plic[0].r_user    ),
        .RVALID_o  ( plic[0].r_valid   ),
        .RREADY_i  ( plic[0].r_ready   ),
        .PENABLE   ( plic_penable   ),
        .PWRITE    ( plic_pwrite    ),
        .PADDR     ( plic_paddr     ),
        .PSEL      ( plic_psel      ),
        .PWDATA    ( plic_pwdata    ),
        .PRDATA    ( plic_prdata    ),
        .PREADY    ( plic_pready    ),
        .PSLVERR   ( plic_pslverr   )
    );

    apb_to_reg i_apb_to_reg (
        .clk_i     ( clk_i        ),
        .rst_ni    ( rst_ni       ),
        .penable_i ( plic_penable ),
        .pwrite_i  ( plic_pwrite  ),
        .paddr_i   ( plic_paddr   ),
        .psel_i    ( plic_psel    ),
        .pwdata_i  ( plic_pwdata  ),
        .prdata_o  ( plic_prdata  ),
        .pready_o  ( plic_pready  ),
        .pslverr_o ( plic_pslverr ),
        .reg_o     ( reg_bus      )
    );

    reg_intf::reg_intf_resp_d32 plic_resp;
    reg_intf::reg_intf_req_a32_d32 plic_req;

    assign plic_req.addr  = reg_bus.addr;
    assign plic_req.write = reg_bus.write;
    assign plic_req.wdata = reg_bus.wdata;
    assign plic_req.wstrb = reg_bus.wstrb;
    assign plic_req.valid = reg_bus.valid;

    assign reg_bus.rdata = plic_resp.rdata;
    assign reg_bus.error = plic_resp.error;
    assign reg_bus.ready = plic_resp.ready;

    plic_top #(
      .N_SOURCE    ( ariane_soc::NumSources  ),
      .N_TARGET    ( ariane_soc::NumTargets  ),
      .MAX_PRIO    ( ariane_soc::MaxPriority )
    ) i_plic (
      .clk_i,
      .rst_ni,
      .req_i         ( plic_req    ),
      .resp_o        ( plic_resp   ),
      .le_i          ( '0          ), // 0:level 1:edge
      .irq_sources_i ( irq_sources ),
      .eip_targets_o ( irq_o       )
    );
    
endmodule
