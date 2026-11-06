# ============================================================
# Fabric
# ============================================================
export PDK_DIR                  = $(PWD)/../PDK/

# ============================================================
# Design settings
# ============================================================
export ENV_DESIGN               = s13207
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
export VOLTUS_PGV_SCRIPT        = $(FLOW_DIR)/flow.voltus.pgv.tcl
export VOLTUS_STATIC_SCRIPT     = $(FLOW_DIR)/flow.voltus.static.tcl
export VOLTUS_DYNAMIC_SCRIPT    = $(FLOW_DIR)/flow.voltus.dynamic.tcl
export VOLTUS_GUI_SCRIPT        = $(FLOW_DIR)/flow.voltus.gui.tcl

# ============================================================
# Genus Synthesis settings
# ============================================================
export GENUS_RUN_DIR            = $(PWD)/run/genus.syn
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
export ENV_FLOORPLAN_FILE       = $(ENV_DESIGN_DIR)/floorplan/s13207.fp
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
export ENV_DB                   = $(PWD)/run/innovus_impl/db/DB.$(ENV_DESIGN).Route.enc
export ENV_INNOVUS_DEBUG        = innovus
export INNOVUS_DEBUG_OPTS       = -stylus
export INNOVUS_DEBUG_SCRIPT     = $(FLOW_DIR)/flow.innovus.debug.tcl

export INNOVUS_DEBUG_RUN_DIR    = $(PWD)/run/innovus_debug
export INNOVUS_DEBUG_OUTPUT_DIR = $(INNOVUS_DEBUG_RUN_DIR)/outputs
export INNOVUS_DEBUG_REPORT_DIR = $(INNOVUS_DEBUG_RUN_DIR)/reports
export INNOVUS_DEBUG_LOG_DIR    = $(INNOVUS_DEBUG_RUN_DIR)/logs

# ============================================================
# Voltus settings
# ============================================================
# All three scripts use one working directory. Their relative PGV paths
# then resolve to the same library. PDK/input settings remain in Tcl.
export ENV_VOLTUS               = voltus
export VOLTUS_OPTS              = -stylus

export VOLTUS_RUN_DIR           = $(PWD)/run/voltus
export VOLTUS_OUTPUT_DIR        = $(VOLTUS_RUN_DIR)/outputs
export VOLTUS_REPORT_DIR        = $(VOLTUS_RUN_DIR)/reports
export VOLTUS_LOG_DIR           = $(VOLTUS_RUN_DIR)/logs

export VOLTUS_LOG               = $(VOLTUS_LOG_DIR)/voltus.log
export VOLTUS_PGV_LOG           = $(VOLTUS_LOG_DIR)/voltus_pgv.log
export VOLTUS_STATIC_LOG        = $(VOLTUS_LOG_DIR)/voltus_static.log
export VOLTUS_DYNAMIC_LOG       = $(VOLTUS_LOG_DIR)/voltus_dynamic.log
export VOLTUS_GUI_LOG           = $(VOLTUS_LOG_DIR)/voltus_gui.log

# This path matches PGV_DIR/PGV_FILE in the flat Tcl scripts.
export VOLTUS_PGV_LIBRARY       = $(VOLTUS_OUTPUT_DIR)/pgv/tech_pgv/techonly.cl

# ============================================================
# Targets
# ============================================================
all: genus

# ----------------------------------------
# Interactive Genus (empty)
# ----------------------------------------
$(sort $(GENUS_RUN_DIR) $(GENUS_SYN_RUN_DIR)):
	mkdir -p $@

genus: $(GENUS_RUN_DIR)
	@echo "=== Starting Interactive Genus ==="
	cd $(GENUS_RUN_DIR) && $(GENUS) $(GENUS_OPTS)

# ----------------------------------------
# Genus Synthesis (script run)
# ----------------------------------------
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

innovus.fp: $(INNOVUS_FP_RUN_DIR)
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
# Interactive Voltus
# ----------------------------------------
$(VOLTUS_OUTPUT_DIR) $(VOLTUS_REPORT_DIR) $(VOLTUS_LOG_DIR):
	mkdir -p "$@"

$(VOLTUS_RUN_DIR): $(VOLTUS_OUTPUT_DIR) $(VOLTUS_REPORT_DIR) $(VOLTUS_LOG_DIR)
	mkdir -p "$@"

