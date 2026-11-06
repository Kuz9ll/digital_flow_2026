# ============================================================
# Voltus 20.10 Common UI: dynamic vectorless power и IR drop
# ============================================================
# Пример для одного постоянно включённого домена VDD/VSS.
# Запускать в новом сеансе из той же рабочей папки, что и PGV flow.
# Пути, view, corner, напряжение, температура и активность — примеры.
# Заменить их значениями своего проекта. MMMC/Liberty/SDC берутся из базы.
# VCD не используется: переключения строятся по активности и таймингам.
# С techonly ёмкости ячеек не характеризованы: модель динамики упрощённая.

# ============================================================
# Исходные данные
# ============================================================
set DESIGN_DB ../design/postRoute.enc.dat
set SPEF_FILE ../design/postRoute.spef.gz

set ANALYSIS_VIEW AV_wc_on
set RC_CORNER RC_wc_125

set VOLTAGE 0.9
set TEMPERATURE 125

set POWER_NET VDD
set GROUND_NET VSS

set PGV_FILE ./outputs/pgv/tech_pgv/techonly.cl
set VDD_PAD_FILE ../design/VDD.pp
set VSS_PAD_FILE ../design/VSS.pp

set INPUT_ACTIVITY 0.2
set ACTIVITY_PERIOD 8.0
set CLOCK_GATE_RATIO 0.5
set TIME_RESOLUTION 50ps

set POWER_DIR ./reports/dynamic_power
set RAIL_DIR ./reports/dynamic_rail

file mkdir $POWER_DIR $RAIL_DIR

# ============================================================
# Загрузка проекта и сигнальных паразитных параметров
# ============================================================
read_db -physical_data $DESIGN_DB

read_spef \
    -rc_corner $RC_CORNER \
    -decoupled \
    $SPEF_FILE

set_power_rail $POWER_NET -power -voltage $VOLTAGE -force
set_power_rail $GROUND_NET -ground

# ============================================================
# Настройка динамического расчёта мощности
# ============================================================
set_db power_view $ANALYSIS_VIEW
set_db power_method dynamic_vectorless

# Дополнительно сохранять усреднённые результаты и power DB.
# Динамический режим при этом остаётся включённым.
set_db power_disable_static false
set_db power_write_static_currents true
set_db power_write_db true
set_db power_db_name dynamic_power.db
set_db power_grid_libraries [list $PGV_FILE]

set_power_output_dir $POWER_DIR

# ============================================================
# Активность переключений
# ============================================================
set_default_switching_activity -reset
set_switching_activity -reset

# ACTIVITY_PERIOD — в единицах времени Liberty.
# Эта настройка нормирует активность и не изменяет clocks в SDC.
set_default_switching_activity \
    -input_activity $INPUT_ACTIVITY \
    -period $ACTIVITY_PERIOD \
    -clock_gates_output_ratio $CLOCK_GATE_RATIO

# При наличии reset задайте его неактивное состояние.
# Пример только для входа rst с активным уровнем 1:
# set_switching_activity -input_port rst -activity 0.0 -duty 0.0

propagate_activity

# ============================================================
# Временное разрешение и расчёт токов во времени
# ============================================================
set_dynamic_power_simulation -reset
set_dynamic_power_simulation -resolution $TIME_RESOLUTION

# Длительность vectorless-моделирования выбирается инструментом.
# Проверьте clocks и фактический интервал расчёта в логе.
report_power -out_file dynamic.rpt

# ============================================================
# Настройка динамического анализа сети питания
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

# CORE — имя создаваемого домена анализа VDD/VSS.
set_rail_analysis_domain \
    -domain_name CORE \
    -power_nets $POWER_NET \
    -ground_nets $GROUND_NET

# ============================================================
# Точки подключения идеальных источников питания
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
# Загрузка динамических токов и запуск анализа
# ============================================================
set_power_data -reset

# Здесь нужны dynamic_*.ptiavg, а не static_*.ptiavg.
set_power_data \
    -format current [list \
        $POWER_DIR/dynamic_${POWER_NET}.ptiavg \
        $POWER_DIR/dynamic_${GROUND_NET}.ptiavg \
    ]

report_rail \
    -output_dir $RAIL_DIR \
    -type domain \
    CORE
