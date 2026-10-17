# ============================================================
# Fabric
# ============================================================
export PDK_DIR     				= $(PWD)/../PDK/
# ============================================================
# Design settings
# ============================================================

export ENV_DESIGN               = counter
export ENV_DESIGN_DIR           = $(PWD)/data/$(ENV_DESIGN)
export ENV_MMMC                 = $(ENV_DESIGN_DIR)/mmmc.view
export ENV_DEFINE               =
export ENV_INIT_HDL_SEARCH_PATH = ${ENV_DESIGN_DIR}
export ENV_RTL_LIST             = $(ENV_DESIGN_DIR)/$(ENV_DESIGN).lst
# ============================================================
# Flow
# ============================================================
export FLOW_DIR   				= $(PWD)/flow_scripts
export GENUS_SCRIPT             = $(FLOW_DIR)/flow.genus.syn.tcl
export INNOVUS_FP_SCRIPT        = $(FLOW_DIR)/flow.innovus.fp.tcl

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
# Innovus Floorplan settings
# ============================================================
export TECH_SIZE            = 130
export ENV_NETLIST          = $(GENUS_OUTPUT_DIR)/syn_opt/$(ENV_DESIGN).v 
export ENV_FLOORPLAN_FILE   = $(ENV_DESIGN_DIR)/floorplan/counter.fp
export ENV_LEF_FILES        = $(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lef/sg13g2_tech.lef $(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lef/sg13g2_stdcell.lef
export ENV_POWER_NETS       = VDD
export ENV_GROUND_NETS      = VSS
export ENV_INNOVUS_FP       = innovus

export INNOVUS_FP_RUN_DIR     = $(PWD)/run/innovus_fp
export INNOVUS_FP_OUTPUT_DIR  = $(INNOVUS_FP_RUN_DIR)/outputs
export INNOVUS_FP_REPORT_DIR  = $(INNOVUS_FP_RUN_DIR)/reports
export INNOVUS_FP_LOG_DIR     = $(INNOVUS_FP_RUN_DIR)/logs
export INNOVUS_FP_LOG         = $(INNOVUS_FP_LOG_DIR)/innovus_fp.log
export INNOVUS_FP_OPTS        = -stylus

# ============================================================
# Targets
# ============================================================

all: genus.syn

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

genus.syn: $(GENUS_OUTPUT_DIR) $(GENUS_REPORT_DIR) $(GENUS_LOG_DIR)
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

# ----------------------------------------
# Innovus Floorplan
# ----------------------------------------
$(INNOVUS_FP_OUTPUT_DIR) $(INNOVUS_FP_REPORT_DIR) $(INNOVUS_FP_LOG_DIR):
	mkdir -p $@

$(INNOVUS_FP_RUN_DIR): $(INNOVUS_FP_OUTPUT_DIR) $(INNOVUS_FP_REPORT_DIR) $(INNOVUS_FP_LOG_DIR)
	mkdir -p $@

innovus.fp: $(INNOVUS_FP_RUN_DIR)
	@echo "=== Starting Innovus Floorplan ==="
	@echo "Design:     $(ENV_DESIGN)"
	@echo "Netlist:    $(ENV_NETLIST)"
	@echo "Tech size:  $(TECH_SIZE)"
	@echo "LEF files:  $(ENV_LEF_FILES)"
	@echo "Power nets: $(ENV_POWER_NETS)"
	@echo "Ground nets:$(ENV_GROUND_NETS)"
	@echo "MMMC:       $(ENV_MMMC)"
	cd $(INNOVUS_FP_RUN_DIR) && $(ENV_INNOVUS_FP) -no_gui $(INNOVUS_FP_OPTS) \
		-files $(INNOVUS_FP_SCRIPT) 2>&1 | tee $(INNOVUS_FP_LOG)
	@echo "=== Innovus Floorplan Complete ==="
	@echo "Log saved to: $(INNOVUS_FP_LOG)"

# ----------------------------------------
# Interactive Innovus
# ----------------------------------------
innovus: $(INNOVUS_FP_RUN_DIR)
	@echo "=== Starting Interactive Innovus ==="
	cd $(INNOVUS_FP_RUN_DIR) && $(ENV_INNOVUS_FP) $(INNOVUS_FP_OPTS)

clean:
	rm -rf $(GENUS_LOG_DIR) $(GENUS_REPORT_DIR) $(GENUS_OUTPUT_DIR) $(GENUS_RUN_DIR) \
	       $(INNOVUS_FP_LOG_DIR) $(INNOVUS_FP_REPORT_DIR) $(INNOVUS_FP_OUTPUT_DIR) $(INNOVUS_FP_RUN_DIR) \
	       *.session *.cmd *.history *.wlf *.vcd

.PHONY: all genus.syn genus lec lec_nogui innovus.fp innovus clean
