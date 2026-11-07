# ============================================================
# Voltus 20.10 Common UI: technology-only PGV
# ============================================================
# Run make voltus.pgv from the project root.
# The Makefile exports the VOLTUS_* settings.

# ============================================================
# Inputs
# ============================================================
set LEF_FILES [regexp -all -inline {\S+} $::env(VOLTUS_LEF_FILES)]

set QRC_TECH_FILE $::env(VOLTUS_QRC_TECH_FILE)
set VOLTAGE $::env(VOLTUS_VOLTAGE)
set POWER_PIN $::env(VOLTUS_POWER_PIN)
set GROUND_PIN $::env(VOLTUS_GROUND_PIN)

set PGV_DIR $::env(VOLTUS_PGV_DIR)
set REPORT_DIR $::env(VOLTUS_PGV_REPORT_DIR)

file mkdir $PGV_DIR $REPORT_DIR

# ============================================================
# Read the technology LEF before the cell LEFs
# ============================================================
read_physical -lef $LEF_FILES

# ============================================================
# Configure the technology-only library
# ============================================================
set PGV_OPTIONS {}
if {$::env(VOLTUS_FILLER_CELLS) ne ""} {
    lappend PGV_OPTIONS -filler_cells $::env(VOLTUS_FILLER_CELLS)
}
if {$::env(VOLTUS_DECAP_CELLS) ne ""} {
    lappend PGV_OPTIONS -decap_cells $::env(VOLTUS_DECAP_CELLS)
}
if {$::env(VOLTUS_LEF_LAYER_MAP) ne ""} {
    lappend PGV_OPTIONS -lef_layer_map $::env(VOLTUS_LEF_LAYER_MAP)
}

set_pg_library_mode \
    -cell_type techonly \
    -power_pins [list $POWER_PIN $VOLTAGE] \
    -ground_pins $GROUND_PIN \
    -extraction_tech_file $QRC_TECH_FILE \
    {*}$PGV_OPTIONS

# ============================================================
# Generate the PGV library
# ============================================================
write_pg_library -out_dir $PGV_DIR

# ============================================================
# Check the generated library
# ============================================================
check_pg_library \
    -summary \
    -report \
    -out_dir $REPORT_DIR \
    $PGV_DIR/techonly.cl
