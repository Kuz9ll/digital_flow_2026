
proc user_clock_tree_synthesis {args} \
{
    
    #   ____ _            _       _                                    _   _               _     
    #  / ___| | ___   ___| | __  | |_ _ __ ___  ___    ___ _   _ _ __ | |_| |__   ___  ___(_)___ 
    # | |   | |/ _ \ / __| |/ /  | __| '__/ _ \/ _ \  / __| | | | '_ \| __| '_ \ / _ \/ __| / __|
    # | |___| | (_) | (__|   <   | |_| | |  __/  __/  \__ \ |_| | | | | |_| | | |  __/\__ \ \__ \
    #  \____|_|\___/ \___|_|\_\   \__|_|  \___|\___|  |___/\__, |_| |_|\__|_| |_|\___||___/_|___/
    #                                                      |___/     

    puts "\033\]2;[file tail $::env(PWD)] - [get_db current_design .name] \
        - [set STAGE "Clock_tree_synthesis"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    # ------------------
    # CTS options
    # ------------------

    # NDR for clock routing
    create_route_rule -name CTS_2W2S -width_multiplier "$::env(TOP_CTS_LAYER_name):$::env(BOT_CTS_LAYER_name) 2"  -spacing_multiplier "$::env(TOP_CTS_LAYER_name):$::env(BOT_CTS_LAYER_name) 2"
    create_route_type -name CTS_RULE   -bottom_preferred_layer $::env(BOT_CTS_LAYER_num) -top_preferred_layer $::env(TOP_CTS_LAYER_num) -route_rule CTS_2W2S

    # Use specified route rules for clock nets
    set_db cts_route_type_leaf   CTS_RULE
    set_db cts_route_type_trunk  CTS_RULE
    set_db cts_route_type_top    CTS_RULE

    create_clock_tree_spec -out_file ccopt_default.spec
    source ccopt_default.spec  
    ccopt_design 

    # ------------------
    # reports
    # ------------------
    time_design -post_cts -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} 
    time_design -post_cts -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} -hold

    user_reports

    # write db 
    write_db ./db/DB.$::env(ENV_DESIGN).${STAGE}.enc

}    



proc user_write_lef {top_layer} \
{
    write_lef_abstract -stripe_pins -top_layer $top_layer -no_cut_obs ./out/[get_db current_design .name].lef
}


proc user_route {args} \
{

    #  ____             _       
    # |  _ \ ___  _   _| |_ ___ 
    # | |_) / _ \| | | | __/ _ \
    # |  _ < (_) | |_| | ||  __/
    # |_| \_\___/ \__,_|\__\___|

    puts "\033\]2;[file tail $::env(PWD)] - [get_db current_design .name] \
        - [set STAGE "Route"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"


    route_design -global_detail
    add_fillers -base_cells $::env(ENV_FILLER_CELLS) -prefix FILLER 

    # ------------------
    # reports
    # ------------------
    time_design -post_route -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} 
    time_design -post_route -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} -hold

    user_reports

    # write db 
    write_db ./db/DB.$::env(ENV_DESIGN).${STAGE}.enc

        
}


proc user_write_spef {args} \
{
    all_rc_corners -active
    write_parasitics -spef_file ./out/[get_db current_design .name].typ.spef.gz -rc_corner typ
}


proc user_write_gds {args} \
{
    write_stream ./out/[get_db current_design .name].gds -lib_name DesignLib -unit 1000 -mode ALL
}



proc user_init_design {} \
{
 
    # ------------------
    # Init design
    # ------------------
    if {[info exists ::env(TECH_SIZE)] && $::env(TECH_SIZE) ne ""} {
        set_db design_process_node $::env(TECH_SIZE)
    }

    set_db init_netlist_files  $::env(ENV_NETLIST)
    set_db init_lef_files      $::env(ENV_LEF_FILES)
    set_db init_power_nets     $::env(ENV_POWER_NETS)
    set_db init_ground_nets    $::env(ENV_GROUND_NETS)
    set_db init_mmmc_files     $::env(ENV_MMMC)

    read_mmmc     $::env(ENV_MMMC)
    read_physical -lef $::env(ENV_LEF_FILES)

    read_netlist  $::env(ENV_NETLIST) -top $::env(ENV_DESIGN)
    init_design


}


proc global_net {} \
{
    connect_global_net VDD -type pg_pin -pin_base_name VDD -inst_base_name *
    connect_global_net VSS -type pg_pin -pin_base_name VSS -inst_base_name *
}



