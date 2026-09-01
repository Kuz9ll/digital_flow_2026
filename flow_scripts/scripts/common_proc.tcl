
    proc user_reports {} {
        upvar 1 STAGE STAGE
        mkdir -p ./reports/R.${STAGE}
        check_timing -verbose > ./reports/R.${STAGE}/checkTiming.rpt
        check_netlist -out_file ./reports/R.${STAGE}/checkNetlist.rpt
        report_area > ./reports/R.${STAGE}/report_area.rpt
        report_power -out_file ./reports/R.${STAGE}/report_power.rep
        user_report_Screenshot      
        puts "${STAGE} [clock format [clock seconds] -format "%R     %d / %m / %C%y"]" >> ./reports/time_log.rep
    }


    proc user_report_Screenshot {} {
        upvar 1 STAGE STAGE
        set_layer_preference node_layer -is_visible 1
        set_layer_preference node_net -is_visible 1
        set_layer_preference phyCell -is_visible 1
        gui_set_draw_view place
        gui_show
        gui_fit
        write_to_gif ./reports/R.${STAGE}/R.${STAGE}_Screenshot_place_mode.gif
        delete_drc_markers
        set_layer_preference node_net -is_visible 0
        set_layer_preference clock -is_visible 1
        write_to_gif ./reports/R.${STAGE}/R.${STAGE}_Screenshot_clock_mode.gif

        set_layer_preference node_layer -is_visible 0
        write_to_gif ./reports/R.${STAGE}/R.${STAGE}_Screenshot_cells_mode.gif

        set_layer_preference node_layer -is_visible 1
        set_layer_preference node_cell -is_visible 0
        set_layer_preference node_net -is_visible 1
        gui_hide

    }


    

proc proc_create_floorplan_init {density bot_layer top_layer} \
{
    delete_routes
    delete_route_blockages -type routes
    delete_pin_blockages -all
    delete_filler -prefix ENDCAP
    delete_filler -prefix FILLER
    delete_filler -prefix ENDCAP
    delete_filler -prefix WELLTAP
    init_core_rows
     
    create_floorplan -stdcell_density_size 1 $density

    set llx [get_db designs .bbox.ll.x]
    set lly [get_db designs .bbox.ll.y]
    set urx [get_db designs .bbox.ur.x]
    set ury [get_db designs .bbox.ur.y]

    set die_llx [expr { ${llx} + 0 }]
    set die_lly [expr { ${lly} + 0 }]
    set die_urx [expr { ${urx} + 29 }]
    set die_ury [expr { ${ury} + 29 }]

    set core_llx [expr { ${die_llx} + 11.5 }]
    set core_lly [expr { ${die_lly} + 11.5 }]
    set core_urx [expr { ${die_urx} - 11.5 }]
    set core_ury [expr { ${die_ury} - 11.5 }]
    
    create_floorplan  -box_size $die_llx $die_lly $die_urx $die_ury $die_llx $die_lly $die_urx $die_ury $core_llx $core_lly $core_urx $core_ury

    # ------------------
    # Power grid # PDK differ
    # ------------------
    set_db add_rings_skip_shared_inner_ring none ; set_db add_rings_avoid_short 1 ; set_db add_rings_ignore_rows 0 ; set_db add_rings_extend_over_row 0
    add_rings -type core_rings -jog_distance 0.6 -threshold 0.6 -nets {VDD VSS} -follow core -layer "bottom ${bot_layer} top ${bot_layer} right ${top_layer} left ${top_layer}" -width 4 -spacing 1.5 
    # add_stripes -nets {VDD VSS} -layer M5 -width 2 -start_from left -start_offset 10 -stop_offset 10 -number_of_sets 4 -spacing 1.5 
    

    #add_endcaps  -prefix ENDCAP
    route_special -allow_layer_change 0 -nets {VDD VSS}

  # edit pins
    set_db assign_pins_edit_in_batch true
    edit_pin -fix_overlap 1 -fixed_pin true -unit track -spread_direction clockwise -side Left -layer 3 -spread_type center -spacing 2.0 -pin [get_db [get_db ports -if {.direction == in}] .name]
    edit_pin -fix_overlap 1 -fixed_pin true -unit track -spread_direction clockwise -side Right -layer 3 -spread_type center -spacing 2.0 -pin [get_db [get_db ports -if {.direction == out}] .name]
    edit_pin -fix_overlap 1 -fixed_pin true -unit track -spread_direction clockwise -side Top -layer 3 -spread_type center -spacing 2.0 -pin [get_db [get_db ports -if {.name == CK }] .name]
    set_db assign_pins_edit_in_batch false
}
