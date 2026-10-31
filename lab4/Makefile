# ============================================================
# Fabric
# ============================================================
export PDK_DIR                  = $(PWD)/../PDK/

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
export FLOW_DIR                 = $(PWD)/flow_scripts
export GENUS_SCRIPT             = $(FLOW_DIR)/flow.genus.syn.tcl
export INNOVUS_FP_SCRIPT        = $(FLOW_DIR)/flow.innovus.fp.tcl

# ============================================================
# Genus Synthesis settings
# ============================================================
export GENUS_RUN_DIR            = $(PWD)/run/genus
export GENUS_OUTPUT_DIR         = $(GENUS_RUN_DIR)/outputs
export GENUS_REPORT_DIR         = $(GENUS_RUN_DIR)/reports
export GENUS_LOG_DIR            = $(GENUS_RUN_DIR)/logs
export GENUS_LOG                = $(GENUS_LOG_DIR)/synth.log
export GENUS_OPTS               =
export GENUS                    = genus

# ============================================================
# Genus Synthesis (script run)
# ============================================================
export GENUS_SYN_RUN_DIR        = $(PWD)/run/genus.syn

# ============================================================
# LEC settings
# ============================================================
export LEC_OPTS                 = -XL -64 -Color
export LEC                      = lec
export LEC_FILE                 = $(GENUS_OUTPUT_DIR)/rtl2final.lec.do

