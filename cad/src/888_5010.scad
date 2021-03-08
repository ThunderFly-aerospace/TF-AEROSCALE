include <../parameters.scad>

module 888_5010() {
    difference() {
        cylinder(d=M6_screw_diameter+4, h=ALU_profile_width+ALU_profile_holder_wall_thickness*2-608_bearing_thickness*2, $fn=50);
        
        translate([0, 0, -ALU_profile_holder_wall_thickness])
        cylinder(d=M6_screw_diameter, h=ALU_profile_width+ALU_profile_holder_wall_thickness*4, $fn=50);
    }
}

888_5010();
