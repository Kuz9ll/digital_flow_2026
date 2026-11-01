

delete_filler -prefix  FILLER

set_db eco_honor_dont_touch false
set_db eco_honor_dont_use false
set_db eco_honor_fixed_status false
set_db eco_honor_fixed_wires false
set_db eco_inherit_net_attribute false
set_db eco_check_logical_equivalence false
set_db eco_refine_place false
set_db eco_spread_inverter false
set_db eco_update_timing false
set_db eco_prefix ECO


# optional

	# add
	eco_add_repeater -cells ... -pins ...

	# delete
	eco_delete_repeater -insts ...

	# change
	eco_update_cell -insts ... -cells ...



report_timing -from ... -to ... -late
report_timing -from ... -to ... -early

place_detail -eco true
check_place
route_eco


add_fillers -prefix  FILLER

write_db ../../out/${TASK_NAME}_fix_hold.innovus.enc


