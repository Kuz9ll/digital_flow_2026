
create_clock -name "clk_100m" -period 10 -waveform {0 5} [get_ports "CK"]

set_input_transition 0.2 [all_inputs]
set_clock_transition 0.15 [all_clocks]

set_clock_uncertainty 0.2 [get_clocks "clk_100m"]

set_input_delay -min 2.3 [all_inputs] -clock [get_clocks "clk_100m"]
set_input_delay -max 2.7 [all_inputs] -clock [get_clocks "clk_100m"]

set_output_delay -min 2.3 [all_outputs] -clock [get_clocks "clk_100m"]
set_output_delay -max 2.7 [all_outputs] -clock [get_clocks "clk_100m"]
