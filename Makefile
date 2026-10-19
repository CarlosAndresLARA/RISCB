# Reproducible Zybo Z7-20 hardware flow.

REPO_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

VIVADO ?= vivado
XSCT ?= xsct
BITSTREAM ?= $(REPO_DIR)build/cva6_bram_system.bit

.PHONY: hardware run clean

hardware:
	$(VIVADO) -mode batch -nolog -nojournal -notrace \
		-source $(REPO_DIR)scripts/create_bram_design.tcl -tclargs impl

run:
	@test -f "$(BITSTREAM)" || { \
		echo "Missing bitstream: $(BITSTREAM)"; \
		echo "Run 'make hardware' first."; \
		exit 2; \
	}
	$(XSCT) $(REPO_DIR)scripts/program_zybo.tcl "$(BITSTREAM)"

clean:
	rm -rf ./build/*
