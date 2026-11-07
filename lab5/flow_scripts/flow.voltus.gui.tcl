# ============================================================
# Voltus 20.10 Common UI viewer for saved results
# ============================================================
# Run make voltus.gui from the project root.
# Set the design database and the matching results in the Makefile.

set DESIGN_DB $::env(VOLTUS_DESIGN_DB)
set POWER_DB $::env(VOLTUS_GUI_POWER_DB)
set RAIL_STATE $::env(VOLTUS_GUI_RAIL_STATE)
set PLOT $::env(VOLTUS_GUI_PLOT)

# report_rail creates the state directory under the results directory.
if {$RAIL_STATE eq ""} {
    puts "Static states: [glob -nocomplain -types d -directory $::env(VOLTUS_STATIC_RAIL_DIR) *]"
    puts "Dynamic states: [glob -nocomplain -types d -directory $::env(VOLTUS_DYNAMIC_RAIL_DIR) *]"
    error "Задайте VOLTUS_GUI_RAIL_STATE в Makefile."
}

# Load the design to display the physical layout.
read_db -physical_data $DESIGN_DB

gui_show

# Load the saved power and rail results.
read_power_rail_results \
    -power_db $POWER_DB \
    -rail_directory $RAIL_STATE

gui_set_power_rail_display -plot $PLOT


