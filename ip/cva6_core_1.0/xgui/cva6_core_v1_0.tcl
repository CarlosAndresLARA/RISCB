# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "A_EXT_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BHT_ENTRIES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BOOT_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BTB_ENTRIES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CACHED_REGION_BASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CACHED_REGION_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CORE_VLEN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CORE_XLEN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CVXIF_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_EXT_ENABLE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_M_AXI_USER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DCACHE_BYTE_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DCACHE_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DCACHE_LINE_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DCACHE_SET_ASSOC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DCACHE_TYPE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEBUG_BASE_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEBUG_EXCEPTION_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DEBUG_HALT_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EXECUTE_REGION0_BASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EXECUTE_REGION0_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EXECUTE_REGION1_BASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EXECUTE_REGION1_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EXECUTE_REGION2_BASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "EXECUTE_REGION2_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HART_ID" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ICACHE_BYTE_SIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ICACHE_LINE_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ICACHE_SET_ASSOC" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_OUTSTANDING_STORES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NONIDEMPOTENT_BASE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NONIDEMPOTENT_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "PMP_ENTRIES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RAS_DEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SCOREBOARD_ENTRIES" -parent ${Page_0}
  ipgui::add_param $IPINST -name "WT_DCACHE_WBUF_DEPTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.A_EXT_ENABLE { PARAM_VALUE.A_EXT_ENABLE } {
	# Procedure called to update A_EXT_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.A_EXT_ENABLE { PARAM_VALUE.A_EXT_ENABLE } {
	# Procedure called to validate A_EXT_ENABLE
	return true
}

proc update_PARAM_VALUE.BHT_ENTRIES { PARAM_VALUE.BHT_ENTRIES } {
	# Procedure called to update BHT_ENTRIES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BHT_ENTRIES { PARAM_VALUE.BHT_ENTRIES } {
	# Procedure called to validate BHT_ENTRIES
	return true
}

proc update_PARAM_VALUE.BOOT_ADDRESS { PARAM_VALUE.BOOT_ADDRESS } {
	# Procedure called to update BOOT_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BOOT_ADDRESS { PARAM_VALUE.BOOT_ADDRESS } {
	# Procedure called to validate BOOT_ADDRESS
	return true
}

proc update_PARAM_VALUE.BTB_ENTRIES { PARAM_VALUE.BTB_ENTRIES } {
	# Procedure called to update BTB_ENTRIES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BTB_ENTRIES { PARAM_VALUE.BTB_ENTRIES } {
	# Procedure called to validate BTB_ENTRIES
	return true
}

proc update_PARAM_VALUE.CACHED_REGION_BASE { PARAM_VALUE.CACHED_REGION_BASE } {
	# Procedure called to update CACHED_REGION_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CACHED_REGION_BASE { PARAM_VALUE.CACHED_REGION_BASE } {
	# Procedure called to validate CACHED_REGION_BASE
	return true
}

proc update_PARAM_VALUE.CACHED_REGION_LENGTH { PARAM_VALUE.CACHED_REGION_LENGTH } {
	# Procedure called to update CACHED_REGION_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CACHED_REGION_LENGTH { PARAM_VALUE.CACHED_REGION_LENGTH } {
	# Procedure called to validate CACHED_REGION_LENGTH
	return true
}

proc update_PARAM_VALUE.CORE_VLEN { PARAM_VALUE.CORE_VLEN } {
	# Procedure called to update CORE_VLEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CORE_VLEN { PARAM_VALUE.CORE_VLEN } {
	# Procedure called to validate CORE_VLEN
	return true
}

proc update_PARAM_VALUE.CORE_XLEN { PARAM_VALUE.CORE_XLEN } {
	# Procedure called to update CORE_XLEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CORE_XLEN { PARAM_VALUE.CORE_XLEN } {
	# Procedure called to validate CORE_XLEN
	return true
}

proc update_PARAM_VALUE.CVXIF_ENABLE { PARAM_VALUE.CVXIF_ENABLE } {
	# Procedure called to update CVXIF_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CVXIF_ENABLE { PARAM_VALUE.CVXIF_ENABLE } {
	# Procedure called to validate CVXIF_ENABLE
	return true
}

proc update_PARAM_VALUE.C_EXT_ENABLE { PARAM_VALUE.C_EXT_ENABLE } {
	# Procedure called to update C_EXT_ENABLE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_EXT_ENABLE { PARAM_VALUE.C_EXT_ENABLE } {
	# Procedure called to validate C_EXT_ENABLE
	return true
}

