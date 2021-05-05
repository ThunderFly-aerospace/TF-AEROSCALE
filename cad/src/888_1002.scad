include <../parameters.scad>
use <888_1003.scad>

module 888_1002(print_plate=false) {
    difference() {
        cylinder(d=50, h=20, $fn=100);
        
        translate([0, 0, -5])
        cylinder(h=ALU_profile_width+ALU_profile_holder_wall_thickness*2+10, d=M6_screw_diameter+10, $fn=100);
        
        translate([0, 0, -.01])
        cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
        
        translate([0, 0, 20-608_bearing_thickness+.01])
        cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
        
        translate([0, 0, 10])
        rotate_extrude(convexity = 1, $fn=100)
        translate([25, 0, 0])
        circle(d=10, $fn = 100);
    }
    
    if(!print_plate) {
        translate([0, 0, 608_bearing_thickness])
        888_1003();
    }
}

888_1002();