include <../parameters.scad>

module 888_5012() {
    difference() {
        cylinder(d=8+0.2+4, h=20, $fn=50);
        
        translate([0, 0, -ALU_profile_holder_wall_thickness])
        cylinder(d=8+0.2, h=26, $fn=50);
    }
}

888_5012();
