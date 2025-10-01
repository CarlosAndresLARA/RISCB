use work.ariane_axi_vhdl.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_vhw is
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
        --axi_resp_o  : out   resp_t
        
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
end rom_vhw;

architecture wrap of rom_vhw is

component rom_vw
    generic(
        AxiAddrWidth : integer := -1;
        AxiDataWidth : integer := -1;
        AxiIdWidth   : integer := -1;
        AxiUserWidth : integer := 1
    );
    port(
        clk         : in    std_logic;
        ndmreset_n  : in    std_logic;
        axi_req_i   : in    req_t;
        axi_resp_o  : out   resp_t
    );
end component;

signal axi_req_i   : req_t;
signal axi_rep_o  : resp_t;

begin

uui : rom_vw
generic map(
    AxiAddrWidth => AxiAddrWidth ,
    AxiDataWidth => AxiDataWidth ,
    AxiIdWidth   => AxiIdWidth   ,
    AxiUserWidth => AxiUserWidth 
)
port map(
    clk         => clk_i       ,
    ndmreset_n  => rst_ni      ,
    axi_req_i   => axi_req_i   ,
    axi_resp_o  => axi_rep_o  
);

    axi_req_i.aw_addr       <=      slv_aw_addr_i  ;
    axi_req_i.aw_prot       <=      slv_aw_prot_i  ;
    axi_req_i.aw_region     <=      slv_aw_region_i;
    axi_req_i.aw_atop       <=      slv_aw_atop_i  ;
    axi_req_i.aw_len        <=      slv_aw_len_i   ;
    axi_req_i.aw_size       <=      slv_aw_size_i  ;
    axi_req_i.aw_burst      <=      slv_aw_burst_i ;
    axi_req_i.aw_lock       <=      slv_aw_lock_i  ;
    axi_req_i.aw_cache      <=      slv_aw_cache_i ;
    axi_req_i.aw_qos        <=      slv_aw_qos_i   ;
    axi_req_i.aw_id         <=      slv_aw_id_i    ;
  --axi_req_i.aw_user       <=      slv_aw_user_i  ;
    slv_aw_ready_o          <=      axi_rep_o.aw_ready ;
    axi_req_i.aw_valid      <=      slv_aw_valid_i ;
    axi_req_i.ar_addr       <=      slv_ar_addr_i  ;
    axi_req_i.ar_prot       <=      slv_ar_prot_i  ;
    axi_req_i.ar_region     <=      slv_ar_region_i;
    axi_req_i.ar_len        <=      slv_ar_len_i   ;
    axi_req_i.ar_size       <=      slv_ar_size_i  ;
    axi_req_i.ar_burst      <=      slv_ar_burst_i ;
    axi_req_i.ar_lock       <=      slv_ar_lock_i  ;
    axi_req_i.ar_cache      <=      slv_ar_cache_i ;
    axi_req_i.ar_qos        <=      slv_ar_qos_i   ;
    axi_req_i.ar_id         <=      slv_ar_id_i    ;
  --axi_req_i.ar_user       <=      slv_ar_user_i  ;
    slv_ar_ready_o          <=      axi_rep_o.ar_ready ;
    axi_req_i.ar_valid      <=      slv_ar_valid_i ;
    axi_req_i.w_data        <=      slv_w_data_i   ;
    axi_req_i.w_strb        <=      slv_w_strb_i   ;
  --axi_req_i.w_user        <=      slv_w_user_i   ;
    axi_req_i.w_last        <=      slv_w_last_i   ;
    slv_w_ready_o           <=      axi_rep_o.w_ready  ;
    axi_req_i.w_valid       <=      slv_w_valid_i  ;
    slv_r_data_o            <=      axi_rep_o.r_data   ;
    slv_r_resp_o            <=      axi_rep_o.r_resp   ;
    slv_r_last_o            <=      axi_rep_o.r_last   ;
    slv_r_id_o              <=      axi_rep_o.r_id     ;
  --slv_r_user_o            <=      axi_rep_o.r_user   ;
    axi_req_i.r_ready       <=      slv_r_ready_i  ;
    slv_r_valid_o           <=      axi_rep_o.r_valid  ;
    slv_b_resp_o            <=      axi_rep_o.b_resp   ;
    slv_b_id_o              <=      axi_rep_o.b_id     ;
  --slv_b_user_o            <=      axi_rep_o.b_user   ;
    axi_req_i.b_ready       <=      slv_b_ready_i  ;
    slv_b_valid_o           <=      axi_rep_o.b_valid  ;

end wrap;
