include <../parameters.scad>
use <888_1002.scad>

module 888_1001() {
    difference() {
        union() {
            hull() {
                cube([ALU_profile_width, 6, ALU_profile_width]);
                
                translate([calibration_arm_x_offset, 0, calibration_arm_y_offset])
                rotate([-90, 0, 0])
                cylinder(d=M6_nut_diameter+5*2, h=3, $fn=100);
            }
            
            hull() {
                translate([0, 0, ALU_profile_width-3])
                cube([ALU_profile_width, 3, 3]);
                
                translate([calibration_arm_x_offset, 0, calibration_arm_y_offset])
                rotate([-90, 0, 0])
                cylinder(d=M6_nut_diameter+5*2, h=14.5+M6_nut_height+3, $fn=100);
            }
            
            translate([calibration_arm_x_offset, 0, calibration_arm_y_offset])
            rotate([-90, 0, 0])
            cylinder(d=M6_nut_diameter+5*2, h=14.5+M6_nut_height+3, $fn=100);
        }
    
        // pulley hole
        translate([calibration_arm_x_offset, -.1, calibration_arm_y_offset])
        rotate([-90, 0, 0])
        union() {
            cylinder(d=M8_screw_diameter, h=15, $fn=100);
            cylinder(d=M6_screw_diameter, h=30, $fn=20);
            
            translate([0, 0, 15+3])
            cylinder(d=M6_nut_diameter, h=70, $fn=6);
        }
        
        
        // ALU profile screws
        translate([ALU_profile_width/2, -1, 7.5])
        rotate([-90, 0, 0])
        cylinder(d=M6_screw_diameter, h=6+2, $fn=100);
        
        translate([ALU_profile_width/2, -1, ALU_profile_width-7.5])
        rotate([-90, 0, 0])
        cylinder(d=M6_screw_diameter, h=6+2, $fn=100);
    }
}

888_1001();

translate([calibration_arm_x_offset, -.5, calibration_arm_y_offset])
rotate([90, 0, 0])
#888_1002();

translate([calibration_arm_x_offset, -20.5, calibration_arm_y_offset])
rotate([-90, 0, 0])
#cylinder(d=M8_screw_diameter, h=35, $fn=100);