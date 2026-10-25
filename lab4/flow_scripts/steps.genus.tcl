
proc step_genus_gen {} \
{

    set STAGE syn_generic
    puts "\033\]2;$STAGE\a"

    syn_generic

    step_genus_user_reports $STAGE
    step_genus_user_out $STAGE
}




proc step_genus_user_reports {STAGE} {

    set dir $::env(GENUS_REPORT_DIR)/${STAGE}

    report_timing                > ${dir}/report_timing.rpt
    report_timing_summary        > ${dir}/report_timing_summary.rpt
    report_area                  > ${dir}/report_area.rpt
    report_power                 > ${dir}/report_power.rpt
    report_qor                   > ${dir}/report_qor.rpt
    report_hierarchy             > ${dir}/report_hierarchy.rpt
    check_timing_intent -verbose > ${dir}/check_timing_intent.rpt 
}

proc step_genus_user_out {STAGE} {
    set dir $::env(GENUS_OUTPUT_DIR)/${STAGE}


    write_hdl                  > ${dir}/$::env(ENV_DESIGN).v
    write_db  -to_file           ${dir}/$::env(ENV_DESIGN).db
}



proc step_genus_opt {args} \
{
    set STAGE syn_opt
    puts "\033\]2;$STAGE\a"

    syn_opt   

    step_genus_user_reports $STAGE
    step_genus_user_out $STAGE    
}


proc step_genus_read_hdl {} \
{

     # Choose one options:
    # read_hdl -define $::env(ENV_DEFINE) -language v2001 -f $::env(ENV_RTL_LIST)  ; # if rtl write on Verilog
    read_hdl -define $::env(ENV_DEFINE) -sv -f $::env(ENV_RTL_LIST)  ; # if rtl write on SystemVerilog
}


proc step_genus_read_mmmc {} \
{
    read_mmmc $::env(ENV_MMMC)  
}
# suspend

proc step_genus_init_design {args} \
{
   init_design
   check_timing_intent      > $::env(GENUS_RUN_DIR)/check_timing_intent.rpt
}
# suspend



proc step_genus_map {args} \
{

    set STAGE syn_map
    puts "\033\]2;$STAGE\a"

    syn_map 

    step_genus_user_reports $STAGE
    step_genus_user_out $STAGE
}



proc step_genus_lec {output_netlist } \
{

    write_do_lec -golden_design rtl -revised_design $output_netlist -log_file $::env(GENUS_REPORT_DIR)/rtl2final.lec.log  \
    > $::env(GENUS_OUTPUT_DIR)/rtl2final.lec.do


}





proc step_genus_host_info {} \
{

    # ------------------------------------------------------------------------------
    # Host info
    # ------------------------------------------------------------------------------
    if {[file exists /proc/cpuinfo]} {
        sh grep "model name" /proc/cpuinfo
        sh grep "cpu MHz"    /proc/cpuinfo
    }
    puts "Hostname : [info hostname]"

  
}


proc step_genus_global_options {} \
{
    # ------------------------------------------------------------------------------
    # Global options
    # ------------------------------------------------------------------------------
    set_db timing_report_time_unit ns

    # CPUs / threading
    # set_db elaboration_threads        8
    # set_db synthesis_threads          8
    set_db max_cpus_per_server        8

    # Synthesis effort
    set_db syn_generic_effort         medium
    set_db syn_map_effort             medium
    set_db syn_opt_effort             medium

    # Optimization controls
    set_db information_level          1

    # HDL
    set_db init_hdl_search_path       $::env(ENV_INIT_HDL_SEARCH_PATH)
    
}



proc step_genus_elaborate {} \
{
    elaborate $::env(ENV_DESIGN)
    check_design -unresolved  > $::env(GENUS_RUN_DIR)/check_design.rpt 
}
