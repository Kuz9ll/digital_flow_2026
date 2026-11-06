# ------------------------------------------------------------------------------
# Start
# ------------------------------------------------------------------------------

source $::env(FLOW_DIR)/steps.genus.tcl


step_genus_global_options
step_genus_read_hdl
step_genus_read_mmmc
step_genus_elaborate
step_genus_init_design
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
