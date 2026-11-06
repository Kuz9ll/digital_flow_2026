# ============================================================
# Voltus 20.10 Common UI: просмотр сохранённых результатов
# ============================================================
# Запускать в новом сеансе из run/voltus, как остальные этапы.
# Укажите ту же физическую базу, на которой выполнялся расчёт.

set DESIGN_DB ../design/postRoute.enc.dat
set POWER_DB ./reports/static_power/static_power.db

# Вписать фактический каталог состояния, созданный report_rail.
# Путь берётся из лога или содержимого reports/static_rail.
set RAIL_STATE ""

set PLOT ir

# Для просмотра динамики замените POWER_DB на
# ./reports/dynamic_power/dynamic_power.db
# и укажите состояние из ./reports/dynamic_rail.

if {$RAIL_STATE eq ""} {
    puts "Static states: [glob -nocomplain -types d ./reports/static_rail/*]"
    puts "Dynamic states: [glob -nocomplain -types d ./reports/dynamic_rail/*]"
    error "Заполните RAIL_STATE фактическим путём к каталогу состояния rail analysis."
}

# Загрузка проекта для отображения физической топологии.
read_db -physical_data $DESIGN_DB

gui_show

# Загрузка уже рассчитанных данных. Повторный расчёт не выполняется.
read_power_rail_results \
    -power_db $POWER_DB \
    -rail_directory $RAIL_STATE

gui_set_power_rail_display -plot $PLOT
