# gui_hide

#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|

# ------------------
# Setup env
# ------------------
set ::env(STEP) "BACKEND"
mkdir -p "./db"
mkdir -p "./out/libs"
mkdir -p "./reports"
source $::env(ENV_FLOW_SCRIPTS)scripts/common_proc.tcl
# # Check
# stop
# ------------------
# Init design
# ------------------  
# set_db design_process_node  $::env(TECH_SIZE)

#set_db init_lib_search_path $::env(ENV_INIT_LIB_SEARCH_PATH); # Path will be used for finding libs and lefs

#suspend
set_db init_netlist_files   $::env(ENV_NETLIST)
set_db init_lef_files       $::env(ENV_LEF_FILES)
set_db init_power_nets      $::env(ENV_POWER_NETS)
set_db init_ground_nets     $::env(ENV_GROUND_NETS)
set_db init_mmmc_files      $::env(ENV_MMMC)
# set_db init_io_file         $::env(IO_FILE) 

read_mmmc                   $::env(ENV_MMMC)
read_physical -lef 	    $::env(ENV_LEF_FILES)

read_netlist                $::env(ENV_NETLIST) \
    -top $::env(ENV_DESIGN)
init_design
# ------------------
# Global net
# ------------------
source $::env(ENV_FLOW_SCRIPTS)scripts/globalNetConnect.tcl
# ------------------
# Read the Scan DEF
# ------------------
# read_def $::env(DEF_FILE)
# set_db reorder_scan_comp_logic true
# ------------------
# Setup options for flow
# ------------------
# STA
set_db timing_report_launch_clock_path true
set_db timing_report_enable_auto_column_width true
set_db opt_time_design_compress_reports false

group_path   -name in2reg   \
    -from   [all_inputs -no_clocks] -to [all_registers]
group_path   -name reg2reg  \
    -from   [all_registers]         -to [all_registers]
group_path   -name reg2out  \
    -from   [all_registers]         -to [all_outputs]
group_path   -name in2out   \
    -from   [all_inputs -no_clocks] -to [all_outputs]

# # Detail Routing 
set_db route_design_with_timing_driven 1
set_db route_design_with_si_driven 1
set_db route_design_top_routing_layer 9      ; # PDK differ
set_db route_design_bottom_routing_layer 2   ; # PDK differ
set_db route_design_detail_end_iteration 0
set_db route_design_with_timing_driven true
set_db route_design_with_si_driven true


if {[info exists ::env(ENV_FLOORPLAN_FILE)]} {
    read_floorplan $::env(ENV_FLOORPLAN_FILE)
}

