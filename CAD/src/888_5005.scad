include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./888_5010.scad>


module 888_5005(print_plate=false) {
    difference() {
        union() {
            translate([0, -ALU_profile_width-ALU_profile_holder_wall_thickness*2, 0])
            ALU_profile_holder_side(ALU_profile_width*1.5);
            
            translate([ALU_profile_width+ALU_profile_holder_wall_thickness+(608_bearing_outer_diameter+10)/2+.01, 0, ALU_profile_width*.75])
            rotate([90, 90, 0])
            888_5005_bearing_half(print_plate=print_plate);
        }
        
        
        translate([ALU_profile_width/2+ALU_profile_holder_wall_thickness, .1, ALU_profile_width*1.5-7])
        rotate([90, 0, 0])
        union() {
            cylinder(h=ALU_profile_width, d=M6_screw_diameter, $fn=20);
            translate([0, 0, 0])
            cylinder(h=ALU_profile_holder_wall_thickness, d=M6_head_diameter, $fn=20);
        }
            
        translate([ALU_profile_width/2+ALU_profile_holder_wall_thickness, .1, 7])
        rotate([90, 0, 0])
        union() {
            cylinder(h=ALU_profile_width, d=M6_screw_diameter, $fn=20);
            translate([0, 0, 0])
            cylinder(h=ALU_profile_holder_wall_thickness, d=M6_head_diameter, $fn=20);
        }
    }
}

module 888_5005_bearing_half(print_plate=false) {
    difference() {
        hull() {
            translate([-ALU_profile_width*.75, -(608_bearing_outer_diameter+10)/2, 0])
            cube([ALU_profile_width*1.5, 3, ALU_profile_width+ALU_profile_holder_wall_thickness*2]);
            cylinder(h=ALU_profile_width+ALU_profile_holder_wall_thickness*2, d=608_bearing_outer_diameter+10, $fn=100);
        }
        translate([0, 0, -5])
        cylinder(h=ALU_profile_width+ALU_profile_holder_wall_thickness*2+10, d=M6_screw_diameter+10, $fn=100);
        
        translate([0, 0, -.01])
        cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
        
        translate([0, 0, ALU_profile_width+.01])
        cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
        
        translate([ALU_profile_width*.75-7, ALU_profile_width-6, ALU_profile_width/2+ALU_profile_holder_wall_thickness*2])
        rotate([90, 0, 0])
        cylinder(h=ALU_profile_width*2, d=M6_nut_diameter+2, $fn=100);
        
        translate([-ALU_profile_width*.75+7, ALU_profile_width-6, ALU_profile_width/2+ALU_profile_holder_wall_thickness*2])
        rotate([90, 0, 0])
        cylinder(h=ALU_profile_width*2, d=M6_nut_diameter+2, $fn=100);
    }
    
    if(!print_plate) {
        translate([0, 0, 608_bearing_thickness])
        888_5010();
    }
}

888_5005(true);