# ============================================================
# Innovus Floorplan settings
# ============================================================
export TECH_SIZE                = 130
export ENV_NETLIST              = $(GENUS_OUTPUT_DIR)/syn_opt/$(ENV_DESIGN).v
export ENV_FLOORPLAN_FILE       = $(ENV_DESIGN_DIR)/floorplan/counter.fp
export ENV_LEF_FILES            = $(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lef/sg13g2_tech.lef $(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lef/sg13g2_stdcell.lef
export ENV_POWER_NETS           = VDD
export ENV_GROUND_NETS          = VSS
export ENV_INNOVUS_FP           = innovus

export INNOVUS_FP_RUN_DIR       = $(PWD)/run/innovus_fp
export INNOVUS_FP_OUTPUT_DIR    = $(INNOVUS_FP_RUN_DIR)/outputs
export INNOVUS_FP_REPORT_DIR    = $(INNOVUS_FP_RUN_DIR)/reports
export INNOVUS_FP_LOG_DIR       = $(INNOVUS_FP_RUN_DIR)/logs
export INNOVUS_FP_LOG           = $(INNOVUS_FP_LOG_DIR)/innovus_fp.log
export INNOVUS_FP_OPTS          = -stylus

# ============================================================
# Interactive Innovus (generic)
# ============================================================
export ENV_INNOVUS              = innovus

export INNOVUS_RUN_DIR          = $(PWD)/run/innovus
export INNOVUS_OUTPUT_DIR       = $(INNOVUS_RUN_DIR)/outputs
export INNOVUS_REPORT_DIR       = $(INNOVUS_RUN_DIR)/reports
export INNOVUS_LOG_DIR          = $(INNOVUS_RUN_DIR)/logs
export INNOVUS_OPTS             = -stylus

# ============================================================
# Innovus Implementation
# ============================================================
export ENV_FILLER_CELLS         = sg13g2_decap_4 sg13g2_decap_4 sg13g2_fill_1

export TOP_CTS_LAYER_name       = Metal5
export TOP_CTS_LAYER_num        = 5
export BOT_CTS_LAYER_name       = Metal2
export BOT_CTS_LAYER_num        = 2

export INNOVUS_IMPL_SCRIPT      = $(FLOW_DIR)/flow.innovus.impl.tcl
export ENV_INNOVUS_IMPL         = innovus

export INNOVUS_IMPL_RUN_DIR     = $(PWD)/run/innovus_impl
export INNOVUS_IMPL_OUTPUT_DIR  = $(INNOVUS_IMPL_RUN_DIR)/outputs
export INNOVUS_IMPL_REPORT_DIR  = $(INNOVUS_IMPL_RUN_DIR)/reports
export INNOVUS_IMPL_LOG_DIR     = $(INNOVUS_IMPL_RUN_DIR)/logs
export INNOVUS_IMPL_LOG         = $(INNOVUS_IMPL_LOG_DIR)/innovus_impl.log
export INNOVUS_IMPL_OPTS        = -stylus

# ============================================================
# Innovus Debug
# ============================================================
export ENV_DB                   = $(PWD)/run/innovus_impl/db/DB.counter.Route.enc
export ENV_INNOVUS_DEBUG        = innovus
export INNOVUS_DEBUG_OPTS       = -stylus
export INNOVUS_DEBUG_SCRIPT     = $(FLOW_DIR)/flow.innovus.debug.tcl

export INNOVUS_DEBUG_RUN_DIR    = $(PWD)/run/innovus_debug
export INNOVUS_DEBUG_OUTPUT_DIR = $(INNOVUS_DEBUG_RUN_DIR)/outputs
export INNOVUS_DEBUG_REPORT_DIR = $(INNOVUS_DEBUG_RUN_DIR)/reports
export INNOVUS_DEBUG_LOG_DIR    = $(INNOVUS_DEBUG_RUN_DIR)/logs

# ============================================================
# Targets
# ============================================================
all: genus

# ----------------------------------------
# Interactive Genus (empty)
# ----------------------------------------
$(GENUS_RUN_DIR):
	mkdir -p $@

genus: $(GENUS_RUN_DIR)
	@echo "=== Starting Interactive Genus ==="
	cd $(GENUS_RUN_DIR) && $(GENUS) $(GENUS_OPTS)

# ----------------------------------------
# Genus Synthesis (script run)
# ----------------------------------------
$(GENUS_SYN_RUN_DIR):
	mkdir -p $@

genus.syn: export GENUS_RUN_DIR = $(GENUS_SYN_RUN_DIR)
genus.syn: $(GENUS_SYN_RUN_DIR)
	@echo "=== Starting Genus Synthesis ==="
	@echo "Design:  $(ENV_DESIGN)"
	@echo "Run dir: $(GENUS_RUN_DIR)"
	@echo "Script:  $(GENUS_SCRIPT)"
	mkdir -p $(GENUS_OUTPUT_DIR) $(GENUS_REPORT_DIR) $(GENUS_LOG_DIR)
	cd $(GENUS_RUN_DIR) && $(GENUS) $(GENUS_OPTS) \
		-files $(GENUS_SCRIPT)

# ----------------------------------------
# LEC (Conformal)
# ----------------------------------------
lec: $(GENUS_RUN_DIR)
	@echo "=== Starting LEC ==="
	@echo "Design: $(ENV_DESIGN)"
	@echo "Script: $(LEC_FILE)"
	cd $(GENUS_RUN_DIR) && $(LEC) $(LEC_OPTS) -Dofile $(LEC_FILE)

# ----------------------------------------
# Interactive Innovus Floorplan
# ----------------------------------------
$(INNOVUS_FP_OUTPUT_DIR) $(INNOVUS_FP_REPORT_DIR) $(INNOVUS_FP_LOG_DIR):
	mkdir -p $@

$(INNOVUS_FP_RUN_DIR): $(INNOVUS_FP_OUTPUT_DIR) $(INNOVUS_FP_REPORT_DIR) $(INNOVUS_FP_LOG_DIR)
	mkdir -p $@

innovus.fp.gui: $(INNOVUS_FP_RUN_DIR)
	@echo "=== Starting Interactive Innovus Floorplan ==="
	@echo "Design:     $(ENV_DESIGN)"
	@echo "Netlist:    $(ENV_NETLIST)"
	@echo "Tech size:  $(TECH_SIZE)"
	@echo "LEF files:  $(ENV_LEF_FILES)"
	@echo "Power nets: $(ENV_POWER_NETS)"
	@echo "Ground nets:$(ENV_GROUND_NETS)"
	@echo "MMMC:       $(ENV_MMMC)"
	cd $(INNOVUS_FP_RUN_DIR) && $(ENV_INNOVUS_FP) $(INNOVUS_FP_OPTS) \
		-files $(INNOVUS_FP_SCRIPT)

# ----------------------------------------
# Interactive Innovus
# ----------------------------------------
$(INNOVUS_OUTPUT_DIR) $(INNOVUS_REPORT_DIR) $(INNOVUS_LOG_DIR):
	mkdir -p $@

$(INNOVUS_RUN_DIR): $(INNOVUS_OUTPUT_DIR) $(INNOVUS_REPORT_DIR) $(INNOVUS_LOG_DIR)
	mkdir -p $@

innovus: $(INNOVUS_RUN_DIR)
	@echo "=== Starting Interactive Innovus ==="
	cd $(INNOVUS_RUN_DIR) && $(ENV_INNOVUS) $(INNOVUS_OPTS)

# ----------------------------------------
# Interactive Innovus Implementation
# ----------------------------------------
$(INNOVUS_IMPL_OUTPUT_DIR) $(INNOVUS_IMPL_REPORT_DIR) $(INNOVUS_IMPL_LOG_DIR):
	mkdir -p $@

$(INNOVUS_IMPL_RUN_DIR): $(INNOVUS_IMPL_OUTPUT_DIR) $(INNOVUS_IMPL_REPORT_DIR) $(INNOVUS_IMPL_LOG_DIR)
	mkdir -p $@

innovus.impl: $(INNOVUS_IMPL_RUN_DIR)
	@echo "=== Starting Interactive Innovus Implementation ==="
	@echo "Design:     $(ENV_DESIGN)"
	@echo "Netlist:    $(ENV_NETLIST)"
	@echo "Tech size:  $(TECH_SIZE)"
	@echo "LEF files:  $(ENV_LEF_FILES)"
	@echo "Power nets: $(ENV_POWER_NETS)"
	@echo "Ground nets:$(ENV_GROUND_NETS)"
	@echo "MMMC:       $(ENV_MMMC)"
	cd $(INNOVUS_IMPL_RUN_DIR) && $(ENV_INNOVUS_IMPL) $(INNOVUS_IMPL_OPTS) \
		-files $(INNOVUS_IMPL_SCRIPT)

# ----------------------------------------
# Innovus Debug (open impl DB interactively)
# ----------------------------------------
$(INNOVUS_DEBUG_OUTPUT_DIR) $(INNOVUS_DEBUG_REPORT_DIR) $(INNOVUS_DEBUG_LOG_DIR):
	mkdir -p $@

$(INNOVUS_DEBUG_RUN_DIR): $(INNOVUS_DEBUG_OUTPUT_DIR) $(INNOVUS_DEBUG_REPORT_DIR) $(INNOVUS_DEBUG_LOG_DIR)
	mkdir -p $@

innovus.debug: $(INNOVUS_DEBUG_RUN_DIR)
	@echo "=== Starting Innovus Debug ==="
	@echo "Run dir: $(INNOVUS_DEBUG_RUN_DIR)"
	@echo "DB:      $(ENV_DB)"
	@echo "Script:  $(INNOVUS_DEBUG_SCRIPT)"
	@test -e $(ENV_DB) || { echo "ERROR: DB not found: $(ENV_DB)"; exit 1; }
	cd $(INNOVUS_DEBUG_RUN_DIR) && $(ENV_INNOVUS_DEBUG) $(INNOVUS_DEBUG_OPTS) \
		-files $(INNOVUS_DEBUG_SCRIPT)

# ----------------------------------------
# Clean
# ----------------------------------------
clean:
	rm -rf $(GENUS_LOG_DIR) $(GENUS_REPORT_DIR) $(GENUS_OUTPUT_DIR) $(GENUS_RUN_DIR) \
	       $(GENUS_SYN_RUN_DIR) \
	       $(INNOVUS_FP_LOG_DIR) $(INNOVUS_FP_REPORT_DIR) $(INNOVUS_FP_OUTPUT_DIR) $(INNOVUS_FP_RUN_DIR) \
	       $(INNOVUS_LOG_DIR) $(INNOVUS_REPORT_DIR) $(INNOVUS_OUTPUT_DIR) $(INNOVUS_RUN_DIR) \
	       $(INNOVUS_IMPL_LOG_DIR) $(INNOVUS_IMPL_REPORT_DIR) $(INNOVUS_IMPL_OUTPUT_DIR) $(INNOVUS_IMPL_RUN_DIR) \
	       $(INNOVUS_DEBUG_LOG_DIR) $(INNOVUS_DEBUG_REPORT_DIR) $(INNOVUS_DEBUG_OUTPUT_DIR) $(INNOVUS_DEBUG_RUN_DIR) \
	       *.session *.cmd *.history *.wlf *.vcd

.PHONY: all genus genus.syn lec innovus.fp.gui innovus innovus.impl innovus.debug clean