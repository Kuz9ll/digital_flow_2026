#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|


source ../../../flow_scripts/scripts/flow.init.tcl

gui_show
gui_fit


if {NO} {
    


#######################################################



delete_routes
delete_route_blockages -type routes
delete_pin_blockages -all
delete_filler -prefix ENDCAP
delete_filler -prefix FILLER
delete_filler -prefix ENDCAP
delete_filler -prefix WELLTAP
init_core_rows



set density 0.3
create_floorplan -stdcell_density_size 1 $density


# s

#     # ------------------
#     # Power grid # PDK differ
#     # ------------------
#     set_db add_rings_skip_shared_inner_ring none ; set_db add_rings_avoid_short 1 ; set_db add_rings_ignore_rows 0 ; set_db add_rings_extend_over_row 0
#     add_rings -type core_rings -jog_distance 0.6 -threshold 0.6 -nets {VDD VSS} -follow core -layer "bottom ${h_layer} top ${h_layer} right ${v_layer} left ${v_layer}" -width 4 -spacing 1.5 
#     # add_stripes -nets {VDD VSS} -layer M5 -width 2 -start_from left -start_offset 10 -stop_offset 10 -number_of_sets 4 -spacing 1.5 
    

    #add_endcaps  -prefix ENDCAP
    route_special -allow_layer_change 0 -nets {VDD VSS}

  # edit pins
    set_db assign_pins_edit_in_batch true
    edit_pin -fix_overlap 1 -fixed_pin true -unit track -spread_direction clockwise -side Left -layer 3 -spread_type center -spacing 2.0 -pin [get_db [get_db ports -if {.direction == in}] .name]
    edit_pin -fix_overlap 1 -fixed_pin true -unit track -spread_direction clockwise -side Right -layer 3 -spread_type center -spacing 2.0 -pin [get_db [get_db ports -if {.direction == out}] .name]
    edit_pin -fix_overlap 1 -fixed_pin true -unit track -spread_direction clockwise -side Top -layer 3 -spread_type center -spacing 2.0 -pin [get_db [get_db ports -if {.name == clk }] .name]
    set_db assign_pins_edit_in_batch false



    # proc_create_floorplan_init 0.5 Mela5 Melal6


    write_floorplan ../../data/AsyncFIFO/floorplan/[get_db current_design .name].fp

    write_floorplan "../../data/floorplan/my_floorplan.fp"

    read_floorplan "../../data/floorplan/my_floorplan.fp"


# ...

}
