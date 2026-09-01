# gui_hide

#  ___       _ _   
# |_ _|_ __ (_) |_ 
#  | || '_ \| | __|
#  | || | | | | |_ 
# |___|_| |_|_|\__|

    source ../../../flow_scripts/scripts/flow.init.tcl


    #                       _                
    #  _ __  _ __ ___ _ __ | | __ _  ___ ___ 
    # | '_ \| '__/ _ \ '_ \| |/ _` |/ __/ _ \
    # | |_) | | |  __/ |_) | | (_| | (_|  __/
    # | .__/|_|  \___| .__/|_|\__,_|\___\___|
    # |_|            |_|  

    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
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


    #        _                
    #  _ __ | | __ _  ___ ___ 
    # | '_ \| |/ _` |/ __/ _ \
    # | |_) | | (_| | (_|  __/
    # | .__/|_|\__,_|\___\___|
    # |_| 
        
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
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


    #   ____ _            _       _                                    _   _               _     
    #  / ___| | ___   ___| | __  | |_ _ __ ___  ___    ___ _   _ _ __ | |_| |__   ___  ___(_)___ 
    # | |   | |/ _ \ / __| |/ /  | __| '__/ _ \/ _ \  / __| | | | '_ \| __| '_ \ / _ \/ __| / __|
    # | |___| | (_) | (__|   <   | |_| | |  __/  __/  \__ \ |_| | | | | |_| | | |  __/\__ \ \__ \
    #  \____|_|\___/ \___|_|\_\   \__|_|  \___|\___|  |___/\__, |_| |_|\__|_| |_|\___||___/_|___/
    #                                                      |___/     
    
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - [set STAGE "Clock_tree_synthesis"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    # ------------------
    # CTS options
    # ------------------

    # NDR for clock routing
    create_route_rule -name CTS_2W2S -width_multiplier "Metal2:Metal5 2"  -spacing_multiplier "Metal2:Metal5 2"
    create_route_type -name CTS_RULE   -bottom_preferred_layer 2 -top_preferred_layer 5 -route_rule CTS_2W2S
 
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

#suspend
#  ____             _       
# |  _ \ ___  _   _| |_ ___ 
# | |_) / _ \| | | | __/ _ \
# |  _ < (_) | |_| | ||  __/
# |_| \_\___/ \__,_|\__\___|
    
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
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




#            _                  _   ____   ____ 
#   _____  _| |_ _ __ __ _  ___| |_|  _ \ / ___|
#  / _ \ \/ / __| '__/ _` |/ __| __| |_) | |    
# |  __/>  <| |_| | | (_| | (__| |_|  _ <| |___ 
#  \___/_/\_\\__|_|  \__,_|\___|\__|_| \_\\____|

    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - [set STAGE "extract_rc"] [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
                  
    reset_parasitics
    extract_rc


#                             _     _                               _   
#   _____  ___ __   ___  _ __| |_  | |_ __ _ _ __   ___  ___  _   _| |_ 
#  / _ \ \/ / '_ \ / _ \| '__| __| | __/ _` | '_ \ / _ \/ _ \| | | | __|
# |  __/>  <| |_) | (_) | |  | |_  | || (_| | |_) |  __/ (_) | |_| | |_ 
#  \___/_/\_\ .__/ \___/|_|   \__|  \__\__,_| .__/ \___|\___/ \__,_|\__|
#           |_|                             |_|      

# ------------------
# reports STA
# ------------------

   puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
    - [set STAGE "tapeOut_STA"]  [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"

    time_design -post_route -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} 
    time_design -post_route -report_only -expanded_views -report_dir ./reports/R.${STAGE} -report_prefix R.${STAGE} -hold

    user_reports

    # write db 
    write_db ./db/DB.$::env(ENV_DESIGN).${STAGE}.enc
#suspend

# ------------------
# export netlist 
# ------------------
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - tapeOut_netlist [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    write_netlist ./out/[get_db current_design .name].v
    write_netlist ./out/[get_db current_design .name]_flat.v -flat -line_length 10000

# ------------------
# export sdf
# ------------------
    set sdf_view "typ"
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - tapeOut_sdf [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    write_sdf ./out/[get_db current_design .name].sdf -target_application verilog -precision 4 \
        -view "${sdf_view}"

# ------------------
# export lib. 
# ------------------
set setup_views [get_db [get_db analysis_views -if .is_setup] .name]
set hold_views [get_db [get_db analysis_views -if .is_hold] .name]
set merged_views {}
foreach view [concat $setup_views $hold_views] {
    if {[lsearch -exact $merged_views $view] == -1} {
        lappend merged_views $view
    }
}
set_analysis_view -setup $merged_views -hold $merged_views
foreach view $merged_views {
    write_timing_model \
        -view $view \
        -blackbox_2d -force -include_power_ground \
        -lib_name [get_db current_design .name]_${view} -cell_name [get_db current_design .name] \
        ./out/libs/[get_db current_design .name]_${view}.lib
}

# ------------------
# export def
# ------------------
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - tapeOut_def [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    write_def ./out/[get_db current_design .name].def.gz -floorplan -netlist -routing -routing_to_specialnet -scan_chain

# ------------------
# export lef 
# ------------------
  write_lef_abstract -stripe_pins -top_layer TopMetal2 -no_cut_obs ./out/[get_db current_design .name].lef

# ------------------
# export spef
# ------------------
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - tapeOut_spef [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    all_rc_corners -active
    write_parasitics -spef_file ./out/[get_db current_design .name].typ.spef.gz -rc_corner typ

# ------------------
# export gds 
# ------------------
    puts "\033\]2;[file tail $env(PWD)] - [get_db current_design .name] \
        - tapeOut_gds [clock format [clock seconds] -format "%R     %d / %m / %C%y"]\a"
    write_stream ./out/[get_db current_design .name].gds -lib_name DesignLib -unit 1000 -mode ALL

gui_show
gui_fit






