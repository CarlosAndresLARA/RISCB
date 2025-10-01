library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ariane_plic_v1_0 is
	generic (
		-- Users to add parameters here
		NumSources : integer := 30;
		-- User parameters ends
		-- Do not modify the parameters beyond this line

		-- Parameters of Axi Slave Bus Interface S_AXI
		C_S_AXI_ID_WIDTH	: integer	:=  5;
		C_S_AXI_DATA_WIDTH	: integer	:= 64;
		C_S_AXI_ADDR_WIDTH	: integer	:= 64;
		C_S_AXI_AWUSER_WIDTH	: integer	:= 1;
		C_S_AXI_ARUSER_WIDTH	: integer	:= 1;
		C_S_AXI_WUSER_WIDTH	: integer	:= 1;
		C_S_AXI_RUSER_WIDTH	: integer	:= 1;
		C_S_AXI_BUSER_WIDTH	: integer	:= 1
	);
	port (
		-- Users to add ports here
        plic_irq    : out   std_logic_vector(1 downto 0);
        sources_irq : in    std_logic_vector(NumSources-1 downto 0);
        aw_atop       : in    std_logic_vector(5 downto 0);
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S_AXI
		s_axi_aclk	: in std_logic;
		s_axi_aresetn	: in std_logic;
		s_axi_awid	: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		s_axi_awaddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_awlen	: in std_logic_vector(7 downto 0);
		s_axi_awsize	: in std_logic_vector(2 downto 0);
		s_axi_awburst	: in std_logic_vector(1 downto 0);
		s_axi_awlock	: in std_logic;
		s_axi_awcache	: in std_logic_vector(3 downto 0);
		s_axi_awprot	: in std_logic_vector(2 downto 0);
		s_axi_awqos	: in std_logic_vector(3 downto 0);
		s_axi_awregion	: in std_logic_vector(3 downto 0);
		s_axi_awuser	: in std_logic_vector(C_S_AXI_AWUSER_WIDTH-1 downto 0);
		s_axi_awvalid	: in std_logic;
		s_axi_awready	: out std_logic;
		s_axi_wdata	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_wstrb	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		s_axi_wlast	: in std_logic;
		s_axi_wuser	: in std_logic_vector(C_S_AXI_WUSER_WIDTH-1 downto 0);
		s_axi_wvalid	: in std_logic;
		s_axi_wready	: out std_logic;
		s_axi_bid	: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		s_axi_bresp	: out std_logic_vector(1 downto 0);
		s_axi_buser	: out std_logic_vector(C_S_AXI_BUSER_WIDTH-1 downto 0);
		s_axi_bvalid	: out std_logic;
		s_axi_bready	: in std_logic;
		s_axi_arid	: in std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		s_axi_araddr	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		s_axi_arlen	: in std_logic_vector(7 downto 0);
		s_axi_arsize	: in std_logic_vector(2 downto 0);
		s_axi_arburst	: in std_logic_vector(1 downto 0);
		s_axi_arlock	: in std_logic;
		s_axi_arcache	: in std_logic_vector(3 downto 0);
		s_axi_arprot	: in std_logic_vector(2 downto 0);
		s_axi_arqos	: in std_logic_vector(3 downto 0);
		s_axi_arregion	: in std_logic_vector(3 downto 0);
		s_axi_aruser	: in std_logic_vector(C_S_AXI_ARUSER_WIDTH-1 downto 0);
		s_axi_arvalid	: in std_logic;
		s_axi_arready	: out std_logic;
		s_axi_rid	: out std_logic_vector(C_S_AXI_ID_WIDTH-1 downto 0);
		s_axi_rdata	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		s_axi_rresp	: out std_logic_vector(1 downto 0);
		s_axi_rlast	: out std_logic;
		s_axi_ruser	: out std_logic_vector(C_S_AXI_RUSER_WIDTH-1 downto 0);
		s_axi_rvalid	: out std_logic;
		s_axi_rready	: in std_logic
	);
end ariane_plic_v1_0;

architecture arch_imp of ariane_plic_v1_0 is

constant AxiAddrWidth : integer := 64;
constant AxiDataWidth : integer := 64;
constant AxiIdWidth   : integer := 5;
constant AxiUserWidth : integer := 1;

