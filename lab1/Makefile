# ============================================================
export FLOW_DIR   				= $(PWD)/flows
export PDK_DIR     				= $(PWD)/PDK
export ENV_MMMC                 = $(ENV_DESIGN_DIR)/mmmc.view
export ENV_LEF_FILES            = $(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lef/sg13g2_tech.lef $(PDK_DIR)/IHP_Open_PDK/sg13g2_stdcell/lef/sg13g2_stdcell.lef
export ENV_DESIGN               = s38584
export ENV_DESIGN_DIR           = $(PWD)/data
export ENV_NETLIST          	= $(GENUS_OUTPUT_DIR)/syn_opt/$(ENV_DESIGN).v
export ENV_POWER_NETS       	= VDD
export ENV_GROUND_NETS      	= VSS
export ENV_FLOORPLAN_FILE   	= $(ENV_DESIGN_DIR)/floorplan/my_floorplan.fp


# ============================================================
# Genus Synthesis
# ============================================================
export GENUS_RUN_DIR     = $(PWD)/run/genus
export GENUS_OUTPUT_DIR  = $(GENUS_RUN_DIR)/outputs
export GENUS_REPORT_DIR  = $(GENUS_RUN_DIR)/reports
export GENUS_LOG_DIR     = $(GENUS_RUN_DIR)/logs

export GENUS_SCRIPT = $(FLOW_DIR)/genus.syn.tcl
export GENUS_LOG    = $(GENUS_LOG_DIR)/synth.log

export GENUS_OPTS  = 
export GENUS       = genus

# ============================================================
# Innovus/Floorplanning
# ============================================================
export FP_RUN_DIR     = $(PWD)/run/fp
export FP_OUTPUT_DIR  = $(FP_RUN_DIR)/outputs
export FP_REPORT_DIR  = $(FP_RUN_DIR)/reports
export FP_LOG_DIR     = $(FP_RUN_DIR)/logs

export FP_SCRIPT = $(FLOW_DIR)/innovus.fp.tcl
export FP_LOG    = $(FP_LOG_DIR)/fp.log

export INNOVUS    = innovus
export INNOVUS_OPTS = -stylus

# ============================================================
# Clock Mesh / R2GDS
# ============================================================
export CLOCK_MESH_RUN_DIR     = $(PWD)/run/clock_mesh
export CLOCK_MESH_OUTPUT_DIR  = $(CLOCK_MESH_RUN_DIR)/outputs
export CLOCK_MESH_REPORT_DIR  = $(CLOCK_MESH_RUN_DIR)/reports
export CLOCK_MESH_LOG_DIR     = $(CLOCK_MESH_RUN_DIR)/logs

export CLOCK_MESH_SCRIPT = $(FLOW_DIR)/innovus.clock_mesh.tcl
export CLOCK_MESH_LOG    = $(CLOCK_MESH_LOG_DIR)/clock_mesh.log

# ============================================================
# Environment variables for Genus script
# ============================================================
export ENV_DEFINE               =
export ENV_INIT_HDL_SEARCH_PATH = 
export ENV_RTL_DIR              = $(ENV_DESIGN_DIR)/rtl
export ENV_RTL_LIST             = $(ENV_RTL_DIR)/s38584.lst

# ============================================================
# Environment variables for Floorplanning script
# ============================================================


# ============================================================
# Targets
# ============================================================

all: synth

# ----------------------------------------
# Synthesis
# ----------------------------------------
$(GENUS_OUTPUT_DIR) $(GENUS_REPORT_DIR) $(GENUS_LOG_DIR):
	mkdir -p $@

synth: $(GENUS_OUTPUT_DIR) $(GENUS_REPORT_DIR) $(GENUS_LOG_DIR)
	@echo "=== Starting Synthesis ==="
	@echo "Design: $(ENV_DESIGN)"
	@echo "RTL list: $(ENV_RTL_LIST)"
	cd $(GENUS_RUN_DIR) && $(GENUS) $(GENUS_OPTS) -files $(GENUS_SCRIPT) 2>&1 | tee $(GENUS_LOG)
	@echo "=== Synthesis Complete ==="
	@echo "Log saved to: $(GENUS_LOG)"

# ----------------------------------------
# Floorplanning
# ----------------------------------------
$(FP_OUTPUT_DIR) $(FP_REPORT_DIR) $(FP_LOG_DIR):
	mkdir -p $@

fp: $(FP_OUTPUT_DIR) $(FP_REPORT_DIR) $(FP_LOG_DIR)
	@echo "=== Starting Floorplanning ==="
	@if [ ! -f "$(ENV_NETLIST)" ]; then \
		echo "ERROR: Netlist not found: $(ENV_NETLIST)"; \
		echo "Please run 'make synth' first or check ENV_NETLIST"; \
		exit 1; \
	fi
	@echo "Design: $(ENV_DESIGN)"
	@echo "Netlist: $(ENV_NETLIST)"
	@echo "MMMC: $(ENV_MMMC)"
	@echo "LEF files: $(ENV_LEF_FILES)"
	cd $(FP_RUN_DIR) && $(INNOVUS) $(INNOVUS_OPTS) -files $(FP_SCRIPT) 2>&1 | tee $(FP_LOG)
	@echo "=== Floorplanning Complete ==="
	@echo "Log saved to: $(FP_LOG)"

# ----------------------------------------
# Clock Mesh / R2GDS
# ----------------------------------------
$(CLOCK_MESH_OUTPUT_DIR) $(CLOCK_MESH_REPORT_DIR) $(CLOCK_MESH_LOG_DIR):
	mkdir -p $@

clock_mesh: $(CLOCK_MESH_OUTPUT_DIR) $(CLOCK_MESH_REPORT_DIR) $(CLOCK_MESH_LOG_DIR)
	@echo "=== Starting Clock Mesh / R2GDS ==="
	@if [ ! -f "$(ENV_FLOORPLAN_FILE)" ]; then \
		echo "ERROR: Floorplan file not found: $(ENV_FLOORPLAN_FILE)"; \
		echo "Please run 'make fp' first or check ENV_FLOORPLAN_FILE"; \
		exit 1; \
	fi
	@echo "Design: $(ENV_DESIGN)"
	@echo "Input floorplan: $(ENV_FLOORPLAN_FILE)"
	@echo "MMMC: $(ENV_MMMC)"
	@echo "LEF files: $(ENV_LEF_FILES)"
	cd $(CLOCK_MESH_RUN_DIR) && $(INNOVUS) $(INNOVUS_OPTS) -files $(CLOCK_MESH_SCRIPT) 2>&1 | tee $(CLOCK_MESH_LOG)
	@echo "=== Clock Mesh / R2GDS Complete ==="
	@echo "Log saved to: $(CLOCK_MESH_LOG)"

# ----------------------------------------
# Clean
# ----------------------------------------
clean:
	rm -rf $(GENUS_LOG_DIR) $(GENUS_REPORT_DIR) $(GENUS_OUTPUT_DIR) $(GENUS_RUN_DIR) *.session *.cmd *.history *.wlf *.vcd
	rm -rf $(FP_LOG_DIR) $(FP_REPORT_DIR) $(FP_OUTPUT_DIR) $(FP_RUN_DIR)
	rm -rf $(CLOCK_MESH_LOG_DIR) $(CLOCK_MESH_REPORT_DIR) $(CLOCK_MESH_OUTPUT_DIR) $(CLOCK_MESH_RUN_DIR)

.PHONY: all synth fp clock_mesh full_flow clean
