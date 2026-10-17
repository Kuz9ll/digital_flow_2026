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


proc global_net {} \
{
    connect_global_net VDD -type pg_pin -pin_base_name vdd -inst_base_name *
    connect_global_net VSS -type pg_pin -pin_base_name gnd -inst_base_name *
    connect_global_net VSS -type pg_pin -pin_base_name vss -inst_base_name *



}