component plic_vhw
    generic(
        AxiAddrWidth : integer := -1;
        AxiDataWidth : integer := -1;
        AxiIdWidth   : integer := -1;
        AxiUserWidth : integer := 1
    );
    port ( 
        clk_i       : in    std_logic;
        rst_ni      : in    std_logic;
        --axi_req_i   : in    req_t;
        --axi_resp_o  : out   resp_t;
        irq_o       : out   std_logic_vector(1 downto 0);
        irq_sources : in    std_logic_vector(NumSources-1 downto 0);
        
        slv_aw_addr_i       : in    std_logic_vector(AxiAddrWidth-1 downto 0);
        slv_aw_prot_i       : in    std_logic_vector(2 downto 0);
        slv_aw_region_i     : in    std_logic_vector(3 downto 0);
        slv_aw_atop_i       : in    std_logic_vector(5 downto 0);
        slv_aw_len_i        : in    std_logic_vector(7 downto 0);
        slv_aw_size_i       : in    std_logic_vector(2 downto 0);
        slv_aw_burst_i      : in    std_logic_vector(1 downto 0);
        slv_aw_lock_i       : in    std_logic;
        slv_aw_cache_i      : in    std_logic_vector(3 downto 0);
        slv_aw_qos_i        : in    std_logic_vector(3 downto 0);
        slv_aw_id_i         : in    std_logic_vector(AxiIdWidth-1 downto 0);
        slv_aw_user_i       : in    std_logic_vector(AxiUserWidth-1 downto 0);
        slv_aw_ready_o      : out   std_logic;
        slv_aw_valid_i      : in    std_logic;
        slv_ar_addr_i       : in    std_logic_vector(AxiAddrWidth-1 downto 0);
        slv_ar_prot_i       : in    std_logic_vector(2 downto 0);
        slv_ar_region_i     : in    std_logic_vector(3 downto 0);
        slv_ar_len_i        : in    std_logic_vector(7 downto 0);
        slv_ar_size_i       : in    std_logic_vector(2 downto 0);
        slv_ar_burst_i      : in    std_logic_vector(1 downto 0);
        slv_ar_lock_i       : in    std_logic;
        slv_ar_cache_i      : in    std_logic_vector(3 downto 0);
        slv_ar_qos_i        : in    std_logic_vector(3 downto 0);
        slv_ar_id_i         : in    std_logic_vector(AxiIdWidth-1 downto 0);
        slv_ar_user_i       : in    std_logic_vector(AxiUserWidth-1 downto 0);
        slv_ar_ready_o      : out   std_logic;
        slv_ar_valid_i      : in    std_logic;
        slv_w_data_i        : in    std_logic_vector(AxiDataWidth-1 downto 0);
        slv_w_strb_i        : in    std_logic_vector((AxiDataWidth/8)-1 downto 0);
        slv_w_user_i        : in    std_logic_vector(AxiUserWidth-1 downto 0);
        slv_w_last_i        : in    std_logic;
        slv_w_ready_o       : out   std_logic;
        slv_w_valid_i       : in    std_logic;
        slv_r_data_o        : out   std_logic_vector(AxiDataWidth-1 downto 0);
        slv_r_resp_o        : out   std_logic_vector(1 downto 0);
        slv_r_last_o        : out   std_logic;
        slv_r_id_o          : out   std_logic_vector(AxiIdWidth-1 downto 0);
        slv_r_user_o        : out   std_logic_vector(AxiUserWidth-1 downto 0);
        slv_r_ready_i       : in    std_logic;
        slv_r_valid_o       : out   std_logic;
        slv_b_resp_o        : out   std_logic_vector(1 downto 0);
        slv_b_id_o          : out   std_logic_vector(AxiIdWidth-1 downto 0);
        slv_b_user_o        : out   std_logic_vector(AxiUserWidth-1 downto 0);
        slv_b_ready_i       : in    std_logic;
        slv_b_valid_o       : out   std_logic
    );
end component;

signal slv_r_id_t : std_logic_vector(AxiIdWidth-1 downto 0);
signal slv_b_id_t : std_logic_vector(AxiIdWidth-1 downto 0);

