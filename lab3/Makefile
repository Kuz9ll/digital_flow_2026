# ============================================================
# Fabric
# ============================================================
export PDK_DIR     				= $(PWD)/../PDK
# ============================================================
# Design settings
# ============================================================

export ENV_DESIGN               = counter
export ENV_DESIGN_DIR           = $(PWD)/data/example_rtl/counter
export ENV_MMMC                 = $(ENV_DESIGN_DIR)/mmmc.view
export ENV_DEFINE               =
export ENV_INIT_HDL_SEARCH_PATH = ${ENV_DESIGN_DIR}
export ENV_RTL_LIST             = $(ENV_DESIGN_DIR)/counter.lst
# ============================================================
# Flow
# ============================================================
export FLOW_DIR   				= $(PWD)/flow_scripts
export GENUS_SCRIPT             = $(FLOW_DIR)/flow.genus.syn.tcl

# ============================================================
# Genus Synthesis settings
# ============================================================
export GENUS_RUN_DIR     = $(PWD)/run/genus
export GENUS_OUTPUT_DIR  = $(GENUS_RUN_DIR)/outputs
export GENUS_REPORT_DIR  = $(GENUS_RUN_DIR)/reports
export GENUS_LOG_DIR     = $(GENUS_RUN_DIR)/logs
export GENUS_LOG    = $(GENUS_LOG_DIR)/synth.log
export GENUS_OPTS  = 
export GENUS       = genus

# ============================================================
# LEC settings
# ============================================================
export LEC_OPTS  = -XL -64 -Color
export LEC       = lec
export LEC_FILE  = $(GENUS_OUTPUT_DIR)/rtl2final.lec.do



# ============================================================
# Targets
# ============================================================

all: synth

# ----------------------------------------
# Synthesis
# ----------------------------------------
$(GENUS_OUTPUT_DIR) $(GENUS_REPORT_DIR) $(GENUS_LOG_DIR):
	mkdir -p $@

# ----------------------------------------
# Interactive Genus (empty)
# ----------------------------------------
$(GENUS_RUN_DIR):
	mkdir -p $@

genus: $(GENUS_RUN_DIR)
	@echo "=== Starting Interactive Genus ==="
	cd $(GENUS_RUN_DIR) && $(GENUS) $(GENUS_OPTS)

synth: $(GENUS_OUTPUT_DIR) $(GENUS_REPORT_DIR) $(GENUS_LOG_DIR)
	@echo "=== Starting Synthesis ==="
	@echo "Design: $(ENV_DESIGN)"
	@echo "RTL list: $(ENV_RTL_LIST)"
	cd $(GENUS_RUN_DIR) && $(GENUS) $(GENUS_OPTS) -files $(GENUS_SCRIPT) 2>&1 | tee $(GENUS_LOG)
	@echo "=== Synthesis Complete ==="
	@echo "Log saved to: $(GENUS_LOG)"

# ----------------------------------------
# LEC (Conformal)
# ----------------------------------------
lec: $(GENUS_RUN_DIR)
	@echo "=== Starting LEC ==="
	@echo "Design: $(ENV_DESIGN)"
	@echo "Script: $(LEC_FILE)"
	cd $(GENUS_RUN_DIR) && $(LEC) $(LEC_OPTS) -Dofile $(LEC_FILE)

lec_nogui: $(GENUS_RUN_DIR)
	@echo "=== Starting LEC (no GUI) ==="
	cd $(GENUS_RUN_DIR) && $(LEC) -NOgui $(LEC_OPTS) -Dofile $(LEC_FILE)


clean:
	rm -rf $(GENUS_LOG_DIR) $(GENUS_REPORT_DIR) $(GENUS_OUTPUT_DIR) $(GENUS_RUN_DIR) *.session *.cmd *.history *.wlf *.vcd

.PHONY: all synth genus lec lec_nogui clean