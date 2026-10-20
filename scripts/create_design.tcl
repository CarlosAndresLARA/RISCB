if {$argc > 3} {
  error "usage: create_design.tcl ?PLATFORM? ?CVA6_FREQ_MHZ? ?synth|impl?"
}
set platform [expr {$argc >= 1 ? [lindex $argv 0] : "zybo_z7_20"}]
set cva6_freq_mhz 40
set run_mode design
if {$argc >= 2} {
  set second_arg [lindex $argv 1]
  if {$second_arg in {design synth impl}} {
    set run_mode $second_arg
  } else {
    set cva6_freq_mhz $second_arg
  }
}
if {$argc == 3} {
  set run_mode [lindex $argv 2]
}
if {![string is double -strict $cva6_freq_mhz] || $cva6_freq_mhz <= 0} {
  error "CVA6_FREQ_MHZ must be a positive number, got '$cva6_freq_mhz'"
}
if {$run_mode ni {design synth impl}} {
  error "usage: create_design.tcl ?PLATFORM? ?CVA6_FREQ_MHZ? ?synth|impl?"
}
set run_synthesis [expr {$run_mode ne "design"}]
set run_implementation [expr {$run_mode eq "impl"}]

set script_dir [file dirname [file normalize [info script]]]
set repo_root [file dirname $script_dir]
set project_dir [file join $repo_root build $platform]
set project_name $platform
set design_name cva6_system

switch -- $platform {
  zybo_z7_20 {
    set part xc7z020clg400-1
    set input_clock_hz 125000000
    set input_clock_mhz 125.000
    set bram_depth 32768
    set bram_range 256K
  }
  arty_a7_100 {
    set part xc7a100tcsg324-1
    set input_clock_hz 100000000
    set input_clock_mhz 100.000
    set bram_depth 32768
    set bram_range 256K
  }
  arty_a7_35 {
    set part xc7a35ticsg324-1L
    set input_clock_hz 100000000
    set input_clock_mhz 100.000
    set bram_depth 16384
    set bram_range 128K
  }
  default {
    error "unsupported platform '$platform'; choose zybo_z7_20, arty_a7_100, or arty_a7_35"
  }
}

set pin_xdc [file join $repo_root constraints ${platform}.xdc]
set impl_xdc_path [file join $repo_root constraints ${platform}_impl.xdc]
foreach constraint_file [list $pin_xdc $impl_xdc_path] {
  if {![file isfile $constraint_file]} {
    error "missing constraint file: $constraint_file"
  }
}

create_project -force $project_name $project_dir -part $part
foreach run_name {synth_1 impl_1} {
  set run_part [get_property PART [get_runs $run_name]]
  if {$run_part ne $part} {
    error "run $run_name targets $run_part instead of $part"
  }
}
set_property target_language Verilog [current_project]
set_property simulator_language Mixed [current_project]
set_property ip_repo_paths [file join $repo_root ip] [current_project]
update_ip_catalog

add_files -fileset constrs_1 -norecurse [list $pin_xdc $impl_xdc_path]
set impl_xdc [get_files $impl_xdc_path]
set_property used_in_synthesis false $impl_xdc

create_bd_design $design_name

# External board interfaces.
set clk_sys [create_bd_port -dir I -type clk -freq_hz $input_clock_hz clk_sys]
set cpu_reset [create_bd_port -dir I -type rst cpu_reset]
set_property CONFIG.POLARITY ACTIVE_HIGH $cpu_reset

set jtag [create_bd_intf_port -mode Slave \
  -vlnv xilinx.com:interface:jtag_rtl:2.0 jtag]
set jtag_trstn [create_bd_port -dir I -type rst jtag_trstn]
set_property CONFIG.POLARITY ACTIVE_LOW $jtag_trstn

set uart [create_bd_intf_port -mode Master \
  -vlnv xilinx.com:interface:uart_rtl:1.0 uart]

# Custom source-backed blocks.
set core [create_bd_cell -type ip -vlnv user.org:user:cva6_core:1.0 cva6_core_0]
set atomics [create_bd_cell -type ip \
  -vlnv user.org:user:cva6_axi_atomics:1.0 cva6_axi_atomics_0]
