################################################################################
# Genus synthesis script (clean, fast, sane)
################################################################################

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
set flow        "genus.syn"
set DESIGN      $::env(ENV_DESIGN)
set run_dir     .

set rtlList     $::env(ENV_RTL_LIST)

# ------------------------------------------------------------------------------
# Read RTL (NO MMMC / NO PHYSICAL HERE)
# ------------------------------------------------------------------------------


puts "Reading RTL..."

# read_hdl -define $::env(ENV_DEFINE) -language sv -f $::env(ENV_RTL_LIST)
read_hdl -define $::env(ENV_DEFINE) -language v2001 -f $rtlList

# suspend
read_mmmc $::env(ENV_MMMC)

# read_physical -lefs $::env(ENV_LEF_FILES)

elaborate $DESIGN
# suspend
check_design -unresolved  > ${run_dir}/check_design.rpt

init_design

check_timing_intent      > ${run_dir}/check_timing_intent.rpt

# ------------------------------------------------------------------------------
# Read MMMC (still no physical)
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# User reports
# ------------------------------------------------------------------------------
proc user_reports {} {
    upvar STAGE STAGE
    upvar run_dir run_dir

    file mkdir ${run_dir}/${STAGE}/reports

    report_timing                > ${run_dir}/${STAGE}/reports/report_timing.rpt
    report_timing_summary        > ${run_dir}/${STAGE}/reports/report_timing_summary.rpt
    report_area                  > ${run_dir}/${STAGE}/reports/report_area.rpt
    report_power                 > ${run_dir}/${STAGE}/reports/report_power.rpt
    report_qor                   > ${run_dir}/${STAGE}/reports/report_qor.rpt
    report_hierarchy             > ${run_dir}/${STAGE}/reports/report_hierarchy.rpt
    check_timing_intent -verbose > ${run_dir}/${STAGE}/reports/check_timing_intent.rpt 
}

proc user_out {} {
    upvar STAGE STAGE
    upvar run_dir run_dir
    upvar DESIGN DESIGN

    file mkdir ${run_dir}/${STAGE}/out

    write_hdl                  > ${run_dir}/${STAGE}/out/${DESIGN}.v
    write_db  -to_file           ${run_dir}/${STAGE}/out/${DESIGN}.db
}

# ------------------------------------------------------------------------------
# syn_generic (pure logic)
# ------------------------------------------------------------------------------
set STAGE syn_generic
puts "\033\]2;$STAGE\a"

syn_generic
user_reports
user_out

# ------------------------------------------------------------------------------
# syn_map
# ------------------------------------------------------------------------------
set STAGE syn_map
puts "\033\]2;$STAGE\a"

syn_map
user_reports
user_out

# ------------------------------------------------------------------------------
# syn_opt
# ------------------------------------------------------------------------------
set STAGE syn_opt
puts "\033\]2;$STAGE\a"

set_db tns_opto true
syn_opt
user_reports
user_out

# ------------------------------------------------------------------------------
# LEC
# ------------------------------------------------------------------------------
write_do_lec \
    -golden_design  rtl \
    -revised_design ${run_dir}/${STAGE}/out/${DESIGN}.v \
    -log_file       ${run_dir}/${STAGE}/reports/rtl2final.lec.log \
    >               ${run_dir}/${STAGE}/out/rtl2final.lec.do

# ------------------------------------------------------------------------------
# Finish
# ------------------------------------------------------------------------------
puts "============================"
puts "Synthesis Finished"
puts "============================"

gui_show
# quit
