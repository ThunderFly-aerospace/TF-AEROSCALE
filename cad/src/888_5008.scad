include <../parameters.scad>
use <./lib/ALU_joint_B.scad>
use <./lib/rotor_joint.scad>

module 888_5008(print_plate=false) {
    translate([0, 0, -12/2])
    rotor_joint(1, 12);

    difference() {
        translate([0, 0, 35])
            cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2, 70], center=true);

        hull() {
            translate([0, 0, ALU_profile_width/2])
                rotate([90, 0, 0])
                    cylinder(d=M6_square_nut_diameter+5, h=ALU_profile_width+ALU_profile_holder_wall_thickness*4+0.1, center=true, $fn=50);

            translate([0, 0, ALU_profile_width/2+40])
                rotate([90, 0, 0])
                    cylinder(d=M6_square_nut_diameter+5, h=ALU_profile_width+ALU_profile_holder_wall_thickness*2+0.1, center=true, $fn=50);
        }
        translate([0, 0, 45])
            rotate([0, 90, 0])
                cylinder(d=M8_screw_diameter, h=ALU_profile_width+ALU_profile_holder_wall_thickness*2+0.1, $fn=20, center=true);
    }
    
    translate([0, 0, 70+(608_bearing_outer_diameter+10+5)/2])
    difference() {
        hull() {
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness, 0, 0])
            rotate([0, 90, 0])
            cylinder(d=608_bearing_outer_diameter+10+5, h=ALU_profile_width+ALU_profile_holder_wall_thickness*2, $fn=50);
            
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness, -ALU_profile_width/2-ALU_profile_holder_wall_thickness, -(608_bearing_outer_diameter+10+5)/2])
            cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_holder_wall_thickness]);
        }
        
        
        translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness-1, 0, 0])
        rotate([0, 90, 0])
        cylinder(d=M8_screw_diameter, h=ALU_profile_width+ALU_profile_holder_wall_thickness*2+2, $fn=20);
            
        translate([-26/2-M6_washer_thickness, -ALU_profile_width, -(608_bearing_outer_diameter+10+5+5)/2])
        cube([26+M6_washer_thickness*2, ALU_profile_width*2, 608_bearing_outer_diameter+10+5+5]);
    }
    
    if (!print_plate) {
        translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness, 0, 70+(608_bearing_outer_diameter+10+5)/2])
        rotate([0, 90, 0])
        #cylinder(h=35, d=8);
    }
}

888_5008(true);
