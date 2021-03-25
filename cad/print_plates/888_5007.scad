include <../parameters.scad>
use <../src/888_5007.scad>

translate([mid_base_width/2-ALU_profile_width-ALU_profile_holder_wall_thickness, 0, ALU_profile_width/2+ALU_profile_holder_wall_thickness*2])
rotate([0, -90, 0])
888_5007(true);