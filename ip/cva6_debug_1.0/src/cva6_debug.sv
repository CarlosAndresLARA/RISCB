// SPDX-License-Identifier: Apache-2.0
// Source-backed RISC-V debug module with JTAG/DMI, an AXI4-Lite debug-memory
// slave, and an independent AXI4-Lite System Bus Access master.
module cva6_debug #(
  parameter int unsigned HART_COUNT             = 1,
  parameter int unsigned C_AXI_ADDR_WIDTH       = 32,
  parameter int unsigned C_AXI_DATA_WIDTH       = 32,
  parameter int unsigned DM_BASE_ADDRESS        = 32'h0000_1000,
  parameter logic [31:0] JTAG_IDCODE            = 32'h2495_11c3,
  parameter logic [HART_COUNT-1:0] SELECTABLE_HARTS = '1,
  parameter int unsigned HARTINFO_NSCRATCH      = 2,
  parameter int unsigned HARTINFO_DATAACCESS    = 1,
  parameter int unsigned HARTINFO_DATASIZE      = 2,
  parameter int unsigned HARTINFO_DATAADDR      = 12'h380
) (
  input  logic                              axi_aclk,
  input  logic                              axi_aresetn,
  input  logic                              testmode,

  input  logic                              jtag_tck,
  input  logic                              jtag_tms,
  input  logic                              jtag_trstn,
  input  logic                              jtag_tdi,
  output logic                              jtag_tdo,
  output logic                              jtag_tdo_oe,

  input  logic [HART_COUNT-1:0]             unavailable,
  output logic                              ndmreset,
  output logic                              dmactive,
  output logic [HART_COUNT-1:0]             debug_req,
  output logic                              sba_bus_error,

  input  logic [C_AXI_ADDR_WIDTH-1:0]       s_axi_awaddr,
  input  logic [2:0]                        s_axi_awprot,
  input  logic                              s_axi_awvalid,
  output logic                              s_axi_awready,
  input  logic [C_AXI_DATA_WIDTH-1:0]       s_axi_wdata,
  input  logic [(C_AXI_DATA_WIDTH/8)-1:0]   s_axi_wstrb,
  input  logic                              s_axi_wvalid,
  output logic                              s_axi_wready,
  output logic [1:0]                        s_axi_bresp,
  output logic                              s_axi_bvalid,
  input  logic                              s_axi_bready,
  input  logic [C_AXI_ADDR_WIDTH-1:0]       s_axi_araddr,
  input  logic [2:0]                        s_axi_arprot,
  input  logic                              s_axi_arvalid,
  output logic                              s_axi_arready,
  output logic [C_AXI_DATA_WIDTH-1:0]       s_axi_rdata,
  output logic [1:0]                        s_axi_rresp,
  output logic                              s_axi_rvalid,
  input  logic                              s_axi_rready,

  output logic [C_AXI_ADDR_WIDTH-1:0]       m_axi_awaddr,
  output logic [2:0]                        m_axi_awprot,
  output logic                              m_axi_awvalid,
  input  logic                              m_axi_awready,
  output logic [C_AXI_DATA_WIDTH-1:0]       m_axi_wdata,
  output logic [(C_AXI_DATA_WIDTH/8)-1:0]   m_axi_wstrb,
  output logic                              m_axi_wvalid,
  input  logic                              m_axi_wready,
  input  logic [1:0]                        m_axi_bresp,
  input  logic                              m_axi_bvalid,
  output logic                              m_axi_bready,
  output logic [C_AXI_ADDR_WIDTH-1:0]       m_axi_araddr,
  output logic [2:0]                        m_axi_arprot,
  output logic                              m_axi_arvalid,
  input  logic                              m_axi_arready,
  input  logic [C_AXI_DATA_WIDTH-1:0]       m_axi_rdata,
  input  logic [1:0]                        m_axi_rresp,
  input  logic                              m_axi_rvalid,
  output logic                              m_axi_rready
);

  logic dmi_req_valid, dmi_req_ready;
  logic dmi_resp_valid, dmi_resp_ready;
  dm::dmi_req_t dmi_req;
  dm::dmi_resp_t dmi_resp;

  logic dm_slave_valid, dm_slave_write;
  logic [C_AXI_ADDR_WIDTH-1:0] dm_slave_addr_axi;
  logic [C_AXI_DATA_WIDTH-1:0] dm_slave_wdata;
  logic [(C_AXI_DATA_WIDTH/8)-1:0] dm_slave_be;
  logic [C_AXI_DATA_WIDTH-1:0] dm_slave_rdata;
  logic dm_slave_issued_q;
  logic dm_slave_req;
  logic dm_slave_ready;

  logic dm_master_req, dm_master_we;
  logic [C_AXI_DATA_WIDTH-1:0] dm_master_addr;
  logic [C_AXI_DATA_WIDTH-1:0] dm_master_wdata;
  logic [(C_AXI_DATA_WIDTH/8)-1:0] dm_master_be;
  logic dm_master_gnt, dm_master_r_valid;
  logic [C_AXI_DATA_WIDTH-1:0] dm_master_rdata;

  dm::hartinfo_t [HART_COUNT-1:0] hartinfo;
  for (genvar hart = 0; hart < HART_COUNT; hart++) begin : gen_hartinfo
    assign hartinfo[hart] = '{
      zero1:      '0,
      nscratch:   4'(HARTINFO_NSCRATCH),
      zero0:      '0,
      dataaccess: 1'(HARTINFO_DATAACCESS),
      datasize:   4'(HARTINFO_DATASIZE),
      dataaddr:   12'(HARTINFO_DATAADDR)
    };
  end

  dmi_jtag #(
    .IdcodeValue (JTAG_IDCODE)
  ) i_dmi_jtag (
    .clk_i             (axi_aclk),
    .rst_ni            (axi_aresetn),
    .testmode_i        (testmode),
    .dmi_rst_no        (),
    .dmi_req_o         (dmi_req),
    .dmi_req_valid_o   (dmi_req_valid),
    .dmi_req_ready_i   (dmi_req_ready),
    .dmi_resp_i        (dmi_resp),
    .dmi_resp_ready_o  (dmi_resp_ready),
    .dmi_resp_valid_i  (dmi_resp_valid),
    .tck_i             (jtag_tck),
    .tms_i             (jtag_tms),
    .trst_ni           (jtag_trstn),
    .td_i              (jtag_tdi),
    .td_o              (jtag_tdo),
    .tdo_oe_o          (jtag_tdo_oe)
  );

  dm_top #(
    .NrHarts         (HART_COUNT),
    .BusWidth        (C_AXI_DATA_WIDTH),
    .DmBaseAddress   (DM_BASE_ADDRESS),
    .SelectableHarts (SELECTABLE_HARTS)
  ) i_dm_top (
    .clk_i            (axi_aclk),
    .rst_ni           (axi_aresetn),
    .testmode_i       (testmode),
    .ndmreset_o       (ndmreset),
    .dmactive_o       (dmactive),
    .debug_req_o      (debug_req),
    .unavailable_i    (unavailable),
    .hartinfo_i       (hartinfo),
    .slave_req_i      (dm_slave_req),
    .slave_we_i       (dm_slave_write),
    .slave_addr_i     (C_AXI_DATA_WIDTH'(dm_slave_addr_axi)),
    .slave_be_i       (dm_slave_be),
    .slave_wdata_i    (dm_slave_wdata),
    .slave_rdata_o    (dm_slave_rdata),
    .master_req_o     (dm_master_req),
    .master_add_o     (dm_master_addr),
    .master_we_o      (dm_master_we),
    .master_wdata_o   (dm_master_wdata),
    .master_be_o      (dm_master_be),
    .master_gnt_i     (dm_master_gnt),
    .master_r_valid_i (dm_master_r_valid),
    .master_r_rdata_i (dm_master_rdata),
    .dmi_rst_ni       (axi_aresetn),
    .dmi_req_valid_i  (dmi_req_valid),
    .dmi_req_ready_o  (dmi_req_ready),
    .dmi_req_i        (dmi_req),
    .dmi_resp_valid_o (dmi_resp_valid),
    .dmi_resp_ready_i (dmi_resp_ready),
    .dmi_resp_o       (dmi_resp)
  );

  // dm_mem returns read data one clock after req_i. Issue exactly one request
  // pulse, then acknowledge the held AXI-side request on the following cycle.
  assign dm_slave_req   = dm_slave_valid && !dm_slave_issued_q;
  assign dm_slave_ready = dm_slave_valid && dm_slave_issued_q;

  always_ff @(posedge axi_aclk or negedge axi_aresetn) begin
    if (!axi_aresetn) begin
      dm_slave_issued_q <= 1'b0;
    end else begin
      if (!dm_slave_valid) dm_slave_issued_q <= 1'b0;
      else if (!dm_slave_issued_q) dm_slave_issued_q <= 1'b1;
      else dm_slave_issued_q <= 1'b0;
    end
  end

  cva6_axil_to_reg #(
    .ADDR_WIDTH (C_AXI_ADDR_WIDTH),
    .DATA_WIDTH (C_AXI_DATA_WIDTH)
  ) i_debug_slave (
    .clk_i          (axi_aclk),
    .rst_ni         (axi_aresetn),
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
    .reg_valid_o    (dm_slave_valid),
    .reg_addr_o     (dm_slave_addr_axi),
    .reg_write_o    (dm_slave_write),
    .reg_wdata_o    (dm_slave_wdata),
    .reg_wstrb_o    (dm_slave_be),
    .reg_ready_i    (dm_slave_ready),
    .reg_rdata_i    (dm_slave_rdata),
    .reg_error_i    (1'b0)
  );

  cva6_reg_to_axil #(
    .ADDR_WIDTH (C_AXI_ADDR_WIDTH),
    .DATA_WIDTH (C_AXI_DATA_WIDTH)
  ) i_debug_master (
    .clk_i          (axi_aclk),
    .rst_ni         (axi_aresetn),
    .reg_req_i      (dm_master_req),
    .reg_addr_i     (C_AXI_ADDR_WIDTH'(dm_master_addr)),
    .reg_write_i    (dm_master_we),
    .reg_wdata_i    (dm_master_wdata),
    .reg_wstrb_i    (dm_master_be),
    .reg_gnt_o      (dm_master_gnt),
    .reg_rvalid_o   (dm_master_r_valid),
    .reg_rdata_o    (dm_master_rdata),
    .reg_error_o    (sba_bus_error),
    .m_axi_awaddr,
    .m_axi_awprot,
    .m_axi_awvalid,
    .m_axi_awready,
    .m_axi_wdata,
    .m_axi_wstrb,
    .m_axi_wvalid,
    .m_axi_wready,
    .m_axi_bresp,
    .m_axi_bvalid,
    .m_axi_bready,
    .m_axi_araddr,
    .m_axi_arprot,
    .m_axi_arvalid,
    .m_axi_arready,
    .m_axi_rdata,
    .m_axi_rresp,
    .m_axi_rvalid,
    .m_axi_rready
  );

endmodule
