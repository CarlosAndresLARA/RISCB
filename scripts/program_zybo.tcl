if {$argc != 1} {
  error "usage: program_zybo.tcl BITSTREAM"
}

set bitstream [file normalize [lindex $argv 0]]

if {![file isfile $bitstream]} {
  error "bitstream does not exist: $bitstream"
}

connect -url tcp:127.0.0.1:3121
targets -set -filter {name =~ "xc7z020"}
fpga -file $bitstream