proc user_read_floorplan {} {
    # ----------------------------------------------------------
    # Floorplan file áåð¸ì èç ENV_FLOORPLAN_FILE (ñì. Makefile)
    # ENV_INNOVUS_FP  ýòî èìÿ çàïóñêàåìîé óòèëèòû, ÍÅ ôàéë floorplan
    # ----------------------------------------------------------
    set fp_file ""

    if {[info exists ::env(ENV_FLOORPLAN_FILE)] && $::env(ENV_FLOORPLAN_FILE) ne ""} {
        set fp_file $::env(ENV_FLOORPLAN_FILE)
    }

    if {$fp_file eq ""} {
        puts "WARN: ENV_FLOORPLAN_FILE is not set, skip read_floorplan"
        return
    }

    if {![file exists $fp_file]} {
        puts "WARN: floorplan file not found: $fp_file"
        return
    }

    # ×èòàåì floorplan
    read_floorplan $fp_file

    # Êîïèðóåì èñõîäíûé .fp è åãî .spr (åñëè åñòü) â ./in
    if {![file exists ./in]} {
        file mkdir ./in
    }

    file copy -force $fp_file ./in
    puts "INFO: copied floorplan  -> ./in/[file tail $fp_file]"

    set spr_file "${fp_file}.spr"
    if {[file exists $spr_file]} {
        file copy -force $spr_file ./in
        puts "INFO: copied floorplan  -> ./in/[file tail $spr_file]"
    }
}




proc user_preplace {args} \
{
    
    #                       _                
    #  _ __  _ __ ___ _ __ | | __ _  ___ ___ 
    # | '_ \| '__/ _ \ '_ \| |/ _` |/ __/ _ \
    # | |_) | | |  __/ |_) | | (_| | (_|  __/
    # | .__/|_|  \___| .__/|_|\__,_|\___\___|
    # |_|            |_|  

    puts "\033\]2;[file tail $::env(PWD)] - [get_db current_design .name] \
        - [set STAGE "prePlace"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
        
    delete_buffer_trees

    # ------------------
    # reports
    # ------------------
    time_design -pre_place -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} 
    time_design -pre_place -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} -hold

    user_reports

    # write db 
    write_db ./db/DB.$::env(ENV_DESIGN).${STAGE}.enc




}



proc user_extract_rc {args} \
{
   
    #            _                  _   ____   ____ 
    #   _____  _| |_ _ __ __ _  ___| |_|  _ \ / ___|
    #  / _ \ \/ / __| '__/ _` |/ __| __| |_) | |    
    # |  __/>  <| |_| | | (_| | (__| |_|  _ <| |___ 
    #  \___/_/\_\\__|_|  \__,_|\___|\__|_| \_\\____|

    puts "\033\]2;[file tail $::env(PWD)] - [get_db current_design .name] \
        - [set STAGE "extract_rc"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
                  
    reset_parasitics
    extract_rc
}


proc user_sta {args} \
{
    time_design -post_route -report_only -expanded_views -report_dir ./reports/sta -report_prefix sta 
    time_design -post_route -report_only -expanded_views -report_dir ./reports/sta -report_prefix sta -hold
}

proc user_write_netlist {args} \
{
    write_netlist ./out/[get_db current_design .name].v
    # write_netlist ./out/[get_db current_design .name]_flat.v -flat -line_length 10000

}

proc user_write_sdf {sdf_view} \
{
    
    write_sdf ./out/[get_db current_design .name].sdf -target_application verilog -precision 4 \
        -view "${sdf_view}"
}




proc user_write_lib {setup_views hold_views } \
{

    set_analysis_view -setup $setup_views -hold $hold_views

    set list [concat $setup_views $hold_views]

    foreach view $list {
    write_timing_model \
        -view $view \
        -blackbox_2d -force -include_power_ground \
        -lib_name [get_db current_design .name]_${view} -cell_name [get_db current_design .name] \
        ./out/[get_db current_design .name]_${view}.lib
    }
    
}


proc user_write_def {args} \
{
    write_def ./out/[get_db current_design .name].def.gz -floorplan -netlist -routing -routing_to_specialnet -scan_chain 
}





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


proc user_place {args} \
{


    #        _                
    #  _ __ | | __ _  ___ ___ 
    # | '_ \| |/ _` |/ __/ _ \
    # | |_) | | (_| | (_|  __/
    # | .__/|_|\__,_|\___\___|
    # |_| 
        
    puts "\033\]2;[file tail $::env(PWD)] - [get_db current_design .name] \
        - [set STAGE "place"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"

    place_opt_design

    # ------------------
    # reports
    # ------------------
    time_design -pre_cts -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} 
    time_design -pre_cts -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} -hold

    user_reports

    # write db 
    write_db ./db/DB.$::env(ENV_DESIGN).${STAGE}.enc

}


