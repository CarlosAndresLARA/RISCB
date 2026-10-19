# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DM_BASE_ADDRESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HARTINFO_DATAACCESS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HARTINFO_DATAADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HARTINFO_DATASIZE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HARTINFO_NSCRATCH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "HART_COUNT" -parent ${Page_0}
  ipgui::add_param $IPINST -name "JTAG_IDCODE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "SELECTABLE_HARTS" -parent ${Page_0}


}

proc update_PARAM_VALUE.C_AXI_ADDR_WIDTH { PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to update C_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_ADDR_WIDTH { PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_DATA_WIDTH { PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to update C_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_DATA_WIDTH { PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to validate C_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DM_BASE_ADDRESS { PARAM_VALUE.DM_BASE_ADDRESS } {
	# Procedure called to update DM_BASE_ADDRESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DM_BASE_ADDRESS { PARAM_VALUE.DM_BASE_ADDRESS } {
	# Procedure called to validate DM_BASE_ADDRESS
	return true
}

proc update_PARAM_VALUE.HARTINFO_DATAACCESS { PARAM_VALUE.HARTINFO_DATAACCESS } {
	# Procedure called to update HARTINFO_DATAACCESS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HARTINFO_DATAACCESS { PARAM_VALUE.HARTINFO_DATAACCESS } {
	# Procedure called to validate HARTINFO_DATAACCESS
	return true
}

proc update_PARAM_VALUE.HARTINFO_DATAADDR { PARAM_VALUE.HARTINFO_DATAADDR } {
	# Procedure called to update HARTINFO_DATAADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HARTINFO_DATAADDR { PARAM_VALUE.HARTINFO_DATAADDR } {
	# Procedure called to validate HARTINFO_DATAADDR
	return true
}

proc update_PARAM_VALUE.HARTINFO_DATASIZE { PARAM_VALUE.HARTINFO_DATASIZE } {
	# Procedure called to update HARTINFO_DATASIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HARTINFO_DATASIZE { PARAM_VALUE.HARTINFO_DATASIZE } {
	# Procedure called to validate HARTINFO_DATASIZE
	return true
}

proc update_PARAM_VALUE.HARTINFO_NSCRATCH { PARAM_VALUE.HARTINFO_NSCRATCH } {
	# Procedure called to update HARTINFO_NSCRATCH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HARTINFO_NSCRATCH { PARAM_VALUE.HARTINFO_NSCRATCH } {
	# Procedure called to validate HARTINFO_NSCRATCH
	return true
}

proc update_PARAM_VALUE.HART_COUNT { PARAM_VALUE.HART_COUNT } {
	# Procedure called to update HART_COUNT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.HART_COUNT { PARAM_VALUE.HART_COUNT } {
	# Procedure called to validate HART_COUNT
	return true
}

proc update_PARAM_VALUE.JTAG_IDCODE { PARAM_VALUE.JTAG_IDCODE } {
	# Procedure called to update JTAG_IDCODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.JTAG_IDCODE { PARAM_VALUE.JTAG_IDCODE } {
	# Procedure called to validate JTAG_IDCODE
	return true
}

proc update_PARAM_VALUE.SELECTABLE_HARTS { PARAM_VALUE.SELECTABLE_HARTS } {
	# Procedure called to update SELECTABLE_HARTS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SELECTABLE_HARTS { PARAM_VALUE.SELECTABLE_HARTS } {
	# Procedure called to validate SELECTABLE_HARTS
	return true
}


proc update_MODELPARAM_VALUE.HART_COUNT { MODELPARAM_VALUE.HART_COUNT PARAM_VALUE.HART_COUNT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HART_COUNT}] ${MODELPARAM_VALUE.HART_COUNT}
}

proc update_MODELPARAM_VALUE.C_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_ADDR_WIDTH PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_DATA_WIDTH PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.DM_BASE_ADDRESS { MODELPARAM_VALUE.DM_BASE_ADDRESS PARAM_VALUE.DM_BASE_ADDRESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DM_BASE_ADDRESS}] ${MODELPARAM_VALUE.DM_BASE_ADDRESS}
}

proc update_MODELPARAM_VALUE.JTAG_IDCODE { MODELPARAM_VALUE.JTAG_IDCODE PARAM_VALUE.JTAG_IDCODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.JTAG_IDCODE}] ${MODELPARAM_VALUE.JTAG_IDCODE}
}

proc update_MODELPARAM_VALUE.SELECTABLE_HARTS { MODELPARAM_VALUE.SELECTABLE_HARTS PARAM_VALUE.SELECTABLE_HARTS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SELECTABLE_HARTS}] ${MODELPARAM_VALUE.SELECTABLE_HARTS}
}

proc update_MODELPARAM_VALUE.HARTINFO_NSCRATCH { MODELPARAM_VALUE.HARTINFO_NSCRATCH PARAM_VALUE.HARTINFO_NSCRATCH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HARTINFO_NSCRATCH}] ${MODELPARAM_VALUE.HARTINFO_NSCRATCH}
}

proc update_MODELPARAM_VALUE.HARTINFO_DATAACCESS { MODELPARAM_VALUE.HARTINFO_DATAACCESS PARAM_VALUE.HARTINFO_DATAACCESS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HARTINFO_DATAACCESS}] ${MODELPARAM_VALUE.HARTINFO_DATAACCESS}
}

proc update_MODELPARAM_VALUE.HARTINFO_DATASIZE { MODELPARAM_VALUE.HARTINFO_DATASIZE PARAM_VALUE.HARTINFO_DATASIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HARTINFO_DATASIZE}] ${MODELPARAM_VALUE.HARTINFO_DATASIZE}
}

proc update_MODELPARAM_VALUE.HARTINFO_DATAADDR { MODELPARAM_VALUE.HARTINFO_DATAADDR PARAM_VALUE.HARTINFO_DATAADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.HARTINFO_DATAADDR}] ${MODELPARAM_VALUE.HARTINFO_DATAADDR}
}

