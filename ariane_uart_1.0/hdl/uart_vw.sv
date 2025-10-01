module uart_vw #(
    parameter int AxiAddrWidth = -1,
    parameter int AxiDataWidth = -1,
    parameter int AxiIdWidth   = -1,
    parameter int AxiUserWidth = 1,
    parameter bit InclUART    = 1
)(
    input  logic       clk_i           , // Clock
    input  logic       rst_ni          , // Asynchronous reset active low

    //AXI_BUS.Slave      uart            ,
    input ariane_axi::req_t    axi_req_i,
    output  ariane_axi::resp_t   axi_resp_o,

    input  logic       rx_i            ,
    output logic       tx_o            ,
    output logic       irq_sources      
    );

axi_slave_connect_rev axi_slave_connect_rev
(
    .axi_req_i ( axi_req_i ),
    .axi_resp_o ( axi_resp_o ),
    .slave ( uart[0] )
);
    
AXI_BUS #(
    .AXI_ADDR_WIDTH ( AxiAddrWidth     ),
    .AXI_DATA_WIDTH ( AxiDataWidth     ),
    .AXI_ID_WIDTH   ( AxiIdWidth      ),
    .AXI_USER_WIDTH ( AxiUserWidth     )
) uart[0:0]();
    
    logic         uart_penable;
    logic         uart_pwrite;
    logic [31:0]  uart_paddr;
    logic         uart_psel;
    logic [31:0]  uart_pwdata;
    logic [31:0]  uart_prdata;
    logic         uart_pready;
    logic         uart_pslverr;

    axi2apb_64_32 #(
        .AXI4_ADDRESS_WIDTH ( AxiAddrWidth ),
        .AXI4_RDATA_WIDTH   ( AxiDataWidth ),
        .AXI4_WDATA_WIDTH   ( AxiDataWidth ),
        .AXI4_ID_WIDTH      ( AxiIdWidth   ),
        .AXI4_USER_WIDTH    ( AxiUserWidth ),
        .BUFF_DEPTH_SLAVE   ( 2            ),
        .APB_ADDR_WIDTH     ( 32           )
    ) i_axi2apb_64_32_uart (
        .ACLK      ( clk_i          ),
        .ARESETn   ( rst_ni         ),
        .test_en_i ( 1'b0           ),
        .AWID_i    ( uart[0].aw_id     ),
        .AWADDR_i  ( uart[0].aw_addr   ),
        .AWLEN_i   ( uart[0].aw_len    ),
        .AWSIZE_i  ( uart[0].aw_size   ),
        .AWBURST_i ( uart[0].aw_burst  ),
        .AWLOCK_i  ( uart[0].aw_lock   ),
        .AWCACHE_i ( uart[0].aw_cache  ),
        .AWPROT_i  ( uart[0].aw_prot   ),
        .AWREGION_i( uart[0].aw_region ),
        .AWUSER_i  ( uart[0].aw_user   ),
        .AWQOS_i   ( uart[0].aw_qos    ),
        .AWVALID_i ( uart[0].aw_valid  ),
        .AWREADY_o ( uart[0].aw_ready  ),
        .WDATA_i   ( uart[0].w_data    ),
        .WSTRB_i   ( uart[0].w_strb    ),
        .WLAST_i   ( uart[0].w_last    ),
        .WUSER_i   ( uart[0].w_user    ),
        .WVALID_i  ( uart[0].w_valid   ),
        .WREADY_o  ( uart[0].w_ready   ),
        .BID_o     ( uart[0].b_id      ),
        .BRESP_o   ( uart[0].b_resp    ),
        .BVALID_o  ( uart[0].b_valid   ),
        .BUSER_o   ( uart[0].b_user    ),
        .BREADY_i  ( uart[0].b_ready   ),
        .ARID_i    ( uart[0].ar_id     ),
        .ARADDR_i  ( uart[0].ar_addr   ),
        .ARLEN_i   ( uart[0].ar_len    ),
        .ARSIZE_i  ( uart[0].ar_size   ),
        .ARBURST_i ( uart[0].ar_burst  ),
        .ARLOCK_i  ( uart[0].ar_lock   ),
        .ARCACHE_i ( uart[0].ar_cache  ),
        .ARPROT_i  ( uart[0].ar_prot   ),
        .ARREGION_i( uart[0].ar_region ),
        .ARUSER_i  ( uart[0].ar_user   ),
        .ARQOS_i   ( uart[0].ar_qos    ),
        .ARVALID_i ( uart[0].ar_valid  ),
        .ARREADY_o ( uart[0].ar_ready  ),
        .RID_o     ( uart[0].r_id      ),
        .RDATA_o   ( uart[0].r_data    ),
        .RRESP_o   ( uart[0].r_resp    ),
        .RLAST_o   ( uart[0].r_last    ),
        .RUSER_o   ( uart[0].r_user    ),
        .RVALID_o  ( uart[0].r_valid   ),
        .RREADY_i  ( uart[0].r_ready   ),
        .PENABLE   ( uart_penable   ),
        .PWRITE    ( uart_pwrite    ),
        .PADDR     ( uart_paddr     ),
        .PSEL      ( uart_psel      ),
        .PWDATA    ( uart_pwdata    ),
        .PRDATA    ( uart_prdata    ),
        .PREADY    ( uart_pready    ),
        .PSLVERR   ( uart_pslverr   )
    );

    if (InclUART) begin : gen_uart
        apb_uart i_apb_uart (
            .CLK     ( clk_i           ),
            .RSTN    ( rst_ni          ),
            .PSEL    ( uart_psel       ),
            .PENABLE ( uart_penable    ),
            .PWRITE  ( uart_pwrite     ),
            .PADDR   ( uart_paddr[4:2] ),
            .PWDATA  ( uart_pwdata     ),
            .PRDATA  ( uart_prdata     ),
            .PREADY  ( uart_pready     ),
            .PSLVERR ( uart_pslverr    ),
            .INT     ( irq_sources ),//[0]  ),
            .OUT1N   (                 ), // keep open
            .OUT2N   (                 ), // keep open
            .RTSN    (                 ), // no flow control
            .DTRN    (                 ), // no flow control
            .CTSN    ( 1'b0            ),
            .DSRN    ( 1'b0            ),
            .DCDN    ( 1'b0            ),
            .RIN     ( 1'b0            ),
            .SIN     ( rx_i            ),
            .SOUT    ( tx_o            )
        );
    end else begin
        /* pragma translate_off */
        `ifndef VERILATOR
        mock_uart i_mock_uart (
            .clk_i     ( clk_i        ),
            .rst_ni    ( rst_ni       ),
            .penable_i ( uart_penable ),
            .pwrite_i  ( uart_pwrite  ),
            .paddr_i   ( uart_paddr   ),
            .psel_i    ( uart_psel    ),
            .pwdata_i  ( uart_pwdata  ),
            .prdata_o  ( uart_prdata  ),
            .pready_o  ( uart_pready  ),
            .pslverr_o ( uart_pslverr )
        );
        `endif
        /* pragma translate_on */
    end
    
endmodule
