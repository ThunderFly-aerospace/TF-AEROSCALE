include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>


module 888_5004() {
    union() {
        translate([0, -ALU_profile_width-ALU_profile_holder_wall_thickness*2, 0])
        ALU_profile_holder_side(ALU_profile_width);
        
        
        translate([0, (M6_screw_diameter+10)/2-ALU_profile_holder_wall_thickness, ALU_profile_width/2])
        rotate([0, 90, 0])
        difference() {
            hull() {
                translate([-ALU_profile_width/2, -(M6_screw_diameter+10)/2+ALU_profile_holder_wall_thickness, 0])
                cube([ALU_profile_width, 1, ALU_profile_width+ALU_profile_holder_wall_thickness*2]);
                cylinder(h=ALU_profile_width+ALU_profile_holder_wall_thickness*2, d=M6_screw_diameter+10, $fn=100);
            }
            translate([0, 0, -5])
            cylinder(h=ALU_profile_width+ALU_profile_holder_wall_thickness*2+10, d=M6_screw_diameter, $fn=100);
        }
    }
}

888_5004();