signal slv_r_user_t : std_logic_vector(AxiUserWidth-1 downto 0);
signal slv_b_user_t : std_logic_vector(AxiUserWidth-1 downto 0);

begin

uui : plic_vhw
generic map(
    AxiAddrWidth => AxiAddrWidth ,
    AxiDataWidth => AxiDataWidth ,
    AxiIdWidth   => AxiIdWidth   ,
    AxiUserWidth => AxiUserWidth
)
port map(
    clk_i       => s_axi_aclk       ,
    rst_ni      => s_axi_aresetn    ,
    irq_o       => plic_irq      ,
    irq_sources => sources_irq  ,
    
    slv_aw_addr_i    => s_axi_awaddr  ,
    slv_aw_prot_i    => s_axi_awprot  ,
    slv_aw_region_i  => s_axi_awregion,
    slv_aw_atop_i    => aw_atop       ,
    slv_aw_len_i     => s_axi_awlen   ,
    slv_aw_size_i    => s_axi_awsize  ,
    slv_aw_burst_i   => s_axi_awburst ,
    slv_aw_lock_i    => s_axi_awlock  ,
    slv_aw_cache_i   => s_axi_awcache ,
    slv_aw_qos_i     => s_axi_awqos   ,
    slv_aw_id_i      => s_axi_awid(AxiIdWidth-1 downto 0)    ,
    slv_aw_user_i    => s_axi_wuser(AxiUserWidth-1 downto 0)   ,
    slv_aw_ready_o   => s_axi_awready ,
    slv_aw_valid_i   => s_axi_awvalid ,
    slv_ar_addr_i    => s_axi_araddr  ,
    slv_ar_prot_i    => s_axi_arprot  ,
    slv_ar_region_i  => s_axi_arregion,
    slv_ar_len_i     => s_axi_arlen   ,
    slv_ar_size_i    => s_axi_arsize  ,
    slv_ar_burst_i   => s_axi_arburst ,
    slv_ar_lock_i    => s_axi_arlock  ,
    slv_ar_cache_i   => s_axi_arcache ,
    slv_ar_qos_i     => s_axi_arqos   ,
    slv_ar_id_i      => s_axi_arid(AxiIdWidth-1 downto 0)    ,
    slv_ar_user_i    => s_axi_aruser(AxiUserWidth-1 downto 0)  ,
    slv_ar_ready_o   => s_axi_arready ,
    slv_ar_valid_i   => s_axi_arvalid ,
    slv_w_data_i     => s_axi_wdata   ,
    slv_w_strb_i     => s_axi_wstrb   ,
    slv_w_user_i     => s_axi_wuser(AxiUserWidth-1 downto 0)   ,
    slv_w_last_i     => s_axi_wlast   ,
    slv_w_ready_o    => s_axi_wready  ,
    slv_w_valid_i    => s_axi_wvalid  ,
    slv_r_data_o     => s_axi_rdata   ,
    slv_r_resp_o     => s_axi_rresp   ,
    slv_r_last_o     => s_axi_rlast   ,
    slv_r_id_o       => slv_r_id_t    , 
    slv_r_user_o     => slv_r_user_t   ,
    slv_r_ready_i    => s_axi_rready  ,
    slv_r_valid_o    => s_axi_rvalid  ,
    slv_b_resp_o     => s_axi_bresp   ,
    slv_b_id_o       => slv_b_id_t    ,
    slv_b_user_o     => slv_b_user_t   ,
    slv_b_ready_i    => s_axi_bready  ,
    slv_b_valid_o    => s_axi_bvalid  
);

s_axi_rid <= std_logic_vector(to_unsigned(to_integer(unsigned(slv_r_id_t)),C_S_AXI_ID_WIDTH));
s_axi_bid <= std_logic_vector(to_unsigned(to_integer(unsigned(slv_b_id_t)),C_S_AXI_ID_WIDTH));

s_axi_ruser <= std_logic_vector(to_unsigned(to_integer(unsigned(slv_r_user_t)),C_S_AXI_RUSER_WIDTH));
s_axi_buser <= std_logic_vector(to_unsigned(to_integer(unsigned(slv_b_user_t)),C_S_AXI_BUSER_WIDTH));

end arch_imp;
