# Минимальные временные ограничения для лабораторной работы №2.
# Единица времени в проекте: нс.

# Тактовый сигнал: период 10 нс, частота 100 МГц.
create_clock -name clk -period 10.0 [get_ports clk]

# Все входы блока, кроме тактового.
set input_ports [remove_from_collection [all_inputs] [get_ports clk]]

# Задержки внешней логики перед входами блока.
set_input_delay -clock [get_clocks clk] -max 2.0 $input_ports
set_input_delay -clock [get_clocks clk] -min 0.0 $input_ports

# Временные требования внешней логики после выходов блока.
set_output_delay -clock [get_clocks clk] -max 2.0 [all_outputs]
set_output_delay -clock [get_clocks clk] -min 0.0 [all_outputs]