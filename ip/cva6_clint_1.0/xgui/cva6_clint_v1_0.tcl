# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "CORE_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RTC_TOGGLE_DIVIDER" -parent ${Page_0}


}

proc update_PARAM_VALUE.CORE_COUNT { PARAM_VALUE.CORE_COUNT } {
	# Procedure called to update CORE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CORE_COUNT { PARAM_VALUE.CORE_COUNT } {
	# Procedure called to validate CORE_COUNT
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.RTC_TOGGLE_DIVIDER { PARAM_VALUE.RTC_TOGGLE_DIVIDER } {
	# Procedure called to update RTC_TOGGLE_DIVIDER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RTC_TOGGLE_DIVIDER { PARAM_VALUE.RTC_TOGGLE_DIVIDER } {
	# Procedure called to validate RTC_TOGGLE_DIVIDER
	return true
}


proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.CORE_COUNT { MODELPARAM_VALUE.CORE_COUNT PARAM_VALUE.CORE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CORE_COUNT}] ${MODELPARAM_VALUE.CORE_COUNT}
}

proc update_MODELPARAM_VALUE.RTC_TOGGLE_DIVIDER { MODELPARAM_VALUE.RTC_TOGGLE_DIVIDER PARAM_VALUE.RTC_TOGGLE_DIVIDER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RTC_TOGGLE_DIVIDER}] ${MODELPARAM_VALUE.RTC_TOGGLE_DIVIDER}
}

