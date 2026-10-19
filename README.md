# RISCB CVA6 block system

This repository contains a self-contained Vivado IP Integrator version of the
Thales CVA6 FPGA harness for the Zybo Z7-20 (`xc7z020clg400-1`). It implements
the portable BRAM-based system corresponding to the original `cva6_fpga`
flow.

The `ip/` packages contain all custom RTL needed to build the
system. Vivado supplies the native AMD
AXI Interconnect, AXI BRAM Controller, Block Memory Generator, Clocking Wizard,
reset, constant, and concatenation IP used by the block design.

## Requirements

- Zybo Z7-20 board
- Vivado 2020.2 with Zynq-7000 device support
- XSCT 2020.2 for command-line programming
- Digilent board files are optional; the project selects the FPGA part and
  carries all required pin constraints locally

## Repository layout

```text
constraints/  Zybo Z7-20 pin and implementation constraints
ip/           Self-contained custom CVA6 IP packages
scripts/      Project construction and board-programming Tcl
Makefile      `hardware` and `run` entry points
```

## Build and program

Build the complete Vivado project and bitstream:

```sh
make hardware
```

This creates an openable project at:

```text
build/vivado_proj/cva6_bram_system.xpr
```

It also copies stable hardware artifacts to:

```text
build/cva6_bram_system.bit
build/cva6_bram_system.hwh
```

Program the FPGA with:

```sh
make run
```

The `run` recipe invokes XSCT directly and does not launch Vivado Hardware
Manager.

## System composition

The design runs at the Thales reference frequency of 40 MHz from the board's
125 MHz oscillator. It retains the RISC-V JTAG/DMI debug path and uses a
256 KiB native block RAM as main memory.

Custom packaged IPs are:

- `cva6_core`: CVA6 with the Thales RV32IM configuration
- `cva6_axi_atomics`: full-AXI atomic-operation adapter and pipeline cut
- `cva6_debug`: JTAG/DMI debug module and System Bus Access master
- `cva6_bootrom`, `cva6_clint`, and `cva6_plic`
- `cva6_uart` and `cva6_timer`, exposed to the system as AXI4-Lite devices

## Software

Once the board has been programmed, the normal [Thales](https://github.com/ThalesGroup/cva6-softcore-contest) flow can be used.