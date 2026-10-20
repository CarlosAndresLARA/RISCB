# Zybo Z7-20 pins used by the portable CVA6 design.
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clk_sys]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports cpu_reset]

# FTDI FT2232 JTAG used by the Thales debug flow.
set_property -dict {PACKAGE_PIN V13 IOSTANDARD LVCMOS33} [get_ports jtag_trstn]
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports jtag_tck]
set_property -dict {PACKAGE_PIN W16 IOSTANDARD LVCMOS33} [get_ports jtag_tdi]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports jtag_tdo]
set_property -dict {PACKAGE_PIN V12 IOSTANDARD LVCMOS33} [get_ports jtag_tms]

# USB-UART bridge.
set_property -dict {PACKAGE_PIN W8 IOSTANDARD LVCMOS33} [get_ports uart_txd]
set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports uart_rxd]

create_clock -period 100.000 -name jtag_tck -waveform {0.000 50.000} [get_ports jtag_tck]
set_input_jitter jtag_tck 1.000
set_false_path -from [get_ports jtag_trstn]
set_input_delay -clock jtag_tck -clock_fall 5.000 [get_ports jtag_tdi]
set_input_delay -clock jtag_tck -clock_fall 5.000 [get_ports jtag_tms]
set_output_delay -clock jtag_tck 5.000 [get_ports jtag_tdo]

