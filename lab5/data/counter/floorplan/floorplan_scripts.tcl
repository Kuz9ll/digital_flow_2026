create_floorplan -site CoreSite -die_size 200.16 199.92 20 20 20 20
add_rings -nets {VDD VSS} -type core_rings -follow core -layer {top TopMetal1 bottom TopMetal1 left TopMetal2 right TopMetal2} -width {top 5 bottom 5 left 5 right 5} -spacing {top 1.64 bottom 1.64 left 2 right 2} -offset {top 5 bottom 5 left 5 right 5} -center 0 -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { Metal1(1) TopMetal2(7) } -block_pin_target nearest_target -pad_pin_port_connect {all_port one_geom} -pad_pin_target nearest_target -core_pin_target first_after_row_end -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { Metal1(1) TopMetal2(7) } -nets { VDD VSS } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { Metal1(1) TopMetal2(7) }

create_place_blockage -area 131.60500 18.30000 180.20100 102.57400 -type hard