voltus: $(VOLTUS_RUN_DIR)
	@echo "=== Starting Interactive Voltus ==="
	@echo "Run dir: $(VOLTUS_RUN_DIR)"
	cd "$(VOLTUS_RUN_DIR)" && $(ENV_VOLTUS) $(VOLTUS_OPTS) \
		-log "$(VOLTUS_LOG)"

# ----------------------------------------
# Voltus PGV generation
# ----------------------------------------
voltus.pgv: $(VOLTUS_RUN_DIR)
	@echo "=== Starting Voltus PGV Generation ==="
	@echo "Run dir: $(VOLTUS_RUN_DIR)"
	@echo "Script:  $(VOLTUS_PGV_SCRIPT)"
	@test -f "$(VOLTUS_PGV_SCRIPT)" || { echo "ERROR: Script not found: $(VOLTUS_PGV_SCRIPT)"; exit 1; }
	cd "$(VOLTUS_RUN_DIR)" && $(ENV_VOLTUS) $(VOLTUS_OPTS) \
		-log "$(VOLTUS_PGV_LOG)" \
		-init "$(VOLTUS_PGV_SCRIPT)"

# ----------------------------------------
# Voltus static power and rail analysis
# ----------------------------------------
voltus.static: $(VOLTUS_RUN_DIR)
	@echo "=== Starting Voltus Static Analysis ==="
	@echo "Design:  $(ENV_DESIGN)"
	@echo "Run dir: $(VOLTUS_RUN_DIR)"
	@echo "Script:  $(VOLTUS_STATIC_SCRIPT)"
	@echo "PGV:     $(VOLTUS_PGV_LIBRARY)"
	@test -f "$(VOLTUS_STATIC_SCRIPT)" || { echo "ERROR: Script not found: $(VOLTUS_STATIC_SCRIPT)"; exit 1; }
	@test -e "$(VOLTUS_PGV_LIBRARY)" || { echo "ERROR: PGV not found: $(VOLTUS_PGV_LIBRARY). Run make voltus.pgv first."; exit 1; }
	cd "$(VOLTUS_RUN_DIR)" && $(ENV_VOLTUS) $(VOLTUS_OPTS) \
		-log "$(VOLTUS_STATIC_LOG)" \
		-init "$(VOLTUS_STATIC_SCRIPT)"

# ----------------------------------------
# Voltus dynamic power and rail analysis
# ----------------------------------------
voltus.dynamic: $(VOLTUS_RUN_DIR)
	@echo "=== Starting Voltus Dynamic Analysis ==="
	@echo "Design:  $(ENV_DESIGN)"
	@echo "Run dir: $(VOLTUS_RUN_DIR)"
	@echo "Script:  $(VOLTUS_DYNAMIC_SCRIPT)"
	@echo "PGV:     $(VOLTUS_PGV_LIBRARY)"
	@test -f "$(VOLTUS_DYNAMIC_SCRIPT)" || { echo "ERROR: Script not found: $(VOLTUS_DYNAMIC_SCRIPT)"; exit 1; }
	@test -e "$(VOLTUS_PGV_LIBRARY)" || { echo "ERROR: PGV not found: $(VOLTUS_PGV_LIBRARY). Run make voltus.pgv first."; exit 1; }
	cd "$(VOLTUS_RUN_DIR)" && $(ENV_VOLTUS) $(VOLTUS_OPTS) \
		-log "$(VOLTUS_DYNAMIC_LOG)" \
		-init "$(VOLTUS_DYNAMIC_SCRIPT)"

# ----------------------------------------
# Voltus GUI (view saved results)
# ----------------------------------------
voltus.gui: $(VOLTUS_RUN_DIR)
	@echo "=== Starting Voltus Results Viewer ==="
	@echo "Run dir: $(VOLTUS_RUN_DIR)"
	@echo "Script:  $(VOLTUS_GUI_SCRIPT)"
	@test -f "$(VOLTUS_GUI_SCRIPT)" || { echo "ERROR: Script not found: $(VOLTUS_GUI_SCRIPT)"; exit 1; }
	cd "$(VOLTUS_RUN_DIR)" && $(ENV_VOLTUS) $(VOLTUS_OPTS) \
		-log "$(VOLTUS_GUI_LOG)" \
		-init "$(VOLTUS_GUI_SCRIPT)"

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
	       $(VOLTUS_RUN_DIR) \
	       *.session *.cmd *.history *.wlf *.vcd

.PHONY: all genus genus.syn lec innovus.fp innovus innovus.impl innovus.debug \
        voltus voltus.pgv voltus.static voltus.dynamic voltus.gui clean
