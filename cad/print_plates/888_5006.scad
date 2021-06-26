//@set_slicing_config(../slicing/default.ini)

include <../parameters.scad>
use <../src/888_5006.scad>

translate([0, mid_base_width/2+ALU_profile_holder_wall_thickness*2, (ALU_profile_width+ALU_profile_holder_wall_thickness*2)/2])
rotate([0, 90, 0])
888_5006(side=1);