# Match AMD's native transparent-bridge classification.  Without the interior
# attribute Vivado treats the downstream interface as another root initiator
# when regenerating OOC sub-designs after a GUI edit.
set_property BRIDGES {m_axi} [get_bd_intf_pins $atomics/s_axi]
foreach intf_pin [list $atomics/s_axi $atomics/m_axi] {
  set_property BD_ATTRIBUTE.TYPE interior [get_bd_intf_pins $intf_pin]
}
set debug [create_bd_cell -type ip -vlnv user.org:user:cva6_debug:1.0 cva6_debug_0]
set bootrom [create_bd_cell -type ip -vlnv user.org:user:cva6_bootrom:1.0 cva6_bootrom_0]
set clint [create_bd_cell -type ip -vlnv user.org:user:cva6_clint:1.0 cva6_clint_0]
set plic [create_bd_cell -type ip -vlnv user.org:user:cva6_plic:1.0 cva6_plic_0]
set uart_ip [create_bd_cell -type ip -vlnv user.org:user:cva6_uart:1.0 cva6_uart_0]
set timer [create_bd_cell -type ip -vlnv user.org:user:cva6_timer:1.0 cva6_timer_0]

# Native AMD infrastructure. Two initiators are the core path and debug SBA;
# seven targets are debug memory, boot ROM, CLINT, PLIC, UART, timer, and BRAM.
set interconnect [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect_0]
set_property -dict [list CONFIG.NUM_SI {2} CONFIG.NUM_MI {7}] $interconnect

set bram_ctrl [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl_0]
set_property -dict [list \
  CONFIG.DATA_WIDTH {64} \
  CONFIG.SINGLE_PORT_BRAM {1} \
  CONFIG.ECC_TYPE {0} \
] $bram_ctrl

set bram [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0]
set_property -dict [list \
  CONFIG.Memory_Type {Single_Port_RAM} \
  CONFIG.Use_Byte_Write_Enable {true} \
  CONFIG.Byte_Size {8} \
  CONFIG.Write_Width_A {64} \
  CONFIG.Read_Width_A {64} \
  CONFIG.Write_Depth_A $bram_depth \
] $bram

set clk_wiz [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0]
set_property -dict [list \
  CONFIG.PRIM_IN_FREQ $input_clock_mhz \
  CONFIG.CLKOUT1_REQUESTED_OUT_FREQ [format %.3f $cva6_freq_mhz] \
  CONFIG.NUM_OUT_CLKS {1} \
  CONFIG.RESET_TYPE {ACTIVE_HIGH} \
] $clk_wiz

set reset_ctrl [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0]
set reset_not [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:util_vector_logic:2.0 ndmreset_not]
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {not}] $reset_not
set reset_and [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:util_vector_logic:2.0 system_resetn_and]
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {and}] $reset_and

set const_zero [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:xlconstant:1.1 const_zero]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {0}] $const_zero
set const_one [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:xlconstant:1.1 const_one]
set_property -dict [list CONFIG.CONST_WIDTH {1} CONFIG.CONST_VAL {1}] $const_one
set const_zero2 [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:xlconstant:1.1 const_zero2]
set_property -dict [list CONFIG.CONST_WIDTH {2} CONFIG.CONST_VAL {0}] $const_zero2
set const_zero23 [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:xlconstant:1.1 const_zero23]
set_property -dict [list CONFIG.CONST_WIDTH {23} CONFIG.CONST_VAL {0}] $const_zero23
set const_zero30 [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:xlconstant:1.1 const_zero30]
set_property -dict [list CONFIG.CONST_WIDTH {30} CONFIG.CONST_VAL {0}] $const_zero30

set irq_concat [create_bd_cell -type ip \
  -vlnv xilinx.com:ip:xlconcat:2.1 plic_irq_concat]
set_property -dict [list \
  CONFIG.NUM_PORTS {4} \
  CONFIG.IN0_WIDTH {1} \
  CONFIG.IN1_WIDTH {2} \
  CONFIG.IN2_WIDTH {4} \
  CONFIG.IN3_WIDTH {23} \
] $irq_concat

# AXI topology.
connect_bd_intf_net [get_bd_intf_pins $core/m_axi] \
  [get_bd_intf_pins $atomics/s_axi]
connect_bd_net [get_bd_pins $core/m_axi_awatop] \
  [get_bd_pins $atomics/s_axi_awatop]
connect_bd_intf_net [get_bd_intf_pins $atomics/m_axi] \
  [get_bd_intf_pins $interconnect/S00_AXI]
connect_bd_intf_net [get_bd_intf_pins $debug/m_axi] \
  [get_bd_intf_pins $interconnect/S01_AXI]