proc update_PARAM_VALUE.C_M_AXI_ADDR_WIDTH { PARAM_VALUE.C_M_AXI_ADDR_WIDTH } {
	# Procedure called to update C_M_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_ADDR_WIDTH { PARAM_VALUE.C_M_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_M_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_DATA_WIDTH { PARAM_VALUE.C_M_AXI_DATA_WIDTH } {
	# Procedure called to update C_M_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_DATA_WIDTH { PARAM_VALUE.C_M_AXI_DATA_WIDTH } {
	# Procedure called to validate C_M_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_ID_WIDTH { PARAM_VALUE.C_M_AXI_ID_WIDTH } {
	# Procedure called to update C_M_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_ID_WIDTH { PARAM_VALUE.C_M_AXI_ID_WIDTH } {
	# Procedure called to validate C_M_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_M_AXI_USER_WIDTH { PARAM_VALUE.C_M_AXI_USER_WIDTH } {
	# Procedure called to update C_M_AXI_USER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M_AXI_USER_WIDTH { PARAM_VALUE.C_M_AXI_USER_WIDTH } {
	# Procedure called to validate C_M_AXI_USER_WIDTH
	return true
}

proc update_PARAM_VALUE.DCACHE_BYTE_SIZE { PARAM_VALUE.DCACHE_BYTE_SIZE } {
	# Procedure called to update DCACHE_BYTE_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DCACHE_BYTE_SIZE { PARAM_VALUE.DCACHE_BYTE_SIZE } {
	# Procedure called to validate DCACHE_BYTE_SIZE
	return true
}

proc update_PARAM_VALUE.DCACHE_ID_WIDTH { PARAM_VALUE.DCACHE_ID_WIDTH } {
	# Procedure called to update DCACHE_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DCACHE_ID_WIDTH { PARAM_VALUE.DCACHE_ID_WIDTH } {
	# Procedure called to validate DCACHE_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.DCACHE_LINE_WIDTH { PARAM_VALUE.DCACHE_LINE_WIDTH } {
	# Procedure called to update DCACHE_LINE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DCACHE_LINE_WIDTH { PARAM_VALUE.DCACHE_LINE_WIDTH } {
	# Procedure called to validate DCACHE_LINE_WIDTH
	return true
}

proc update_PARAM_VALUE.DCACHE_SET_ASSOC { PARAM_VALUE.DCACHE_SET_ASSOC } {
	# Procedure called to update DCACHE_SET_ASSOC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DCACHE_SET_ASSOC { PARAM_VALUE.DCACHE_SET_ASSOC } {
	# Procedure called to validate DCACHE_SET_ASSOC
	return true
}

proc update_PARAM_VALUE.DCACHE_TYPE { PARAM_VALUE.DCACHE_TYPE } {
	# Procedure called to update DCACHE_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DCACHE_TYPE { PARAM_VALUE.DCACHE_TYPE } {
	# Procedure called to validate DCACHE_TYPE
	return true
}

proc update_PARAM_VALUE.DEBUG_BASE_ADDRESS { PARAM_VALUE.DEBUG_BASE_ADDRESS } {
	# Procedure called to update DEBUG_BASE_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_BASE_ADDRESS { PARAM_VALUE.DEBUG_BASE_ADDRESS } {
	# Procedure called to validate DEBUG_BASE_ADDRESS
	return true
}

proc update_PARAM_VALUE.DEBUG_EXCEPTION_ADDRESS { PARAM_VALUE.DEBUG_EXCEPTION_ADDRESS } {
	# Procedure called to update DEBUG_EXCEPTION_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_EXCEPTION_ADDRESS { PARAM_VALUE.DEBUG_EXCEPTION_ADDRESS } {
	# Procedure called to validate DEBUG_EXCEPTION_ADDRESS
	return true
}

proc update_PARAM_VALUE.DEBUG_HALT_ADDRESS { PARAM_VALUE.DEBUG_HALT_ADDRESS } {
	# Procedure called to update DEBUG_HALT_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_HALT_ADDRESS { PARAM_VALUE.DEBUG_HALT_ADDRESS } {
	# Procedure called to validate DEBUG_HALT_ADDRESS
	return true
}

proc update_PARAM_VALUE.EXECUTE_REGION0_BASE { PARAM_VALUE.EXECUTE_REGION0_BASE } {
	# Procedure called to update EXECUTE_REGION0_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXECUTE_REGION0_BASE { PARAM_VALUE.EXECUTE_REGION0_BASE } {
	# Procedure called to validate EXECUTE_REGION0_BASE
	return true
}

