# ============================================================
# Environment
# ============================================================

export ENV_DESIGN_DIR = $(PWD)/data

XRUN = xrun

SIM_TOP = counter_tb

SIM_RTL_DIR = $(ENV_DESIGN_DIR)/rtl/counter

SIM_FILES = \
	$(SIM_RTL_DIR)/counter.sv \
	$(SIM_RTL_DIR)/counter_tb.sv

SIM_RUN_DIR = $(PWD)/run/sim
SIM_LOG_DIR = $(PWD)/logs/sim
SIM_LOG     = $(SIM_LOG_DIR)/xrun.log

XRUN_OPTS = \
	-access +rw \
	-clean \
	-seed random \
	-timescale 1ns/1ps


# ============================================================
# Targets
# ============================================================

all: sim


# ----------------------------------------
# Simulation
# ----------------------------------------

$(SIM_RUN_DIR) $(SIM_LOG_DIR):
	mkdir -p $@

sim: $(SIM_RUN_DIR) $(SIM_LOG_DIR)
	@echo "=== Starting Simulation ==="
	@echo "Top: $(SIM_TOP)"
	@echo "Files: $(SIM_FILES)"
	cd $(SIM_RUN_DIR) && \
		$(XRUN) $(XRUN_OPTS) \
		$(SIM_FILES) \
		-top $(SIM_TOP) \
		-gui \
		2>&1 | tee $(SIM_LOG)
	@echo "=== Simulation Complete ==="
	@echo "Log saved to: $(SIM_LOG)"


# ----------------------------------------
# Clean
# ----------------------------------------

clean:
	rm -rf $(SIM_RUN_DIR)
	rm -rf $(SIM_LOG_DIR)
	rm -rf *.session *.cmd *.history *.wlf *.vcd


.PHONY: all sim clean