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

- [Zybo Z7-20 board](https://digilent.com/shop/zybo-z7-zynq-7000-arm-fpga-soc-development-board/)
- [Pmod USBUART](https://digilent.com/shop/pmod-usbuart-usb-to-uart-interface/)
- [JTAG-HS2](https://digilent.com/shop/jtag-hs2-programming-cable/)
- Vivado 2020.2 or later (we assume that `vivado` and `xsct` are available from the terminal)

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

Program the FPGA with:

```sh
make run
```

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

## Additional hardware targets

The project supports three FPGA boards:

- `zybo_z7_20`: The original board used by Thales.
- `arty_a7_100`: A low-cost Artix [FPGA](https://digilent.com/shop/arty-a7-100t-artix-7-fpga-development-board/).
- `arty_a7_35`: An older generation [FPGA](https://digilent.com/shop/arty-a7-100t-artix-7-fpga-development-board/).

For the zybo, the `Pmod USBUART` is connected to `PMOD JB` and the `JTAG-HS2` is connected to `PMOD JE`. In the Arty (either), the `Pmod USBUART` is connected to `PMOD JA` and the `JTAG-HS2` is connected to `PMOD JD`. The reset is always `BTN3`.

To build and run on a different board, use:

```sh
make hardware PLATFORM=arty_a7_35
make run PLATFORM=arty_a7_35
```

Or simply:

```sh
export PLATFORM=arty_a7_100
make hardware 
make run
```

## Core Frequency

By default, the hardware projects build with a core frequency of 40 MHz. The core frequency can be modified at build time, but then the software component must also be updated.

```sh
make hardware CVA6_FREQ=40
```