proc update_PARAM_VALUE.EXECUTE_REGION0_LENGTH { PARAM_VALUE.EXECUTE_REGION0_LENGTH } {
	# Procedure called to update EXECUTE_REGION0_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXECUTE_REGION0_LENGTH { PARAM_VALUE.EXECUTE_REGION0_LENGTH } {
	# Procedure called to validate EXECUTE_REGION0_LENGTH
	return true
}

proc update_PARAM_VALUE.EXECUTE_REGION1_BASE { PARAM_VALUE.EXECUTE_REGION1_BASE } {
	# Procedure called to update EXECUTE_REGION1_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXECUTE_REGION1_BASE { PARAM_VALUE.EXECUTE_REGION1_BASE } {
	# Procedure called to validate EXECUTE_REGION1_BASE
	return true
}

proc update_PARAM_VALUE.EXECUTE_REGION1_LENGTH { PARAM_VALUE.EXECUTE_REGION1_LENGTH } {
	# Procedure called to update EXECUTE_REGION1_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXECUTE_REGION1_LENGTH { PARAM_VALUE.EXECUTE_REGION1_LENGTH } {
	# Procedure called to validate EXECUTE_REGION1_LENGTH
	return true
}

proc update_PARAM_VALUE.EXECUTE_REGION2_BASE { PARAM_VALUE.EXECUTE_REGION2_BASE } {
	# Procedure called to update EXECUTE_REGION2_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXECUTE_REGION2_BASE { PARAM_VALUE.EXECUTE_REGION2_BASE } {
	# Procedure called to validate EXECUTE_REGION2_BASE
	return true
}

proc update_PARAM_VALUE.EXECUTE_REGION2_LENGTH { PARAM_VALUE.EXECUTE_REGION2_LENGTH } {
	# Procedure called to update EXECUTE_REGION2_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.EXECUTE_REGION2_LENGTH { PARAM_VALUE.EXECUTE_REGION2_LENGTH } {
	# Procedure called to validate EXECUTE_REGION2_LENGTH
	return true
}

proc update_PARAM_VALUE.HART_ID { PARAM_VALUE.HART_ID } {
	# Procedure called to update HART_ID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HART_ID { PARAM_VALUE.HART_ID } {
	# Procedure called to validate HART_ID
	return true
}

proc update_PARAM_VALUE.ICACHE_BYTE_SIZE { PARAM_VALUE.ICACHE_BYTE_SIZE } {
	# Procedure called to update ICACHE_BYTE_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ICACHE_BYTE_SIZE { PARAM_VALUE.ICACHE_BYTE_SIZE } {
	# Procedure called to validate ICACHE_BYTE_SIZE
	return true
}

proc update_PARAM_VALUE.ICACHE_LINE_WIDTH { PARAM_VALUE.ICACHE_LINE_WIDTH } {
	# Procedure called to update ICACHE_LINE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ICACHE_LINE_WIDTH { PARAM_VALUE.ICACHE_LINE_WIDTH } {
	# Procedure called to validate ICACHE_LINE_WIDTH
	return true
}

proc update_PARAM_VALUE.ICACHE_SET_ASSOC { PARAM_VALUE.ICACHE_SET_ASSOC } {
	# Procedure called to update ICACHE_SET_ASSOC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ICACHE_SET_ASSOC { PARAM_VALUE.ICACHE_SET_ASSOC } {
	# Procedure called to validate ICACHE_SET_ASSOC
	return true
}

proc update_PARAM_VALUE.MAX_OUTSTANDING_STORES { PARAM_VALUE.MAX_OUTSTANDING_STORES } {
	# Procedure called to update MAX_OUTSTANDING_STORES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_OUTSTANDING_STORES { PARAM_VALUE.MAX_OUTSTANDING_STORES } {
	# Procedure called to validate MAX_OUTSTANDING_STORES
	return true
}

proc update_PARAM_VALUE.NONIDEMPOTENT_BASE { PARAM_VALUE.NONIDEMPOTENT_BASE } {
	# Procedure called to update NONIDEMPOTENT_BASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NONIDEMPOTENT_BASE { PARAM_VALUE.NONIDEMPOTENT_BASE } {
	# Procedure called to validate NONIDEMPOTENT_BASE
	return true
}

