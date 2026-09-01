select_routes -net VSS
select_routes -net VDD
delete_selected_from_floorplan

convert_legacy_to_common_ui ./old.tcl  ./new.tcl



