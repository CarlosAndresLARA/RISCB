// SPDX-License-Identifier: Apache-2.0
//
// IP Integrator wrapper for the CVA6/PULP RISC-V atomics adapter.
//
// AXI4 does not standardize the AXI5 AWATOP signal used by CVA6 to encode
// RISC-V AMOs.  It is therefore deliberately exposed as a discrete input on
// the core-facing side.  The atomics implementation consumes AWATOP and the
// downstream M_AXI interface is conventional AXI4 suitable for AMD IP.

module cva6_axi_atomics #(
  parameter int unsigned C_AXI_ADDR_WIDTH      = 64,
  parameter int unsigned C_AXI_DATA_WIDTH      = 64,
  parameter int unsigned C_AXI_ID_WIDTH        = 4,
  parameter int unsigned C_AXI_USER_WIDTH      = 32,
  parameter int unsigned AXI_MAX_WRITE_TXNS    = 1,
  parameter int unsigned RISCV_WORD_WIDTH      = 64,
  parameter int unsigned CUT_S_AXI             = 1
) (
  input  logic                              axi_aclk,
  input  logic                              axi_aresetn,

  input  logic [C_AXI_ID_WIDTH-1:0]         s_axi_awid,
  input  logic [C_AXI_ADDR_WIDTH-1:0]       s_axi_awaddr,
  input  logic [7:0]                        s_axi_awlen,
  input  logic [2:0]                        s_axi_awsize,
  input  logic [1:0]                        s_axi_awburst,
  input  logic                              s_axi_awlock,
  input  logic [3:0]                        s_axi_awcache,
  input  logic [2:0]                        s_axi_awprot,
  input  logic [3:0]                        s_axi_awqos,
  input  logic [3:0]                        s_axi_awregion,
  input  logic [C_AXI_USER_WIDTH-1:0]       s_axi_awuser,
  input  logic [5:0]                        s_axi_awatop,
  input  logic                              s_axi_awvalid,
  output logic                              s_axi_awready,

  input  logic [C_AXI_DATA_WIDTH-1:0]       s_axi_wdata,
  input  logic [(C_AXI_DATA_WIDTH/8)-1:0]   s_axi_wstrb,
  input  logic                              s_axi_wlast,
  input  logic [C_AXI_USER_WIDTH-1:0]       s_axi_wuser,
  input  logic                              s_axi_wvalid,
  output logic                              s_axi_wready,

  output logic [C_AXI_ID_WIDTH-1:0]         s_axi_bid,
  output logic [1:0]                        s_axi_bresp,
  output logic [C_AXI_USER_WIDTH-1:0]       s_axi_buser,
  output logic                              s_axi_bvalid,
  input  logic                              s_axi_bready,

  input  logic [C_AXI_ID_WIDTH-1:0]         s_axi_arid,
  input  logic [C_AXI_ADDR_WIDTH-1:0]       s_axi_araddr,
  input  logic [7:0]                        s_axi_arlen,
  input  logic [2:0]                        s_axi_arsize,
  input  logic [1:0]                        s_axi_arburst,
  input  logic                              s_axi_arlock,
  input  logic [3:0]                        s_axi_arcache,
  input  logic [2:0]                        s_axi_arprot,
  input  logic [3:0]                        s_axi_arqos,
  input  logic [3:0]                        s_axi_arregion,
  input  logic [C_AXI_USER_WIDTH-1:0]       s_axi_aruser,
  input  logic                              s_axi_arvalid,
  output logic                              s_axi_arready,

  output logic [C_AXI_ID_WIDTH-1:0]         s_axi_rid,
  output logic [C_AXI_DATA_WIDTH-1:0]       s_axi_rdata,
  output logic [1:0]                        s_axi_rresp,
  output logic                              s_axi_rlast,
  output logic [C_AXI_USER_WIDTH-1:0]       s_axi_ruser,
  output logic                              s_axi_rvalid,
  input  logic                              s_axi_rready,

  output logic [C_AXI_ID_WIDTH-1:0]         m_axi_awid,
  output logic [C_AXI_ADDR_WIDTH-1:0]       m_axi_awaddr,
  output logic [7:0]                        m_axi_awlen,
  output logic [2:0]                        m_axi_awsize,
  output logic [1:0]                        m_axi_awburst,
  output logic                              m_axi_awlock,
  output logic [3:0]                        m_axi_awcache,
  output logic [2:0]                        m_axi_awprot,
  output logic [3:0]                        m_axi_awqos,
  output logic [3:0]                        m_axi_awregion,
  output logic                              m_axi_awvalid,
  input  logic                              m_axi_awready,

  output logic [C_AXI_DATA_WIDTH-1:0]       m_axi_wdata,
  output logic [(C_AXI_DATA_WIDTH/8)-1:0]   m_axi_wstrb,
  output logic                              m_axi_wlast,
  output logic                              m_axi_wvalid,
  input  logic                              m_axi_wready,

  input  logic [C_AXI_ID_WIDTH-1:0]         m_axi_bid,
  input  logic [1:0]                        m_axi_bresp,
  input  logic                              m_axi_bvalid,
  output logic                              m_axi_bready,

  output logic [C_AXI_ID_WIDTH-1:0]         m_axi_arid,
  output logic [C_AXI_ADDR_WIDTH-1:0]       m_axi_araddr,
  output logic [7:0]                        m_axi_arlen,
  output logic [2:0]                        m_axi_arsize,
  output logic [1:0]                        m_axi_arburst,
  output logic                              m_axi_arlock,
  output logic [3:0]                        m_axi_arcache,
  output logic [2:0]                        m_axi_arprot,
  output logic [3:0]                        m_axi_arqos,
  output logic [3:0]                        m_axi_arregion,
  output logic                              m_axi_arvalid,
  input  logic                              m_axi_arready,

  input  logic [C_AXI_ID_WIDTH-1:0]         m_axi_rid,
  input  logic [C_AXI_DATA_WIDTH-1:0]       m_axi_rdata,
  input  logic [1:0]                        m_axi_rresp,
  input  logic                              m_axi_rlast,
  input  logic                              m_axi_rvalid,
  output logic                              m_axi_rready
);

  typedef struct packed {
    logic [C_AXI_ID_WIDTH-1:0]   id;
    logic [C_AXI_ADDR_WIDTH-1:0] addr;
    logic [7:0]                  len;
    logic [2:0]                  size;
    logic [1:0]                  burst;
    logic                        lock;
    logic [3:0]                  cache;
    logic [2:0]                  prot;
    logic [3:0]                  qos;
    logic [3:0]                  region;
    logic [5:0]                  atop;
    logic [C_AXI_USER_WIDTH-1:0] user;
  } aw_payload_t;

  typedef struct packed {
    logic [C_AXI_DATA_WIDTH-1:0]     data;
    logic [(C_AXI_DATA_WIDTH/8)-1:0] strb;
    logic                            last;
    logic [C_AXI_USER_WIDTH-1:0]     user;
  } w_payload_t;

  typedef struct packed {
    logic [C_AXI_ID_WIDTH-1:0]   id;
    logic [1:0]                  resp;
    logic [C_AXI_USER_WIDTH-1:0] user;
  } b_payload_t;

  typedef struct packed {
    logic [C_AXI_ID_WIDTH-1:0]   id;
    logic [C_AXI_ADDR_WIDTH-1:0] addr;
    logic [7:0]                  len;
    logic [2:0]                  size;
    logic [1:0]                  burst;
    logic                        lock;
    logic [3:0]                  cache;
    logic [2:0]                  prot;
    logic [3:0]                  qos;
    logic [3:0]                  region;
    logic [C_AXI_USER_WIDTH-1:0] user;
  } ar_payload_t;

  typedef struct packed {
    logic [C_AXI_ID_WIDTH-1:0]   id;
    logic [C_AXI_DATA_WIDTH-1:0] data;
    logic [1:0]                  resp;
    logic                        last;
    logic [C_AXI_USER_WIDTH-1:0] user;
  } r_payload_t;

  aw_payload_t uncut_aw, cut_aw;
  w_payload_t uncut_w, cut_w;
  ar_payload_t uncut_ar, cut_ar;
  b_payload_t atomics_b, cut_b;
  r_payload_t atomics_r, cut_r;
  logic cut_aw_valid, atomics_aw_ready;
  logic cut_w_valid, atomics_w_ready;
  logic cut_ar_valid, atomics_ar_ready;
  logic atomics_b_valid, atomics_b_ready;
  logic atomics_r_valid, atomics_r_ready;

  always_comb begin
    uncut_aw.id     = s_axi_awid;
    uncut_aw.addr   = s_axi_awaddr;
    uncut_aw.len    = s_axi_awlen;
    uncut_aw.size   = s_axi_awsize;
    uncut_aw.burst  = s_axi_awburst;
    uncut_aw.lock   = s_axi_awlock;
    uncut_aw.cache  = s_axi_awcache;
    uncut_aw.prot   = s_axi_awprot;
    uncut_aw.qos    = s_axi_awqos;
    uncut_aw.region = s_axi_awregion;
    uncut_aw.atop   = s_axi_awatop;
    uncut_aw.user   = s_axi_awuser;

    uncut_w.data = s_axi_wdata;
    uncut_w.strb = s_axi_wstrb;
    uncut_w.last = s_axi_wlast;
    uncut_w.user = s_axi_wuser;

    uncut_ar.id     = s_axi_arid;
    uncut_ar.addr   = s_axi_araddr;
    uncut_ar.len    = s_axi_arlen;
    uncut_ar.size   = s_axi_arsize;
    uncut_ar.burst  = s_axi_arburst;
    uncut_ar.lock   = s_axi_arlock;
    uncut_ar.cache  = s_axi_arcache;
    uncut_ar.prot   = s_axi_arprot;
    uncut_ar.qos    = s_axi_arqos;
    uncut_ar.region = s_axi_arregion;
    uncut_ar.user   = s_axi_aruser;
  end

  assign s_axi_bid   = cut_b.id;
  assign s_axi_bresp = cut_b.resp;
  assign s_axi_buser = cut_b.user;
  assign s_axi_rid   = cut_r.id;
  assign s_axi_rdata = cut_r.data;
  assign s_axi_rresp = cut_r.resp;
  assign s_axi_rlast = cut_r.last;
  assign s_axi_ruser = cut_r.user;

  // The monolithic Thales crossbar used CUT_ALL_PORTS.  Preserve that
  // combinational-path break before consuming AWATOP; native AXI4 register
  // slices cannot transport the non-standard field alongside the AW channel.
  spill_register #(
    .T      (aw_payload_t),
    .Bypass (CUT_S_AXI == 0)
  ) i_cut_aw (
    .clk_i   (axi_aclk),
    .rst_ni  (axi_aresetn),
    .valid_i (s_axi_awvalid),
    .ready_o (s_axi_awready),
    .data_i  (uncut_aw),
    .valid_o (cut_aw_valid),
    .ready_i (atomics_aw_ready),
    .data_o  (cut_aw)
  );

  spill_register #(
    .T      (w_payload_t),
    .Bypass (CUT_S_AXI == 0)
  ) i_cut_w (
    .clk_i   (axi_aclk),
    .rst_ni  (axi_aresetn),
    .valid_i (s_axi_wvalid),
    .ready_o (s_axi_wready),
    .data_i  (uncut_w),
    .valid_o (cut_w_valid),
    .ready_i (atomics_w_ready),
    .data_o  (cut_w)
  );

  spill_register #(
    .T      (ar_payload_t),
    .Bypass (CUT_S_AXI == 0)
  ) i_cut_ar (
    .clk_i   (axi_aclk),
    .rst_ni  (axi_aresetn),
    .valid_i (s_axi_arvalid),
    .ready_o (s_axi_arready),
    .data_i  (uncut_ar),
    .valid_o (cut_ar_valid),
    .ready_i (atomics_ar_ready),
    .data_o  (cut_ar)
  );

  spill_register #(
    .T      (b_payload_t),
    .Bypass (CUT_S_AXI == 0)
  ) i_cut_b (
    .clk_i   (axi_aclk),
    .rst_ni  (axi_aresetn),
    .valid_i (atomics_b_valid),
    .ready_o (atomics_b_ready),
    .data_i  (atomics_b),
    .valid_o (s_axi_bvalid),
    .ready_i (s_axi_bready),
    .data_o  (cut_b)
  );

  spill_register #(
    .T      (r_payload_t),
    .Bypass (CUT_S_AXI == 0)
  ) i_cut_r (
    .clk_i   (axi_aclk),
    .rst_ni  (axi_aresetn),
    .valid_i (atomics_r_valid),
    .ready_o (atomics_r_ready),
    .data_i  (atomics_r),
    .valid_o (s_axi_rvalid),
    .ready_i (s_axi_rready),
    .data_o  (cut_r)
  );

  // The AMO and LR/SC stages consume every atomic operation.  Their final
  // AWATOP output is consequently zero and intentionally does not cross the
  // conventional M_AXI boundary. The contest configuration also disables
  // AXI user semantics, so optional user fields stop at this boundary rather
  // than forcing every native AMD endpoint to carry unused 32-bit sidebands.
  logic [5:0] consumed_m_axi_awatop;
  logic [C_AXI_USER_WIDTH-1:0] unused_m_axi_awuser;
  logic [C_AXI_USER_WIDTH-1:0] unused_m_axi_wuser;
  logic [C_AXI_USER_WIDTH-1:0] unused_m_axi_aruser;

  axi_riscv_atomics #(
    .AXI_ADDR_WIDTH      (C_AXI_ADDR_WIDTH),
    .AXI_DATA_WIDTH      (C_AXI_DATA_WIDTH),
    .AXI_ID_WIDTH        (C_AXI_ID_WIDTH),
    .AXI_USER_WIDTH      (C_AXI_USER_WIDTH),
    .AXI_MAX_WRITE_TXNS  (AXI_MAX_WRITE_TXNS),
    .RISCV_WORD_WIDTH    (RISCV_WORD_WIDTH)
  ) i_axi_riscv_atomics (
    .clk_i               (axi_aclk),
    .rst_ni              (axi_aresetn),

    .slv_aw_addr_i       (cut_aw.addr),
    .slv_aw_prot_i       (cut_aw.prot),
    .slv_aw_region_i     (cut_aw.region),
    .slv_aw_atop_i       (cut_aw.atop),
    .slv_aw_len_i        (cut_aw.len),
    .slv_aw_size_i       (cut_aw.size),
    .slv_aw_burst_i      (cut_aw.burst),
    .slv_aw_lock_i       (cut_aw.lock),
    .slv_aw_cache_i      (cut_aw.cache),
    .slv_aw_qos_i        (cut_aw.qos),
    .slv_aw_id_i         (cut_aw.id),
    .slv_aw_user_i       (cut_aw.user),
    .slv_aw_ready_o      (atomics_aw_ready),
    .slv_aw_valid_i      (cut_aw_valid),
    .slv_ar_addr_i       (cut_ar.addr),
    .slv_ar_prot_i       (cut_ar.prot),
    .slv_ar_region_i     (cut_ar.region),
    .slv_ar_len_i        (cut_ar.len),
    .slv_ar_size_i       (cut_ar.size),
    .slv_ar_burst_i      (cut_ar.burst),
    .slv_ar_lock_i       (cut_ar.lock),
    .slv_ar_cache_i      (cut_ar.cache),
    .slv_ar_qos_i        (cut_ar.qos),
    .slv_ar_id_i         (cut_ar.id),
    .slv_ar_user_i       (cut_ar.user),
    .slv_ar_ready_o      (atomics_ar_ready),
    .slv_ar_valid_i      (cut_ar_valid),
    .slv_w_data_i        (cut_w.data),
    .slv_w_strb_i        (cut_w.strb),
    .slv_w_user_i        (cut_w.user),
    .slv_w_last_i        (cut_w.last),
    .slv_w_ready_o       (atomics_w_ready),
    .slv_w_valid_i       (cut_w_valid),
    .slv_r_data_o        (atomics_r.data),
    .slv_r_resp_o        (atomics_r.resp),
    .slv_r_last_o        (atomics_r.last),
    .slv_r_id_o          (atomics_r.id),
    .slv_r_user_o        (atomics_r.user),
    .slv_r_ready_i       (atomics_r_ready),
    .slv_r_valid_o       (atomics_r_valid),
    .slv_b_resp_o        (atomics_b.resp),
    .slv_b_id_o          (atomics_b.id),
    .slv_b_user_o        (atomics_b.user),
    .slv_b_ready_i       (atomics_b_ready),
    .slv_b_valid_o       (atomics_b_valid),

    .mst_aw_addr_o       (m_axi_awaddr),
    .mst_aw_prot_o       (m_axi_awprot),
    .mst_aw_region_o     (m_axi_awregion),
    .mst_aw_atop_o       (consumed_m_axi_awatop),
    .mst_aw_len_o        (m_axi_awlen),
    .mst_aw_size_o       (m_axi_awsize),
    .mst_aw_burst_o      (m_axi_awburst),
    .mst_aw_lock_o       (m_axi_awlock),
    .mst_aw_cache_o      (m_axi_awcache),
    .mst_aw_qos_o        (m_axi_awqos),
    .mst_aw_id_o         (m_axi_awid),
    .mst_aw_user_o       (unused_m_axi_awuser),
    .mst_aw_ready_i      (m_axi_awready),
    .mst_aw_valid_o      (m_axi_awvalid),
    .mst_ar_addr_o       (m_axi_araddr),
    .mst_ar_prot_o       (m_axi_arprot),
    .mst_ar_region_o     (m_axi_arregion),
    .mst_ar_len_o        (m_axi_arlen),
    .mst_ar_size_o       (m_axi_arsize),
    .mst_ar_burst_o      (m_axi_arburst),
    .mst_ar_lock_o       (m_axi_arlock),
    .mst_ar_cache_o      (m_axi_arcache),
    .mst_ar_qos_o        (m_axi_arqos),
    .mst_ar_id_o         (m_axi_arid),
    .mst_ar_user_o       (unused_m_axi_aruser),
    .mst_ar_ready_i      (m_axi_arready),
    .mst_ar_valid_o      (m_axi_arvalid),
    .mst_w_data_o        (m_axi_wdata),
    .mst_w_strb_o        (m_axi_wstrb),
    .mst_w_user_o        (unused_m_axi_wuser),
    .mst_w_last_o        (m_axi_wlast),
    .mst_w_ready_i       (m_axi_wready),
    .mst_w_valid_o       (m_axi_wvalid),
    .mst_r_data_i        (m_axi_rdata),
    .mst_r_resp_i        (m_axi_rresp),
    .mst_r_last_i        (m_axi_rlast),
    .mst_r_id_i          (m_axi_rid),
    .mst_r_user_i        ('0),
    .mst_r_ready_o       (m_axi_rready),
    .mst_r_valid_i       (m_axi_rvalid),
    .mst_b_resp_i        (m_axi_bresp),
    .mst_b_id_i          (m_axi_bid),
    .mst_b_user_i        ('0),
    .mst_b_ready_o       (m_axi_bready),
    .mst_b_valid_i       (m_axi_bvalid)
  );

endmodule
