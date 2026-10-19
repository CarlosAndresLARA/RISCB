# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AXI_MAX_WRITE_TXNS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "CUT_S_AXI" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_AXI_USER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RISCV_WORD_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.AXI_MAX_WRITE_TXNS { PARAM_VALUE.AXI_MAX_WRITE_TXNS } {
	# Procedure called to update AXI_MAX_WRITE_TXNS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_MAX_WRITE_TXNS { PARAM_VALUE.AXI_MAX_WRITE_TXNS } {
	# Procedure called to validate AXI_MAX_WRITE_TXNS
	return true
}

proc update_PARAM_VALUE.CUT_S_AXI { PARAM_VALUE.CUT_S_AXI } {
	# Procedure called to update CUT_S_AXI when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CUT_S_AXI { PARAM_VALUE.CUT_S_AXI } {
	# Procedure called to validate CUT_S_AXI
	return true
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

proc update_PARAM_VALUE.C_AXI_ID_WIDTH { PARAM_VALUE.C_AXI_ID_WIDTH } {
	# Procedure called to update C_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_ID_WIDTH { PARAM_VALUE.C_AXI_ID_WIDTH } {
	# Procedure called to validate C_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_AXI_USER_WIDTH { PARAM_VALUE.C_AXI_USER_WIDTH } {
	# Procedure called to update C_AXI_USER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_USER_WIDTH { PARAM_VALUE.C_AXI_USER_WIDTH } {
	# Procedure called to validate C_AXI_USER_WIDTH
	return true
}

proc update_PARAM_VALUE.RISCV_WORD_WIDTH { PARAM_VALUE.RISCV_WORD_WIDTH } {
	# Procedure called to update RISCV_WORD_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RISCV_WORD_WIDTH { PARAM_VALUE.RISCV_WORD_WIDTH } {
	# Procedure called to validate RISCV_WORD_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_ADDR_WIDTH PARAM_VALUE.C_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_DATA_WIDTH PARAM_VALUE.C_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_ID_WIDTH { MODELPARAM_VALUE.C_AXI_ID_WIDTH PARAM_VALUE.C_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_USER_WIDTH { MODELPARAM_VALUE.C_AXI_USER_WIDTH PARAM_VALUE.C_AXI_USER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_AXI_USER_WIDTH}] ${MODELPARAM_VALUE.C_AXI_USER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_MAX_WRITE_TXNS { MODELPARAM_VALUE.AXI_MAX_WRITE_TXNS PARAM_VALUE.AXI_MAX_WRITE_TXNS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_MAX_WRITE_TXNS}] ${MODELPARAM_VALUE.AXI_MAX_WRITE_TXNS}
}

proc update_MODELPARAM_VALUE.RISCV_WORD_WIDTH { MODELPARAM_VALUE.RISCV_WORD_WIDTH PARAM_VALUE.RISCV_WORD_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RISCV_WORD_WIDTH}] ${MODELPARAM_VALUE.RISCV_WORD_WIDTH}
}

proc update_MODELPARAM_VALUE.CUT_S_AXI { MODELPARAM_VALUE.CUT_S_AXI PARAM_VALUE.CUT_S_AXI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CUT_S_AXI}] ${MODELPARAM_VALUE.CUT_S_AXI}
}