proc update_PARAM_VALUE.NONIDEMPOTENT_LENGTH { PARAM_VALUE.NONIDEMPOTENT_LENGTH } {
	# Procedure called to update NONIDEMPOTENT_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NONIDEMPOTENT_LENGTH { PARAM_VALUE.NONIDEMPOTENT_LENGTH } {
	# Procedure called to validate NONIDEMPOTENT_LENGTH
	return true
}

proc update_PARAM_VALUE.PMP_ENTRIES { PARAM_VALUE.PMP_ENTRIES } {
	# Procedure called to update PMP_ENTRIES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PMP_ENTRIES { PARAM_VALUE.PMP_ENTRIES } {
	# Procedure called to validate PMP_ENTRIES
	return true
}

proc update_PARAM_VALUE.RAS_DEPTH { PARAM_VALUE.RAS_DEPTH } {
	# Procedure called to update RAS_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAS_DEPTH { PARAM_VALUE.RAS_DEPTH } {
	# Procedure called to validate RAS_DEPTH
	return true
}

proc update_PARAM_VALUE.SCOREBOARD_ENTRIES { PARAM_VALUE.SCOREBOARD_ENTRIES } {
	# Procedure called to update SCOREBOARD_ENTRIES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SCOREBOARD_ENTRIES { PARAM_VALUE.SCOREBOARD_ENTRIES } {
	# Procedure called to validate SCOREBOARD_ENTRIES
	return true
}

proc update_PARAM_VALUE.WT_DCACHE_WBUF_DEPTH { PARAM_VALUE.WT_DCACHE_WBUF_DEPTH } {
	# Procedure called to update WT_DCACHE_WBUF_DEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WT_DCACHE_WBUF_DEPTH { PARAM_VALUE.WT_DCACHE_WBUF_DEPTH } {
	# Procedure called to validate WT_DCACHE_WBUF_DEPTH
	return true
}


proc update_MODELPARAM_VALUE.CORE_XLEN { MODELPARAM_VALUE.CORE_XLEN PARAM_VALUE.CORE_XLEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CORE_XLEN}] ${MODELPARAM_VALUE.CORE_XLEN}
}

proc update_MODELPARAM_VALUE.CORE_VLEN { MODELPARAM_VALUE.CORE_VLEN PARAM_VALUE.CORE_VLEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CORE_VLEN}] ${MODELPARAM_VALUE.CORE_VLEN}
}

proc update_MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH PARAM_VALUE.C_M_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_M_AXI_DATA_WIDTH PARAM_VALUE.C_M_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_ID_WIDTH { MODELPARAM_VALUE.C_M_AXI_ID_WIDTH PARAM_VALUE.C_M_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_M_AXI_USER_WIDTH { MODELPARAM_VALUE.C_M_AXI_USER_WIDTH PARAM_VALUE.C_M_AXI_USER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M_AXI_USER_WIDTH}] ${MODELPARAM_VALUE.C_M_AXI_USER_WIDTH}
}

proc update_MODELPARAM_VALUE.A_EXT_ENABLE { MODELPARAM_VALUE.A_EXT_ENABLE PARAM_VALUE.A_EXT_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.A_EXT_ENABLE}] ${MODELPARAM_VALUE.A_EXT_ENABLE}
}

proc update_MODELPARAM_VALUE.C_EXT_ENABLE { MODELPARAM_VALUE.C_EXT_ENABLE PARAM_VALUE.C_EXT_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_EXT_ENABLE}] ${MODELPARAM_VALUE.C_EXT_ENABLE}
}

proc update_MODELPARAM_VALUE.CVXIF_ENABLE { MODELPARAM_VALUE.CVXIF_ENABLE PARAM_VALUE.CVXIF_ENABLE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CVXIF_ENABLE}] ${MODELPARAM_VALUE.CVXIF_ENABLE}
}

proc update_MODELPARAM_VALUE.RAS_DEPTH { MODELPARAM_VALUE.RAS_DEPTH PARAM_VALUE.RAS_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAS_DEPTH}] ${MODELPARAM_VALUE.RAS_DEPTH}
}

proc update_MODELPARAM_VALUE.BTB_ENTRIES { MODELPARAM_VALUE.BTB_ENTRIES PARAM_VALUE.BTB_ENTRIES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BTB_ENTRIES}] ${MODELPARAM_VALUE.BTB_ENTRIES}
}

proc update_MODELPARAM_VALUE.BHT_ENTRIES { MODELPARAM_VALUE.BHT_ENTRIES PARAM_VALUE.BHT_ENTRIES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BHT_ENTRIES}] ${MODELPARAM_VALUE.BHT_ENTRIES}
}

