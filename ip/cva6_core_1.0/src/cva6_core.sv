// SPDX-License-Identifier: Apache-2.0
//
// IP Integrator boundary for the CVA6 core.  The selected contest package is
// retained as the configuration profile, while the numeric parameters below
// override frequently changed fields before build_config derives the complete
// internal configuration.  They intentionally have no GUI range checks in
// this first packaging pass.

`include "rvfi_types.svh"
`include "cvxif_types.svh"

module cva6_core #(
  parameter int unsigned CORE_XLEN                 = 32,
  parameter int unsigned CORE_VLEN                 = 32,
  parameter int unsigned C_M_AXI_ADDR_WIDTH        = 64,
  parameter int unsigned C_M_AXI_DATA_WIDTH        = 64,
  parameter int unsigned C_M_AXI_ID_WIDTH          = 4,
  parameter int unsigned C_M_AXI_USER_WIDTH        = 32,

  parameter int unsigned A_EXT_ENABLE              = 0,
  parameter int unsigned C_EXT_ENABLE              = 0,
  parameter int unsigned CVXIF_ENABLE              = 0,
  parameter int unsigned RAS_DEPTH                 = 2,
  parameter int unsigned BTB_ENTRIES               = 32,
  parameter int unsigned BHT_ENTRIES               = 128,
  parameter int unsigned SCOREBOARD_ENTRIES        = 4,
  parameter int unsigned PMP_ENTRIES               = 8,
  parameter int unsigned MAX_OUTSTANDING_STORES    = 7,

  parameter int unsigned ICACHE_BYTE_SIZE          = 8192,
  parameter int unsigned ICACHE_SET_ASSOC          = 2,
  parameter int unsigned ICACHE_LINE_WIDTH         = 128,
  parameter int unsigned DCACHE_TYPE               = 2,
  parameter int unsigned DCACHE_BYTE_SIZE          = 16384,
  parameter int unsigned DCACHE_SET_ASSOC          = 4,
  parameter int unsigned DCACHE_LINE_WIDTH         = 128,
  parameter int unsigned DCACHE_ID_WIDTH           = 1,
  parameter int unsigned WT_DCACHE_WBUF_DEPTH      = 2,

  parameter logic [63:0] BOOT_ADDRESS              = 64'h0000_0000_0001_0000,
  parameter logic [63:0] HART_ID                   = 64'h0,
  parameter logic [63:0] DEBUG_BASE_ADDRESS        = 64'h0,
  parameter logic [63:0] DEBUG_HALT_ADDRESS        = 64'h800,
  parameter logic [63:0] DEBUG_EXCEPTION_ADDRESS   = 64'h808,

  parameter logic [63:0] NONIDEMPOTENT_BASE        = 64'h0,
  parameter logic [63:0] NONIDEMPOTENT_LENGTH      = 64'h8000_0000,
  parameter logic [63:0] EXECUTE_REGION0_BASE      = 64'h0,
  parameter logic [63:0] EXECUTE_REGION0_LENGTH    = 64'h1000,
  parameter logic [63:0] EXECUTE_REGION1_BASE      = 64'h0001_0000,
  parameter logic [63:0] EXECUTE_REGION1_LENGTH    = 64'h0001_0000,
  parameter logic [63:0] EXECUTE_REGION2_BASE      = 64'h8000_0000,
  parameter logic [63:0] EXECUTE_REGION2_LENGTH    = 64'h4000_0000,
  parameter logic [63:0] CACHED_REGION_BASE        = 64'h8000_0000,
  parameter logic [63:0] CACHED_REGION_LENGTH      = 64'h4000_0000
) (
  input  logic                              core_clk,
  input  logic                              core_resetn,
  input  logic [1:0]                        external_irq,
  input  logic                              software_irq,
  input  logic                              timer_irq,
  input  logic                              debug_req,

  output logic [C_M_AXI_ID_WIDTH-1:0]       m_axi_awid,
  output logic [C_M_AXI_ADDR_WIDTH-1:0]     m_axi_awaddr,
  output logic [7:0]                        m_axi_awlen,
  output logic [2:0]                        m_axi_awsize,
  output logic [1:0]                        m_axi_awburst,
  output logic                              m_axi_awlock,
  output logic [3:0]                        m_axi_awcache,
  output logic [2:0]                        m_axi_awprot,
  output logic [3:0]                        m_axi_awqos,
  output logic [3:0]                        m_axi_awregion,
  output logic [5:0]                        m_axi_awatop,
  output logic [C_M_AXI_USER_WIDTH-1:0]     m_axi_awuser,
  output logic                              m_axi_awvalid,
  input  logic                              m_axi_awready,

  output logic [C_M_AXI_DATA_WIDTH-1:0]     m_axi_wdata,
  output logic [(C_M_AXI_DATA_WIDTH/8)-1:0] m_axi_wstrb,
  output logic                              m_axi_wlast,
  output logic [C_M_AXI_USER_WIDTH-1:0]     m_axi_wuser,
  output logic                              m_axi_wvalid,
  input  logic                              m_axi_wready,

  input  logic [C_M_AXI_ID_WIDTH-1:0]       m_axi_bid,
  input  logic [1:0]                        m_axi_bresp,
  input  logic [C_M_AXI_USER_WIDTH-1:0]     m_axi_buser,
  input  logic                              m_axi_bvalid,
  output logic                              m_axi_bready,

  output logic [C_M_AXI_ID_WIDTH-1:0]       m_axi_arid,
  output logic [C_M_AXI_ADDR_WIDTH-1:0]     m_axi_araddr,
  output logic [7:0]                        m_axi_arlen,
  output logic [2:0]                        m_axi_arsize,
  output logic [1:0]                        m_axi_arburst,
  output logic                              m_axi_arlock,
  output logic [3:0]                        m_axi_arcache,
  output logic [2:0]                        m_axi_arprot,
  output logic [3:0]                        m_axi_arqos,
  output logic [3:0]                        m_axi_arregion,
  output logic [C_M_AXI_USER_WIDTH-1:0]     m_axi_aruser,
  output logic                              m_axi_arvalid,
  input  logic                              m_axi_arready,

  input  logic [C_M_AXI_ID_WIDTH-1:0]       m_axi_rid,
  input  logic [C_M_AXI_DATA_WIDTH-1:0]     m_axi_rdata,
  input  logic [1:0]                        m_axi_rresp,
  input  logic                              m_axi_rlast,
  input  logic [C_M_AXI_USER_WIDTH-1:0]     m_axi_ruser,
  input  logic                              m_axi_rvalid,
  output logic                              m_axi_rready
);

  function automatic config_pkg::cva6_cfg_t make_core_config(
    config_pkg::cva6_user_cfg_t profile
  );
    config_pkg::cva6_user_cfg_t cfg;
    cfg = profile;

    cfg.XLEN                    = unsigned'(CORE_XLEN);
    cfg.VLEN                    = unsigned'(CORE_VLEN);
    cfg.AxiAddrWidth            = unsigned'(C_M_AXI_ADDR_WIDTH);
    cfg.AxiDataWidth            = unsigned'(C_M_AXI_DATA_WIDTH);
    cfg.AxiIdWidth              = unsigned'(C_M_AXI_ID_WIDTH);
    cfg.AxiUserWidth            = unsigned'(C_M_AXI_USER_WIDTH);
    cfg.RVA                     = bit'(A_EXT_ENABLE);
    cfg.RVC                     = bit'(C_EXT_ENABLE);
    cfg.CvxifEn                 = bit'(CVXIF_ENABLE);
    cfg.RASDepth                = unsigned'(RAS_DEPTH);
    cfg.BTBEntries              = unsigned'(BTB_ENTRIES);
    cfg.BHTEntries              = unsigned'(BHT_ENTRIES);
    cfg.NrScoreboardEntries     = unsigned'(SCOREBOARD_ENTRIES);
    cfg.NrPMPEntries            = unsigned'(PMP_ENTRIES);
    cfg.MaxOutstandingStores    = unsigned'(MAX_OUTSTANDING_STORES);

    cfg.IcacheByteSize          = unsigned'(ICACHE_BYTE_SIZE);
    cfg.IcacheSetAssoc          = unsigned'(ICACHE_SET_ASSOC);
    cfg.IcacheLineWidth         = unsigned'(ICACHE_LINE_WIDTH);
    cfg.DCacheType              = config_pkg::cache_type_t'(DCACHE_TYPE);
    cfg.DcacheByteSize          = unsigned'(DCACHE_BYTE_SIZE);
    cfg.DcacheSetAssoc          = unsigned'(DCACHE_SET_ASSOC);
    cfg.DcacheLineWidth         = unsigned'(DCACHE_LINE_WIDTH);
    cfg.DcacheIdWidth           = unsigned'(DCACHE_ID_WIDTH);
    cfg.WtDcacheWbufDepth       = int'(WT_DCACHE_WBUF_DEPTH);

    cfg.DmBaseAddress           = DEBUG_BASE_ADDRESS;
    cfg.HaltAddress             = DEBUG_HALT_ADDRESS;
    cfg.ExceptionAddress        = DEBUG_EXCEPTION_ADDRESS;
    cfg.NrNonIdempotentRules    = unsigned'(1);
    cfg.NonIdempotentAddrBase   = 1024'({NONIDEMPOTENT_BASE});
    cfg.NonIdempotentLength     = 1024'({NONIDEMPOTENT_LENGTH});
    cfg.NrExecuteRegionRules    = unsigned'(3);
    cfg.ExecuteRegionAddrBase   = 1024'({EXECUTE_REGION2_BASE,
                                         EXECUTE_REGION1_BASE,
                                         EXECUTE_REGION0_BASE});
    cfg.ExecuteRegionLength     = 1024'({EXECUTE_REGION2_LENGTH,
                                         EXECUTE_REGION1_LENGTH,
                                         EXECUTE_REGION0_LENGTH});
    cfg.NrCachedRegionRules     = unsigned'(1);
    cfg.CachedRegionAddrBase    = 1024'({CACHED_REGION_BASE});
    cfg.CachedRegionLength      = 1024'({CACHED_REGION_LENGTH});
    cfg.NOCType                 = config_pkg::NOC_TYPE_AXI4_ATOP;

    return build_config_pkg::build_config(cfg);
  endfunction

  localparam config_pkg::cva6_cfg_t CVA6Cfg =
    make_core_config(cva6_config_pkg::cva6_cfg);

  localparam type rvfi_probes_instr_t = `RVFI_PROBES_INSTR_T(CVA6Cfg);
  localparam type rvfi_probes_csr_t   = `RVFI_PROBES_CSR_T(CVA6Cfg);
  localparam type rvfi_probes_t = struct packed {
    logic csr;
    logic instr;
  };

  typedef logic [C_M_AXI_ID_WIDTH-1:0]   axi_id_t;
  typedef logic [C_M_AXI_ADDR_WIDTH-1:0] axi_addr_t;
  typedef logic [C_M_AXI_DATA_WIDTH-1:0] axi_data_t;
  typedef logic [(C_M_AXI_DATA_WIDTH/8)-1:0] axi_strb_t;
  typedef logic [C_M_AXI_USER_WIDTH-1:0] axi_user_t;

  typedef struct packed {
    axi_id_t id;
    axi_addr_t addr;
    axi_pkg::len_t len;
    axi_pkg::size_t size;
    axi_pkg::burst_t burst;
    logic lock;
    axi_pkg::cache_t cache;
    axi_pkg::prot_t prot;
    axi_pkg::qos_t qos;
    axi_pkg::region_t region;
    axi_pkg::atop_t atop;
    axi_user_t user;
  } axi_aw_t;

  typedef struct packed {
    axi_id_t id;
    axi_addr_t addr;
    axi_pkg::len_t len;
    axi_pkg::size_t size;
    axi_pkg::burst_t burst;
    logic lock;
    axi_pkg::cache_t cache;
    axi_pkg::prot_t prot;
    axi_pkg::qos_t qos;
    axi_pkg::region_t region;
    axi_user_t user;
  } axi_ar_t;

  typedef struct packed {
    axi_data_t data;
    axi_strb_t strb;
    logic last;
    axi_user_t user;
  } axi_w_t;

  typedef struct packed {
    axi_id_t id;
    axi_pkg::resp_t resp;
    axi_user_t user;
  } axi_b_t;

  typedef struct packed {
    axi_id_t id;
    axi_data_t data;
    axi_pkg::resp_t resp;
    logic last;
    axi_user_t user;
  } axi_r_t;

  typedef struct packed {
    axi_aw_t aw;
    logic aw_valid;
    axi_w_t w;
    logic w_valid;
    logic b_ready;
    axi_ar_t ar;
    logic ar_valid;
    logic r_ready;
  } axi_req_t;

  typedef struct packed {
    logic aw_ready;
    logic ar_ready;
    logic w_ready;
    logic b_valid;
    axi_b_t b;
    logic r_valid;
    axi_r_t r;
  } axi_resp_t;

  axi_req_t core_axi_req;
  axi_resp_t core_axi_resp;

  ariane #(
    .CVA6Cfg             (CVA6Cfg),
    .rvfi_probes_instr_t (rvfi_probes_instr_t),
    .rvfi_probes_csr_t   (rvfi_probes_csr_t),
    .rvfi_probes_t       (rvfi_probes_t),
    .AxiAddrWidth        (C_M_AXI_ADDR_WIDTH),
    .AxiDataWidth        (C_M_AXI_DATA_WIDTH),
    .AxiIdWidth          (C_M_AXI_ID_WIDTH),
    .axi_ar_chan_t       (axi_ar_t),
    .axi_aw_chan_t       (axi_aw_t),
    .axi_w_chan_t        (axi_w_t),
    .noc_req_t           (axi_req_t),
    .noc_resp_t          (axi_resp_t)
  ) i_ariane (
    .clk_i         (core_clk),
    .rst_ni        (core_resetn),
    .boot_addr_i   (CORE_VLEN'(BOOT_ADDRESS)),
    .hart_id_i     (CORE_XLEN'(HART_ID)),
    .irq_i         (external_irq),
    .ipi_i         (software_irq),
    .time_irq_i    (timer_irq),
    .debug_req_i   (debug_req),
    .rvfi_probes_o (),
    .noc_req_o     (core_axi_req),
    .noc_resp_i    (core_axi_resp)
  );

  always_comb begin
    m_axi_awid     = core_axi_req.aw.id;
    m_axi_awaddr   = core_axi_req.aw.addr;
    m_axi_awlen    = core_axi_req.aw.len;
    m_axi_awsize   = core_axi_req.aw.size;
    m_axi_awburst  = core_axi_req.aw.burst;
    m_axi_awlock   = core_axi_req.aw.lock;
    m_axi_awcache  = core_axi_req.aw.cache;
    m_axi_awprot   = core_axi_req.aw.prot;
    m_axi_awqos    = core_axi_req.aw.qos;
    m_axi_awregion = core_axi_req.aw.region;
    m_axi_awatop   = core_axi_req.aw.atop;
    m_axi_awuser   = core_axi_req.aw.user;
    m_axi_awvalid  = core_axi_req.aw_valid;

    m_axi_wdata    = core_axi_req.w.data;
    m_axi_wstrb    = core_axi_req.w.strb;
    m_axi_wlast    = core_axi_req.w.last;
    m_axi_wuser    = core_axi_req.w.user;
    m_axi_wvalid   = core_axi_req.w_valid;
    m_axi_bready   = core_axi_req.b_ready;

    m_axi_arid     = core_axi_req.ar.id;
    m_axi_araddr   = core_axi_req.ar.addr;
    m_axi_arlen    = core_axi_req.ar.len;
    m_axi_arsize   = core_axi_req.ar.size;
    m_axi_arburst  = core_axi_req.ar.burst;
    m_axi_arlock   = core_axi_req.ar.lock;
    m_axi_arcache  = core_axi_req.ar.cache;
    m_axi_arprot   = core_axi_req.ar.prot;
    m_axi_arqos    = core_axi_req.ar.qos;
    m_axi_arregion = core_axi_req.ar.region;
    m_axi_aruser   = core_axi_req.ar.user;
    m_axi_arvalid  = core_axi_req.ar_valid;
    m_axi_rready   = core_axi_req.r_ready;

    core_axi_resp.aw_ready = m_axi_awready;
    core_axi_resp.w_ready  = m_axi_wready;
    core_axi_resp.b_valid  = m_axi_bvalid;
    core_axi_resp.b.id     = m_axi_bid;
    core_axi_resp.b.resp   = axi_pkg::resp_t'(m_axi_bresp);
    core_axi_resp.b.user   = m_axi_buser;
    core_axi_resp.ar_ready = m_axi_arready;
    core_axi_resp.r_valid  = m_axi_rvalid;
    core_axi_resp.r.id     = m_axi_rid;
    core_axi_resp.r.data   = m_axi_rdata;
    core_axi_resp.r.resp   = axi_pkg::resp_t'(m_axi_rresp);
    core_axi_resp.r.last   = m_axi_rlast;
    core_axi_resp.r.user   = m_axi_ruser;
  end

endmodule
