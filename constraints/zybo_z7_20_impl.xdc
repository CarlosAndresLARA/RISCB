# Implementation-only timing exceptions inherited from the Thales Zybo flow.
# The 125 MHz input clock is created by the Clocking Wizard's generated XDC.

# The FT2232 drives TCK through a regular fabric input rather than a dedicated
# clock-capable path. Keep its I/O path short and isolate it from the 40 MHz
# system domain; the DMI module contains the required handshake CDC.
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets jtag_tck_IBUF]
set_max_delay -to [get_ports jtag_tdo] 20.000
set_max_delay -from [get_ports jtag_tms] 20.000
set_max_delay -from [get_ports jtag_tdi] 20.000
set_max_delay -from [get_ports jtag_trstn] 20.000

set jtag_clock [get_clocks -quiet jtag_tck]
set system_clock [get_clocks -quiet clk_out1_cva6_bram_system_clk_wiz_0_0]
set_clock_groups -asynchronous -group $jtag_clock -group $system_clock

# Preserve the explicit two-phase DMI CDC bounds from cva6_fpga.xdc, adjusted
# for the hierarchy introduced by the cva6_debug IP Integrator block.
set dmi_resp_data_src [get_pins -hier -quiet -filter \
  {NAME =~ *i_dmi_cdc/i_cdc_resp/i_src/data_src_q_reg*/C}]
set dmi_resp_data_dst [get_pins -hier -quiet -filter \
  {NAME =~ *i_dmi_cdc/i_cdc_resp/i_dst/data_dst_q_reg*/D}]
set dmi_resp_req_src [get_pins -hier -quiet -filter \
  {NAME =~ *i_dmi_cdc/i_cdc_resp/i_src/req_src_q_reg/C}]
set dmi_resp_req_dst [get_pins -hier -quiet -filter \
  {NAME =~ *i_dmi_cdc/i_cdc_resp/i_dst/req_dst_q_reg/D}]
set dmi_req_ack_dst [get_pins -hier -quiet -filter \
  {NAME =~ *i_dmi_cdc/i_cdc_req/i_dst/ack_dst_q_reg/C}]
set dmi_req_ack_src [get_pins -hier -quiet -filter \
  {NAME =~ *i_dmi_cdc/i_cdc_req/i_src/ack_src_q_reg/D}]

set_max_delay -datapath_only -from $dmi_resp_data_src -to $dmi_resp_data_dst 20.000
set_max_delay -datapath_only -from $dmi_resp_req_src -to $dmi_resp_req_dst 20.000
set_max_delay -datapath_only -from $dmi_req_ack_dst -to $dmi_req_ack_src 20.000
