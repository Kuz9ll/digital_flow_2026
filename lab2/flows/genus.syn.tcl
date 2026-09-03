################################################################################
# Genus synthesis script (clean, fast, sane)
################################################################################
proc user_reports {} {
    upvar STAGE STAGE

    set dir $::env(GENUS_REPORT_DIR)/${STAGE}

    report_timing                > ${dir}/report_timing.rpt
    report_timing_summary        > ${dir}/report_timing_summary.rpt
    report_area                  > ${dir}/report_area.rpt
    report_power                 > ${dir}/report_power.rpt
    report_qor                   > ${dir}/report_qor.rpt
    report_hierarchy             > ${dir}/report_hierarchy.rpt
    check_timing_intent -verbose > ${dir}/check_timing_intent.rpt 
}

proc user_out {} {
    upvar STAGE STAGE

    set dir $::env(GENUS_OUTPUT_DIR)/${STAGE}


    write_hdl                  > ${dir}/$::env(ENV_DESIGN).v
    write_db  -to_file           ${dir}/$::env(ENV_DESIGN).db
}


# ------------------------------------------------------------------------------
# Host info
# ------------------------------------------------------------------------------
if {[file exists /proc/cpuinfo]} {
    sh grep "model name" /proc/cpuinfo
    sh grep "cpu MHz"    /proc/cpuinfo
}
puts "Hostname : [info hostname]"

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
set_db tns_opto                   false
set_db information_level          1

# HDL
set_db init_hdl_search_path       $::env(ENV_INIT_HDL_SEARCH_PATH)

# ------------------------------------------------------------------------------
# Design setup
# ------------------------------------------------------------------------------

set DESIGN      $::env(ENV_DESIGN)
  
# ------------------------------------------------------------------------------
# Read RTL (NO MMMC / NO PHYSICAL HERE)
# ------------------------------------------------------------------------------

puts "Reading RTL..."
# suspend
# read_hdl -define $::env(ENV_DEFINE) -language sv -f $::env(ENV_RTL_LIST)
read_hdl -define $::env(ENV_DEFINE) -language v2001 -f $::env(ENV_RTL_LIST)

# suspend
read_mmmc $::env(ENV_MMMC)

# read_physical -lefs $::env(ENV_LEF_FILES)

elaborate $::env(ENV_DESIGN)
# suspend
check_design -unresolved  > $::env(GENUS_RUN_DIR)/check_design.rpt

init_design

check_timing_intent      > $::env(GENUS_RUN_DIR)/check_timing_intent.rpt

# ------------------------------------------------------------------------------
# User reports
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# syn_generic (pure logic)
# ------------------------------------------------------------------------------
set STAGE syn_generic
puts "\033\]2;$STAGE\a"

syn_generic

# ------------------------------------------------------------------------------
# syn_map
# ------------------------------------------------------------------------------
set STAGE syn_map
puts "\033\]2;$STAGE\a"

syn_map

# ------------------------------------------------------------------------------
# syn_opt
# ------------------------------------------------------------------------------
set STAGE syn_opt
puts "\033\]2;$STAGE\a"

syn_opt
user_reports
user_out

# ------------------------------------------------------------------------------
# Finish
# ------------------------------------------------------------------------------
puts "============================"
puts "Synthesis Finished"
puts "============================"

gui_show
# quit