proc update_MODELPARAM_VALUE.SCOREBOARD_ENTRIES { MODELPARAM_VALUE.SCOREBOARD_ENTRIES PARAM_VALUE.SCOREBOARD_ENTRIES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SCOREBOARD_ENTRIES}] ${MODELPARAM_VALUE.SCOREBOARD_ENTRIES}
}

proc update_MODELPARAM_VALUE.PMP_ENTRIES { MODELPARAM_VALUE.PMP_ENTRIES PARAM_VALUE.PMP_ENTRIES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PMP_ENTRIES}] ${MODELPARAM_VALUE.PMP_ENTRIES}
}

proc update_MODELPARAM_VALUE.MAX_OUTSTANDING_STORES { MODELPARAM_VALUE.MAX_OUTSTANDING_STORES PARAM_VALUE.MAX_OUTSTANDING_STORES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_OUTSTANDING_STORES}] ${MODELPARAM_VALUE.MAX_OUTSTANDING_STORES}
}

proc update_MODELPARAM_VALUE.ICACHE_BYTE_SIZE { MODELPARAM_VALUE.ICACHE_BYTE_SIZE PARAM_VALUE.ICACHE_BYTE_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ICACHE_BYTE_SIZE}] ${MODELPARAM_VALUE.ICACHE_BYTE_SIZE}
}

proc update_MODELPARAM_VALUE.ICACHE_SET_ASSOC { MODELPARAM_VALUE.ICACHE_SET_ASSOC PARAM_VALUE.ICACHE_SET_ASSOC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ICACHE_SET_ASSOC}] ${MODELPARAM_VALUE.ICACHE_SET_ASSOC}
}

proc update_MODELPARAM_VALUE.ICACHE_LINE_WIDTH { MODELPARAM_VALUE.ICACHE_LINE_WIDTH PARAM_VALUE.ICACHE_LINE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ICACHE_LINE_WIDTH}] ${MODELPARAM_VALUE.ICACHE_LINE_WIDTH}
}

proc update_MODELPARAM_VALUE.DCACHE_TYPE { MODELPARAM_VALUE.DCACHE_TYPE PARAM_VALUE.DCACHE_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_TYPE}] ${MODELPARAM_VALUE.DCACHE_TYPE}
}

proc update_MODELPARAM_VALUE.DCACHE_BYTE_SIZE { MODELPARAM_VALUE.DCACHE_BYTE_SIZE PARAM_VALUE.DCACHE_BYTE_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_BYTE_SIZE}] ${MODELPARAM_VALUE.DCACHE_BYTE_SIZE}
}

proc update_MODELPARAM_VALUE.DCACHE_SET_ASSOC { MODELPARAM_VALUE.DCACHE_SET_ASSOC PARAM_VALUE.DCACHE_SET_ASSOC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_SET_ASSOC}] ${MODELPARAM_VALUE.DCACHE_SET_ASSOC}
}

proc update_MODELPARAM_VALUE.DCACHE_LINE_WIDTH { MODELPARAM_VALUE.DCACHE_LINE_WIDTH PARAM_VALUE.DCACHE_LINE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_LINE_WIDTH}] ${MODELPARAM_VALUE.DCACHE_LINE_WIDTH}
}

proc update_MODELPARAM_VALUE.DCACHE_ID_WIDTH { MODELPARAM_VALUE.DCACHE_ID_WIDTH PARAM_VALUE.DCACHE_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DCACHE_ID_WIDTH}] ${MODELPARAM_VALUE.DCACHE_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.WT_DCACHE_WBUF_DEPTH { MODELPARAM_VALUE.WT_DCACHE_WBUF_DEPTH PARAM_VALUE.WT_DCACHE_WBUF_DEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WT_DCACHE_WBUF_DEPTH}] ${MODELPARAM_VALUE.WT_DCACHE_WBUF_DEPTH}
}

proc update_MODELPARAM_VALUE.BOOT_ADDRESS { MODELPARAM_VALUE.BOOT_ADDRESS PARAM_VALUE.BOOT_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BOOT_ADDRESS}] ${MODELPARAM_VALUE.BOOT_ADDRESS}
}

proc update_MODELPARAM_VALUE.HART_ID { MODELPARAM_VALUE.HART_ID PARAM_VALUE.HART_ID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HART_ID}] ${MODELPARAM_VALUE.HART_ID}
}

