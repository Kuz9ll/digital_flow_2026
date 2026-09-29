# ------------------------------------------------------------------------------
# Start
# ------------------------------------------------------------------------------

source $::env(FLOW_DIR)/steps.genus.tcl

step_genus_read_hdl
step_genus_read_mmmc
step_genus_host_info
step_genus_global_options
step_genus_read_1
step_genus_read_2
step_genus_lec $::env(GENUS_RUN_DIR)/genus/outputs/syn_opt/counter.v
step_genus_gen
step_genus_map
step_genus_opt
# ------------------------------------------------------------------------------
# Finish
# ------------------------------------------------------------------------------
puts "============================"
puts "Synthesis Finished"
puts "============================"

gui_show
# quit