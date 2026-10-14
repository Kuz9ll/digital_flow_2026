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


proc user_read_floorplan {} \
{
    # ------------------
    # Floorplan  from ENV_INNOVUS_FP (new Makefile var)
    # ------------------
    set fp_file ""
    if {[info exists ::env(ENV_INNOVUS_FP)] && $::env(ENV_INNOVUS_FP) ne ""} {
        set fp_file $::env(ENV_INNOVUS_FP)
    } elseif {[info exists ::env(ENV_FLOORPLAN_FILE)] && $::env(ENV_FLOORPLAN_FILE) ne ""} {
        set fp_file $::env(ENV_FLOORPLAN_FILE)
    }

    if {$fp_file ne ""} {
        if {[file exists $fp_file]} {
            read_floorplan $fp_file
            file copy -force $fp_file ./in
            if {[file exists "${fp_file}.spr"]} {
                file copy -force "${fp_file}.spr" ./in
            }
        } else {
            puts "WARN: floorplan file not found: $fp_file"
        }
    }


}


proc global_net {} \
{
    connect_global_net vdd -type pg_pin -pin_base_name vdd -inst_base_name *
    connect_global_net gnd -type pg_pin -pin_base_name gnd -inst_base_name *


}


