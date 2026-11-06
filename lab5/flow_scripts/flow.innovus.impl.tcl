#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|

source $::env(FLOW_DIR)/steps.innovus.tcl


user_init_design
user_read_floorplan
global_net

user_preplace
user_place
user_clock_tree_synthesis
user_route

user_extract_rc

user_write_def
user_write_spef


gui_show
gui_fit


