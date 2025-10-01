library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package ariane_axi_vhdl is

  constant NR_CORES : integer := 1;
  constant NB_PERIPHERALS : integer := 10;
  constant NB_MASTERS : integer := 2;
  constant NrSlaves : integer := 2; --// actually masters, but slaves on the crossbar
 
  --// 4 is recommended by AXI standard, so lets stick to it, do not change
  constant IdWidth : integer := 4;
  constant IdWidthSlave : integer := IdWidth + 1;--$clog2(NrSlaves);
  constant NumSources : integer := 30;
  constant NumTargets : integer := 2;
  constant MaxPriority : integer := 7;

  constant UserWidth : integer := 1;
  constant AddrWidth : integer := 64;
  constant DataWidth : integer := 64;
  constant StrbWidth : integer := DataWidth / 8;
  
  constant XLEN : integer := 32;
  
  constant NrRegion : integer := 1;
  
  constant DRAM    : integer := 0;
  constant GPIO    : integer := 1;
  constant Ethernet: integer := 2;
  constant SPI     : integer := 3;
  constant Timer   : integer := 4;
  constant UART    : integer := 5;
  constant PLIC    : integer := 6;
  constant CLINT   : integer := 7;
  constant ROM     : integer := 8;
  constant Debug   : integer := 9;
  
  constant DebugBase        : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0000_0000";
  constant ROMBase          : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0001_0000";
  constant CLINTBase        : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0200_0000";
  constant PLICBase         : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0C00_0000";
  constant UARTBase         : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_1000_0000";
  constant TimerBase        : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_1800_0000";
  constant SPIBase          : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_2000_0000";
  constant EthernetBase     : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_3000_0000";
  constant GPIOBase         : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_4000_0000";
  constant DRAMBase         : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_8000_0000";
                                                                          
  constant DebugLength      : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0000_1000";
  constant ROMLength        : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0001_0000";
  constant CLINTLength      : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_000C_0000";
  constant PLICLength       : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_03FF_FFFF";
  constant UARTLength       : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0000_1000";
  constant TimerLength      : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0000_1000";
  constant SPILength        : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0080_0000";
  constant EthernetLength   : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0001_0000";
  constant GPIOLength       : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0000_1000";
  constant DRAMLength       : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_4000_0000"; -- 1GByte of DDR (split between two chips on Genesys2)
  constant SRAMLength       : std_logic_vector(AddrWidth-1 downto 0) := x"0000_0000_0180_0000";  -- 24 MByte of SRAM  
  
type req_t is record
        aw_id       : std_logic_vector(IdWidthSlave-1 downto 0);
        aw_addr     : std_logic_vector(AddrWidth-1 downto 0);
        aw_len      : std_logic_vector(7 downto 0);
        aw_size     : std_logic_vector(2 downto 0);
        aw_burst    : std_logic_vector(1 downto 0);
        aw_lock     : std_logic;
        aw_cache    : std_logic_vector(3 downto 0);
        aw_prot     : std_logic_vector(2 downto 0);
        aw_qos      : std_logic_vector(3 downto 0);
        aw_region   : std_logic_vector(3 downto 0);
        aw_atop     : std_logic_vector(5 downto 0);
        aw_valid    : std_logic;
        w_data      : std_logic_vector(DataWidth-1 downto 0);
        w_strb      : std_logic_vector(StrbWidth-1 downto 0);
        w_last      : std_logic;
        w_valid     : std_logic;
        b_ready     : std_logic;

        ar_id       : std_logic_vector(IdWidthSlave-1 downto 0);
        ar_addr     : std_logic_vector(AddrWidth-1 downto 0);
        ar_len      : std_logic_vector(7 downto 0);
        ar_size     : std_logic_vector(2 downto 0);
        ar_burst    : std_logic_vector(1 downto 0);
        ar_lock     : std_logic;
        ar_cache    : std_logic_vector(3 downto 0);
        ar_prot     : std_logic_vector(2 downto 0);
        ar_qos      : std_logic_vector(3 downto 0);
        ar_region   : std_logic_vector(3 downto 0);
        ar_valid    : std_logic;
        r_ready     : std_logic;
