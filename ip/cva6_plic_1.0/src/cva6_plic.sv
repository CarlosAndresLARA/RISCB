module cva6_plic #(
  parameter int unsigned C_S_AXI_ADDR_WIDTH = 32,
  parameter int unsigned C_S_AXI_DATA_WIDTH = 32,
  parameter int unsigned SOURCE_COUNT = 30,
  parameter int unsigned ACTIVE_SOURCE_COUNT = 7,
  parameter int unsigned TARGET_COUNT = 2,
  parameter int unsigned MAX_PRIORITY = 7,
  parameter logic [31:0] LEGACY_BASE_ADDRESS = 32'h0c00_0000,
  parameter logic [31:0] LOCAL_ADDRESS_MASK  = 32'h03ff_ffff
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

  input  logic [SOURCE_COUNT-1:0]           irq_sources_i,
  input  logic [SOURCE_COUNT-1:0]           irq_edge_i,
  output logic [TARGET_COUNT-1:0]           irq_targets_o
);

  typedef struct packed {
    logic [31:0] addr;
    logic        write;
    logic [31:0] wdata;
    logic [3:0]  wstrb;
    logic        valid;
  } plic_reg_req_t;

  typedef struct packed {
    logic [31:0] rdata;
    logic        error;
    logic        ready;
  } plic_reg_rsp_t;

  logic reg_valid, reg_write, reg_ready, reg_error;
  logic [C_S_AXI_ADDR_WIDTH-1:0] reg_addr;
  logic [C_S_AXI_DATA_WIDTH-1:0] reg_wdata, reg_rdata;
  logic [(C_S_AXI_DATA_WIDTH/8)-1:0] reg_wstrb;
  logic [SOURCE_COUNT-1:0] active_irq_sources;
  logic [SOURCE_COUNT-1:0] active_irq_edges;
  plic_reg_req_t plic_req;
  plic_reg_rsp_t plic_rsp;

  // Keep the Thales 30-source register/interface shape while allowing an OOC
  // implementation to discard sources that are tied off in a particular
  // system.  The Zybo baseline uses UART + two debug + four timer sources.
  // Raising ACTIVE_SOURCE_COUNT in IP Integrator enables additional inputs.
  for (genvar source_idx = 0; source_idx < SOURCE_COUNT; source_idx++) begin : gen_active_sources
    if (source_idx < ACTIVE_SOURCE_COUNT) begin : gen_enabled
      assign active_irq_sources[source_idx] = irq_sources_i[source_idx];
      assign active_irq_edges[source_idx]   = irq_edge_i[source_idx];
    end else begin : gen_disabled
      assign active_irq_sources[source_idx] = 1'b0;
      assign active_irq_edges[source_idx]   = 1'b0;
    end
  end

  cva6_axil_to_reg #(
    .ADDR_WIDTH ( C_S_AXI_ADDR_WIDTH ),
    .DATA_WIDTH ( C_S_AXI_DATA_WIDTH )
  ) i_axil_to_reg (
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
    .reg_valid_o ( reg_valid ),
    .reg_addr_o  ( reg_addr  ),
    .reg_write_o ( reg_write ),
    .reg_wdata_o ( reg_wdata ),
    .reg_wstrb_o ( reg_wstrb ),
    .reg_ready_i ( reg_ready ),
    .reg_rdata_i ( reg_rdata ),
    .reg_error_i ( reg_error )
  );

  // The generated Thales register map contains its historical absolute
  // 0x0c00_0000 addresses.  Retain that implementation while presenting a
  // relocatable AXI slave: only the segment-local offset reaches the map.
  always_comb begin
    plic_req.addr  = LEGACY_BASE_ADDRESS |
                     (32'(reg_addr) & LOCAL_ADDRESS_MASK);
    plic_req.write = reg_write;
    plic_req.wdata = 32'(reg_wdata);
    plic_req.wstrb = 4'(reg_wstrb);
    plic_req.valid = reg_valid;
    reg_ready = plic_rsp.ready;
    reg_rdata = C_S_AXI_DATA_WIDTH'(plic_rsp.rdata);
    reg_error = plic_rsp.error;
  end

  plic_top #(
    .N_SOURCE  ( SOURCE_COUNT   ),
    .N_TARGET  ( TARGET_COUNT   ),
    .MAX_PRIO  ( MAX_PRIORITY   ),
    .reg_req_t ( plic_reg_req_t ),
    .reg_rsp_t ( plic_reg_rsp_t )
  ) i_plic (
    .clk_i          ( s_axi_aclk    ),
    .rst_ni         ( s_axi_aresetn ),
    .req_i          ( plic_req      ),
    .resp_o         ( plic_rsp      ),
    .le_i           ( active_irq_edges   ),
    .irq_sources_i  ( active_irq_sources ),
    .eip_targets_o  ( irq_targets_o )
  );

endmodule
