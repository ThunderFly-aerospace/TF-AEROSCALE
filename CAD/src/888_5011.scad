include <../parameters.scad>

module 888_5011() {
    difference() {
        cylinder(d=8+0.2+4, h=26-608_bearing_thickness*2, $fn=50);
        
        translate([0, 0, -ALU_profile_holder_wall_thickness])
        cylinder(d=8+0.2, h=ALU_profile_width+ALU_profile_holder_wall_thickness*4, $fn=50);
    }
}

888_5011();
