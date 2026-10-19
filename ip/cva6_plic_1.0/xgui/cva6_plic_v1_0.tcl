# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACTIVE_SOURCE_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LEGACY_BASE_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "LOCAL_ADDRESS_MASK" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MAX_PRIORITY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SOURCE_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TARGET_COUNT" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACTIVE_SOURCE_COUNT { PARAM_VALUE.ACTIVE_SOURCE_COUNT } {
	# Procedure called to update ACTIVE_SOURCE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACTIVE_SOURCE_COUNT { PARAM_VALUE.ACTIVE_SOURCE_COUNT } {
	# Procedure called to validate ACTIVE_SOURCE_COUNT
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

proc update_PARAM_VALUE.LEGACY_BASE_ADDRESS { PARAM_VALUE.LEGACY_BASE_ADDRESS } {
	# Procedure called to update LEGACY_BASE_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LEGACY_BASE_ADDRESS { PARAM_VALUE.LEGACY_BASE_ADDRESS } {
	# Procedure called to validate LEGACY_BASE_ADDRESS
	return true
}

proc update_PARAM_VALUE.LOCAL_ADDRESS_MASK { PARAM_VALUE.LOCAL_ADDRESS_MASK } {
	# Procedure called to update LOCAL_ADDRESS_MASK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.LOCAL_ADDRESS_MASK { PARAM_VALUE.LOCAL_ADDRESS_MASK } {
	# Procedure called to validate LOCAL_ADDRESS_MASK
	return true
}

proc update_PARAM_VALUE.MAX_PRIORITY { PARAM_VALUE.MAX_PRIORITY } {
	# Procedure called to update MAX_PRIORITY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAX_PRIORITY { PARAM_VALUE.MAX_PRIORITY } {
	# Procedure called to validate MAX_PRIORITY
	return true
}

proc update_PARAM_VALUE.SOURCE_COUNT { PARAM_VALUE.SOURCE_COUNT } {
	# Procedure called to update SOURCE_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SOURCE_COUNT { PARAM_VALUE.SOURCE_COUNT } {
	# Procedure called to validate SOURCE_COUNT
	return true
}

proc update_PARAM_VALUE.TARGET_COUNT { PARAM_VALUE.TARGET_COUNT } {
	# Procedure called to update TARGET_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TARGET_COUNT { PARAM_VALUE.TARGET_COUNT } {
	# Procedure called to validate TARGET_COUNT
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

proc update_MODELPARAM_VALUE.SOURCE_COUNT { MODELPARAM_VALUE.SOURCE_COUNT PARAM_VALUE.SOURCE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SOURCE_COUNT}] ${MODELPARAM_VALUE.SOURCE_COUNT}
}

proc update_MODELPARAM_VALUE.ACTIVE_SOURCE_COUNT { MODELPARAM_VALUE.ACTIVE_SOURCE_COUNT PARAM_VALUE.ACTIVE_SOURCE_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACTIVE_SOURCE_COUNT}] ${MODELPARAM_VALUE.ACTIVE_SOURCE_COUNT}
}

proc update_MODELPARAM_VALUE.TARGET_COUNT { MODELPARAM_VALUE.TARGET_COUNT PARAM_VALUE.TARGET_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TARGET_COUNT}] ${MODELPARAM_VALUE.TARGET_COUNT}
}

proc update_MODELPARAM_VALUE.MAX_PRIORITY { MODELPARAM_VALUE.MAX_PRIORITY PARAM_VALUE.MAX_PRIORITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAX_PRIORITY}] ${MODELPARAM_VALUE.MAX_PRIORITY}
}

proc update_MODELPARAM_VALUE.LEGACY_BASE_ADDRESS { MODELPARAM_VALUE.LEGACY_BASE_ADDRESS PARAM_VALUE.LEGACY_BASE_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LEGACY_BASE_ADDRESS}] ${MODELPARAM_VALUE.LEGACY_BASE_ADDRESS}
}

proc update_MODELPARAM_VALUE.LOCAL_ADDRESS_MASK { MODELPARAM_VALUE.LOCAL_ADDRESS_MASK PARAM_VALUE.LOCAL_ADDRESS_MASK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.LOCAL_ADDRESS_MASK}] ${MODELPARAM_VALUE.LOCAL_ADDRESS_MASK}
}