foreach {master target} {
  M00_AXI cva6_debug_0/s_axi
  M01_AXI cva6_bootrom_0/s_axi
  M02_AXI cva6_clint_0/s_axi
  M03_AXI cva6_plic_0/s_axi
  M04_AXI cva6_uart_0/s_axi
  M05_AXI cva6_timer_0/s_axi
  M06_AXI axi_bram_ctrl_0/S_AXI
} {
  connect_bd_intf_net [get_bd_intf_pins $interconnect/$master] \
    [get_bd_intf_pins $target]
}
connect_bd_intf_net [get_bd_intf_pins $bram_ctrl/BRAM_PORTA] \
  [get_bd_intf_pins $bram/BRAM_PORTA]

# External protocol interfaces.
connect_bd_intf_net [get_bd_intf_ports jtag] [get_bd_intf_pins $debug/jtag]
connect_bd_net [get_bd_ports jtag_trstn] [get_bd_pins $debug/jtag_trstn]
connect_bd_intf_net [get_bd_intf_ports uart] [get_bd_intf_pins $uart_ip/uart]

# Board clock and reset tree. The debug module receives only platform reset;
# ndmreset resets the core and system fabric without disabling JTAG/DMI.
connect_bd_net [get_bd_ports clk_sys] [get_bd_pins $clk_wiz/clk_in1]
connect_bd_net [get_bd_ports cpu_reset] \
  [get_bd_pins $clk_wiz/reset] [get_bd_pins $reset_ctrl/ext_reset_in]
connect_bd_net [get_bd_pins $clk_wiz/locked] [get_bd_pins $reset_ctrl/dcm_locked]
connect_bd_net [get_bd_pins $clk_wiz/clk_out1] [get_bd_pins $reset_ctrl/slowest_sync_clk]

set core_clock_pins [list \
  $core/core_clk \
  $atomics/axi_aclk \
  $debug/axi_aclk \
  $bootrom/s_axi_aclk \
  $clint/s_axi_aclk \
  $plic/s_axi_aclk \
  $uart_ip/s_axi_aclk \
  $timer/s_axi_aclk \
  $bram_ctrl/s_axi_aclk]
