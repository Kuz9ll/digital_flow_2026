# ============================================================
# Voltus 20.10 Common UI: technology-only PGV
# ============================================================
# Запускать из рабочей папки, относительно которой заданы пути.
# Пути, имена ячеек и 0.9 В ниже — пример из учебного комплекта.
# Перед запуском заменить их значениями своего PDK.

# ============================================================
# Исходные данные
# ============================================================
set LEF_FILES [list \
    ../data/lef/gsclib090_tech.lef \
    ../data/lef/gsclib090_macro.lef \
    ../data/lef/decap.lef \
]

set QRC_TECH_FILE ../data/qrc/gpdk090_9l.tch
set LEF_LAYER_MAP ../data/voltus/lefdef.layermap
set VOLTAGE 0.9

set PGV_DIR ./outputs/pgv/tech_pgv
set REPORT_DIR ./reports/pgv

file mkdir $PGV_DIR $REPORT_DIR

# ============================================================
# Чтение LEF: технологический файл первым
# ============================================================
read_physical -lef $LEF_FILES

# ============================================================
# Настройка technology-only библиотеки
# ============================================================
set_pg_library_mode \
    -cell_type techonly \
    -power_pins [list VDD $VOLTAGE] \
    -ground_pins VSS \
    -filler_cells {FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64} \
    -decap_cells {DECAP1 DECAP2 DECAP4 DECAP8 DECAP16 DECAP32 DECAP64} \
    -lef_layer_map $LEF_LAYER_MAP \
    -extraction_tech_file $QRC_TECH_FILE

# ============================================================
# Генерация PGV
# ============================================================
write_pg_library -out_dir $PGV_DIR

# ============================================================
# Проверка сгенерированной библиотеки
# ============================================================
check_pg_library \
    -summary \
    -report \
    -out_dir $REPORT_DIR \
    $PGV_DIR/techonly.cl