end record;

type resp_t is record
        aw_ready    : std_logic;
        ar_ready    : std_logic;
        w_ready     : std_logic;
        b_valid     : std_logic;
        b_id        : std_logic_vector(IdWidthSlave-1 downto 0);
        b_resp      : std_logic_vector(1 downto 0);
        r_valid     : std_logic;
        r_id        : std_logic_vector(IdWidthSlave-1 downto 0);
        r_data      : std_logic_vector(DataWidth-1 downto 0);
        r_resp      : std_logic_vector(1 downto 0);
        r_last      : std_logic;
end record;

type req_t_s is record
        aw_id       : std_logic_vector(IdWidthSlave-1 downto 0);
        aw_addr     : std_logic_vector(AddrWidth-1 downto 0);
        aw_len      : std_logic_vector(7 downto 0);
        aw_size     : std_logic_vector(2 downto 0);
        aw_burst    : std_logic_vector(1 downto 0);
        aw_lock     : std_logic;
        aw_cache    : std_logic_vector(3 downto 0);
        aw_prot     : std_logic_vector(2 downto 0);
        aw_qos      : std_logic_vector(3 downto 0);
        aw_region   : std_logic_vector(3 downto 0);
        aw_atop     : std_logic_vector(5 downto 0);
        aw_valid    : std_logic;
        w_data      : std_logic_vector(DataWidth-1 downto 0);
        w_strb      : std_logic_vector(StrbWidth-1 downto 0);
        w_last      : std_logic;
        w_valid     : std_logic;
        b_ready     : std_logic;

        ar_id       : std_logic_vector(IdWidthSlave-1 downto 0);
        ar_addr     : std_logic_vector(AddrWidth-1 downto 0);
        ar_len      : std_logic_vector(7 downto 0);
        ar_size     : std_logic_vector(2 downto 0);
        ar_burst    : std_logic_vector(1 downto 0);
        ar_lock     : std_logic;
        ar_cache    : std_logic_vector(3 downto 0);
        ar_prot     : std_logic_vector(2 downto 0);
        ar_qos      : std_logic_vector(3 downto 0);
        ar_region   : std_logic_vector(3 downto 0);
        ar_valid    : std_logic;
        r_ready     : std_logic;
end record;

type resp_t_s is record
        aw_ready    : std_logic;
        ar_ready    : std_logic;
        w_ready     : std_logic;
        b_valid     : std_logic;
        b_id        : std_logic_vector(IdWidthSlave-1 downto 0);
        b_resp      : std_logic_vector(1 downto 0);
        r_valid     : std_logic;
        r_id        : std_logic_vector(IdWidthSlave-1 downto 0);
        r_data      : std_logic_vector(DataWidth-1 downto 0);
        r_resp      : std_logic_vector(1 downto 0);
        r_last      : std_logic;
end record;

type hartinfo_t is record
        zero1       : std_logic_vector(31 downto 24);
        nscratch    : std_logic_vector(23 downto 20);
        zero0       : std_logic_vector(19 downto 17);
        dataaccess  : std_logic;
        datasize    : std_logic_vector(15 downto 12);
        dataaddr    : std_logic_vector(11 downto 0);
end record;

type ad_req is (SINGLE_REQ, CACHE_LINE_REQ);
type ad_req_t is array (NR_CORES-1 to 0) of ad_req;

type addr_slice is array(NB_PERIPHERALS-1 downto 0) of std_logic_vector(AddrWidth-1 downto 0);
type addr_array is array(NrRegion-1 downto 0) of addr_slice;
type rule_array is array(NrRegion-1 downto 0) of std_logic_vector(NB_PERIPHERALS-1 downto 0);

end package ariane_axi_vhdl;