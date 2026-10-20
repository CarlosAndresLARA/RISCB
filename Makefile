# Reproducible CVA6 hardware flow.

REPO_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

VIVADO ?= vivado
XSCT ?= xsct
PLATFORM ?= zybo_z7_20
CVA6_FREQ ?= 40

SUPPORTED_PLATFORMS := zybo_z7_20 arty_a7_100 arty_a7_35

ifeq ($(filter $(PLATFORM),$(SUPPORTED_PLATFORMS)),)
$(error Unsupported PLATFORM '$(PLATFORM)'; choose one of: $(SUPPORTED_PLATFORMS))
endif

PROJECT_DIR := $(REPO_DIR)build/$(PLATFORM)
PROJECT_NAME := $(PLATFORM)
BITSTREAM ?= $(PROJECT_DIR)/$(PROJECT_NAME).runs/impl_1/cva6_system_wrapper.bit

PROGRAM_TCL_zybo_z7_20 := $(REPO_DIR)scripts/program_zybo.tcl
PROGRAM_TCL_arty_a7_100 := $(REPO_DIR)scripts/program_arty_a7_100.tcl
PROGRAM_TCL_arty_a7_35 := $(REPO_DIR)scripts/program_arty_a7_35.tcl
PROGRAM_TCL := $(PROGRAM_TCL_$(PLATFORM))

.PHONY: hardware run clean

hardware:
	$(VIVADO) -mode batch -nolog -nojournal -notrace \
		-source $(REPO_DIR)scripts/create_design.tcl \
		-tclargs $(PLATFORM) $(CVA6_FREQ) impl

run:
	@test -f "$(BITSTREAM)" || { \
		echo "Missing bitstream: $(BITSTREAM)"; \
		echo "Run 'make hardware' first."; \
		exit 2; \
	}
	$(XSCT) $(PROGRAM_TCL) "$(BITSTREAM)"

clean:
	rm -rf ./build/*