foreach pin $core_clock_pins {
  connect_bd_net [get_bd_pins $clk_wiz/clk_out1] [get_bd_pins $pin]
}
foreach pin [get_bd_pins -quiet $interconnect/*ACLK] {
  connect_bd_net [get_bd_pins $clk_wiz/clk_out1] $pin
}

connect_bd_net [get_bd_pins $reset_ctrl/peripheral_aresetn] \
  [get_bd_pins $debug/axi_aresetn] [get_bd_pins $reset_and/Op1]
connect_bd_net [get_bd_pins $debug/ndmreset] [get_bd_pins $reset_not/Op1]
connect_bd_net [get_bd_pins $reset_not/Res] [get_bd_pins $reset_and/Op2]

set system_reset_pins [list \
  $core/core_resetn \
  $atomics/axi_aresetn \
  $bootrom/s_axi_aresetn \
  $clint/s_axi_aresetn \
  $plic/s_axi_aresetn \
  $uart_ip/s_axi_aresetn \
  $timer/s_axi_aresetn \
  $bram_ctrl/s_axi_aresetn]
foreach pin $system_reset_pins {
  connect_bd_net [get_bd_pins $reset_and/Res] [get_bd_pins $pin]
}
foreach pin [get_bd_pins -quiet $interconnect/*ARESETN] {
  connect_bd_net [get_bd_pins $reset_and/Res] $pin
}

# Interrupt topology reproduces the Thales source numbering.
connect_bd_net [get_bd_pins $uart_ip/irq_o] [get_bd_pins $irq_concat/In0]
connect_bd_net [get_bd_pins $const_zero2/dout] [get_bd_pins $irq_concat/In1]
connect_bd_net [get_bd_pins $timer/irq_o] [get_bd_pins $irq_concat/In2]
connect_bd_net [get_bd_pins $const_zero23/dout] [get_bd_pins $irq_concat/In3]
connect_bd_net [get_bd_pins $irq_concat/dout] [get_bd_pins $plic/irq_sources_i]
connect_bd_net [get_bd_pins $const_zero30/dout] [get_bd_pins $plic/irq_edge_i]
connect_bd_net [get_bd_pins $plic/irq_targets_o] [get_bd_pins $core/external_irq]
connect_bd_net [get_bd_pins $clint/timer_irq_o] [get_bd_pins $core/timer_irq]
connect_bd_net [get_bd_pins $clint/software_irq_o] [get_bd_pins $core/software_irq]
connect_bd_net [get_bd_pins $debug/debug_req] [get_bd_pins $core/debug_req]

# Fixed platform inputs.
connect_bd_net [get_bd_pins $const_zero/dout] \
  [get_bd_pins $debug/testmode] \
  [get_bd_pins $debug/unavailable] \
  [get_bd_pins $clint/testmode_i]
connect_bd_net [get_bd_pins $const_one/dout] \
  [get_bd_pins $uart_ip/cts_ni] \
  [get_bd_pins $uart_ip/dsr_ni] \
  [get_bd_pins $uart_ip/dcd_ni] \
  [get_bd_pins $uart_ip/ri_ni]

# Establish target segments, then preserve the historical Thales base map.
assign_bd_address

proc set_segment {master_space target_interface offset range} {
  set spaces [get_bd_addr_spaces -quiet $master_space]
  set segments [get_bd_addr_segs -quiet -of_objects \
    [get_bd_intf_pins $target_interface]]
  if {[llength $spaces] != 1 || [llength $segments] != 1} {
    error "cannot map $target_interface into $master_space"
  }
  assign_bd_address -force -offset $offset -range $range \
    -target_address_space $spaces $segments
}

foreach master_space {
  cva6_core_0/m_axi
  cva6_axi_atomics_0/m_axi
  cva6_debug_0/m_axi
} {
  set_segment $master_space cva6_debug_0/s_axi    0x00000000 4K
  set_segment $master_space cva6_bootrom_0/s_axi  0x00010000 64K
  set_segment $master_space cva6_clint_0/s_axi    0x02000000 1M
  set_segment $master_space cva6_plic_0/s_axi     0x0C000000 64M
  set_segment $master_space cva6_uart_0/s_axi     0x10000000 4K
  set_segment $master_space cva6_timer_0/s_axi    0x18000000 4K
  set_segment $master_space axi_bram_ctrl_0/S_AXI 0x80000000 $bram_range
}

# The atomics address space is an interior implementation detail of the
# transparent core-to-fabric bridge, not an independent root initiator.
# Vivado still requires each reachable target to be classified, so retain the
# propagated offsets but explicitly exclude these duplicate bridge-local
# segments.  The active maps remain on the core and debug SBA address spaces.
set atomics_space [get_bd_addr_spaces cva6_axi_atomics_0/m_axi]
foreach segment [get_bd_addr_segs -of_objects $atomics_space] {
  exclude_bd_addr_seg $segment
}

validate_bd_design
save_bd_design
generate_target all [get_files ${design_name}.bd]

set wrapper [make_wrapper -files [get_files ${design_name}.bd] -top]
add_files -norecurse $wrapper
set_property top ${design_name}_wrapper [current_fileset]
update_compile_order -fileset sources_1

if {$run_synthesis} {
  launch_runs synth_1 -jobs 4
  wait_on_run synth_1
  set run_status [get_property STATUS [get_runs synth_1]]
  if {![string match "*Complete*" $run_status]} {
    error "CVA6 design synthesis failed: $run_status"
  }
  open_run synth_1
  set report_dir [file join $project_dir reports]
  file mkdir $report_dir
  report_utilization -file [file join $report_dir utilization_synth.rpt]
  report_timing_summary -file [file join $report_dir timing_synth.rpt]
  puts "Synthesized $design_name with run status '$run_status'"

  if {$run_implementation} {
    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1
    set impl_status [get_property STATUS [get_runs impl_1]]
    if {![string match "*Complete*" $impl_status]} {
      error "CVA6 design implementation failed: $impl_status"
    }
    open_run impl_1
    report_utilization -file [file join $report_dir utilization_impl.rpt]
    report_timing_summary -file [file join $report_dir timing_impl.rpt]
    report_drc -file [file join $report_dir drc_impl.rpt]
    report_cdc -file [file join $report_dir cdc_impl.rpt]

    set impl_dir [get_property DIRECTORY [get_runs impl_1]]
    set bit_files [glob -nocomplain [file join $impl_dir *.bit]]
    if {[llength $bit_files] != 1} {
      error "expected one implementation bitstream, found [llength $bit_files]"
    }
    puts "Implemented $design_name with run status '$impl_status'"
    puts "Bitstream: [lindex $bit_files 0]"
  }
} else {
  puts "Created and validated $design_name for $platform at $project_dir"
}