proc update_MODELPARAM_VALUE.DEBUG_BASE_ADDRESS { MODELPARAM_VALUE.DEBUG_BASE_ADDRESS PARAM_VALUE.DEBUG_BASE_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_BASE_ADDRESS}] ${MODELPARAM_VALUE.DEBUG_BASE_ADDRESS}
}

proc update_MODELPARAM_VALUE.DEBUG_HALT_ADDRESS { MODELPARAM_VALUE.DEBUG_HALT_ADDRESS PARAM_VALUE.DEBUG_HALT_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_HALT_ADDRESS}] ${MODELPARAM_VALUE.DEBUG_HALT_ADDRESS}
}

proc update_MODELPARAM_VALUE.DEBUG_EXCEPTION_ADDRESS { MODELPARAM_VALUE.DEBUG_EXCEPTION_ADDRESS PARAM_VALUE.DEBUG_EXCEPTION_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_EXCEPTION_ADDRESS}] ${MODELPARAM_VALUE.DEBUG_EXCEPTION_ADDRESS}
}

proc update_MODELPARAM_VALUE.NONIDEMPOTENT_BASE { MODELPARAM_VALUE.NONIDEMPOTENT_BASE PARAM_VALUE.NONIDEMPOTENT_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NONIDEMPOTENT_BASE}] ${MODELPARAM_VALUE.NONIDEMPOTENT_BASE}
}

proc update_MODELPARAM_VALUE.NONIDEMPOTENT_LENGTH { MODELPARAM_VALUE.NONIDEMPOTENT_LENGTH PARAM_VALUE.NONIDEMPOTENT_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NONIDEMPOTENT_LENGTH}] ${MODELPARAM_VALUE.NONIDEMPOTENT_LENGTH}
}

proc update_MODELPARAM_VALUE.EXECUTE_REGION0_BASE { MODELPARAM_VALUE.EXECUTE_REGION0_BASE PARAM_VALUE.EXECUTE_REGION0_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXECUTE_REGION0_BASE}] ${MODELPARAM_VALUE.EXECUTE_REGION0_BASE}
}

proc update_MODELPARAM_VALUE.EXECUTE_REGION0_LENGTH { MODELPARAM_VALUE.EXECUTE_REGION0_LENGTH PARAM_VALUE.EXECUTE_REGION0_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXECUTE_REGION0_LENGTH}] ${MODELPARAM_VALUE.EXECUTE_REGION0_LENGTH}
}

proc update_MODELPARAM_VALUE.EXECUTE_REGION1_BASE { MODELPARAM_VALUE.EXECUTE_REGION1_BASE PARAM_VALUE.EXECUTE_REGION1_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXECUTE_REGION1_BASE}] ${MODELPARAM_VALUE.EXECUTE_REGION1_BASE}
}

proc update_MODELPARAM_VALUE.EXECUTE_REGION1_LENGTH { MODELPARAM_VALUE.EXECUTE_REGION1_LENGTH PARAM_VALUE.EXECUTE_REGION1_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXECUTE_REGION1_LENGTH}] ${MODELPARAM_VALUE.EXECUTE_REGION1_LENGTH}
}

proc update_MODELPARAM_VALUE.EXECUTE_REGION2_BASE { MODELPARAM_VALUE.EXECUTE_REGION2_BASE PARAM_VALUE.EXECUTE_REGION2_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXECUTE_REGION2_BASE}] ${MODELPARAM_VALUE.EXECUTE_REGION2_BASE}
}

proc update_MODELPARAM_VALUE.EXECUTE_REGION2_LENGTH { MODELPARAM_VALUE.EXECUTE_REGION2_LENGTH PARAM_VALUE.EXECUTE_REGION2_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.EXECUTE_REGION2_LENGTH}] ${MODELPARAM_VALUE.EXECUTE_REGION2_LENGTH}
}

proc update_MODELPARAM_VALUE.CACHED_REGION_BASE { MODELPARAM_VALUE.CACHED_REGION_BASE PARAM_VALUE.CACHED_REGION_BASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CACHED_REGION_BASE}] ${MODELPARAM_VALUE.CACHED_REGION_BASE}
}

proc update_MODELPARAM_VALUE.CACHED_REGION_LENGTH { MODELPARAM_VALUE.CACHED_REGION_LENGTH PARAM_VALUE.CACHED_REGION_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CACHED_REGION_LENGTH}] ${MODELPARAM_VALUE.CACHED_REGION_LENGTH}
}

