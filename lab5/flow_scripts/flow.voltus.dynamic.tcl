# ============================================================
# Voltus 20.10 Common UI vectorless dynamic power and IR drop
# ============================================================
# Example for a single always-on VDD/VSS domain.
# Run make voltus.dynamic from the project root after make voltus.pgv.
# The Makefile supplies the settings. The design database supplies MMMC, Liberty, and SDC.
# Vectorless analysis derives switching events from activity and timing.
# Dynamic analysis uses a simplified model with the techonly PGV.

# ============================================================
# Inputs
# ============================================================
set DESIGN_DB $::env(VOLTUS_DESIGN_DB)
set SPEF_FILE $::env(VOLTUS_SPEF_FILE)

set ANALYSIS_VIEW $::env(VOLTUS_ANALYSIS_VIEW)
set RC_CORNER $::env(VOLTUS_RC_CORNER)

set VOLTAGE $::env(VOLTUS_VOLTAGE)
set IR_DROP_FRACTION $::env(VOLTUS_IR_DROP_FRACTION)
set TEMPERATURE $::env(VOLTUS_TEMPERATURE)

set POWER_NET $::env(VOLTUS_POWER_NET)
set GROUND_NET $::env(VOLTUS_GROUND_NET)

set PGV_FILE $::env(VOLTUS_PGV_LIBRARY)
set VDD_PAD_FILE $::env(VOLTUS_VDD_PAD_FILE)
set VSS_PAD_FILE $::env(VOLTUS_VSS_PAD_FILE)

set INPUT_ACTIVITY $::env(VOLTUS_INPUT_ACTIVITY)
set ACTIVITY_PERIOD $::env(VOLTUS_ACTIVITY_PERIOD)
set CLOCK_GATE_RATIO $::env(VOLTUS_CLOCK_GATE_RATIO)
set TIME_RESOLUTION $::env(VOLTUS_TIME_RESOLUTION)

set POWER_DIR $::env(VOLTUS_DYNAMIC_POWER_DIR)
set RAIL_DIR $::env(VOLTUS_DYNAMIC_RAIL_DIR)

if {$ANALYSIS_VIEW eq "" || $RC_CORNER eq ""} {
    error "Choose VOLTUS_ANALYSIS_VIEW and VOLTUS_RC_CORNER in Makefile."
}

file mkdir $POWER_DIR $RAIL_DIR

# ============================================================
# Load the design and signal parasitics
# ============================================================
read_db -physical_data $DESIGN_DB

read_spef \
    -rc_corner $RC_CORNER \
    -decoupled \
    $SPEF_FILE

set_power_rail $POWER_NET -power -voltage $VOLTAGE -force
set_power_rail $GROUND_NET -ground

# ============================================================
# Configure dynamic power analysis
# ============================================================
set_db power_view $ANALYSIS_VIEW
set_db power_method dynamic_vectorless

# Save average results and the power database alongside the dynamic results.
set_db power_disable_static false
set_db power_write_static_currents true
set_db power_write_db true
set_db power_db_name dynamic_power.db
set_db power_grid_libraries [list $PGV_FILE]

set_power_output_dir $POWER_DIR

# ============================================================
# Switching activity
# ============================================================
set_default_switching_activity -reset
set_switching_activity -reset

# Use the Liberty time unit for ACTIVITY_PERIOD to normalize switching activity.
# Clock constraints come from the SDC.
set_default_switching_activity \
    -input_activity $INPUT_ACTIVITY \
    -period $ACTIVITY_PERIOD \
    -clock_gates_output_ratio $CLOCK_GATE_RATIO

# If the design has a reset input, set it to its inactive state.
# The example below applies to an active-high rst input.
# set_switching_activity -input_port rst -activity 0.0 -duty 0.0

propagate_activity

# ============================================================
# Set the time resolution and calculate transient currents
# ============================================================
set_dynamic_power_simulation -reset
set_dynamic_power_simulation -resolution $TIME_RESOLUTION

# Voltus selects the vectorless simulation duration.
# Check the clocks and simulation window in the log.
report_power -out_file dynamic.rpt

# ============================================================
# Configure dynamic rail analysis
# ============================================================
set_rail_analysis_config \
    -method dynamic \
    -accuracy xd \
    -analysis_view $ANALYSIS_VIEW \
    -temperature $TEMPERATURE \
    -power_grid_libraries [list $PGV_FILE] \
    -save_voltage_waveforms true \
    -write_movies false

set_pg_nets -net $POWER_NET -voltage $VOLTAGE
set_pg_nets -net $GROUND_NET -voltage 0.0

# Use CORE as the name of the VDD/VSS analysis domain.
set_rail_analysis_domain \
    -domain_name CORE \
    -power_nets $POWER_NET \
    -ground_nets $GROUND_NET \
    -threshold $IR_DROP_FRACTION

# ============================================================
# Set ideal supply source locations
# ============================================================
set_power_pads -reset

set_power_pads \
    -net $POWER_NET \
    -format xy \
    -file $VDD_PAD_FILE

set_power_pads \
    -net $GROUND_NET \
    -format xy \
    -file $VSS_PAD_FILE

# ============================================================
# Load transient currents and run dynamic rail analysis
# ============================================================
set_power_data -reset

# Use the dynamic_*.ptiavg files from the dynamic power run.
set_power_data \
    -format current [list \
        $POWER_DIR/dynamic_${POWER_NET}.ptiavg \
        $POWER_DIR/dynamic_${GROUND_NET}.ptiavg \
    ]

report_rail \
    -output_dir $RAIL_DIR \
    -type domain \
    CORE


exit