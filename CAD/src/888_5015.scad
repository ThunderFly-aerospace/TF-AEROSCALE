include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./lib/ALU_profile.scad>
use <./lib/rotor_joint.scad>
use <./888_5002.scad>
use <./888_5005.scad>
use <./888_5011.scad>


module 888_5015_attachment_points() {
    // tower arms /////////////////////////////////////////////////////////
    translate([0, mid_base_width/2-ALU_profile_width, 0])
    rotate([tower_angle, 0 ,0])
    translate([0, ALU_profile_width/2 ,0])
    ALU_profile(height=tower_arm_length);
    
    translate([0, -mid_base_width/2+ALU_profile_width, 0])
    rotate([-tower_angle, 0 ,0])
    translate([0, -ALU_profile_width/2 ,0])
    ALU_profile(height=tower_arm_length);
}

module 888_5015(print_plate=false) {
    union() {
        difference() {
            union () {
                hull() {
                    translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, -mid_base_width/2+ALU_profile_width, 0])
                    rotate([-tower_angle, 0 ,0])
                    translate([0, -ALU_profile_width*0.5-ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_arm_length-ALU_profile_width*1.5-0.01])
                    cube([ALU_profile_holder_wall_thickness*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
                    
                    
                    translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, mid_base_width/2-ALU_profile_width, 0])
                    rotate([tower_angle, 0 ,0])
                    translate([0, -ALU_profile_width*0.5+ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_arm_length-ALU_profile_width*1.5-0.01])
                    cube([ALU_profile_holder_wall_thickness*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
                }
                
                
                intersection() {       
                    hull() {
                        translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*6, -mid_base_width/2+ALU_profile_width, 0])
                        rotate([-tower_angle, 0 ,0])
                        translate([0, -ALU_profile_width*0.5-ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_arm_length-ALU_profile_width*1.5-0.01])
                        cube([ALU_profile_holder_wall_thickness*4, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
                        
                        
                        translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*6, mid_base_width/2-ALU_profile_width, 0])
                        rotate([tower_angle, 0 ,0])
                        translate([0, -ALU_profile_width*0.5+ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_arm_length-ALU_profile_width*1.5-0.01])
                        cube([ALU_profile_holder_wall_thickness*4, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
                    }
                    
                    union() {
                        for(i=[-100:24:100]) {
                            translate([100-30+abs((i-8)/10), i-3, tower_height])
                            rotate([90, 0, 0])
                            cylinder(h=10, d=200, $fn=200);
                        }
                    }
                }
            }
            
            // bottom screws
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*3, 20, tower_height-22])
            rotate([0, 90, 0])
            union() {
                cylinder(h = ALU_profile_holder_wall_thickness*4, d=M6_screw_diameter, $fn=50);
                
                translate([0, 0, -ALU_profile_width+5])
                cylinder(h = ALU_profile_width, d=15, $fn=50);
            }
            
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*3, -20, tower_height-22])
            rotate([0, 90, 0])
            union() {
                cylinder(h = ALU_profile_holder_wall_thickness*4, d=M6_screw_diameter, $fn=50);
                
                translate([0, 0, -ALU_profile_width+5])
                cylinder(h = ALU_profile_width, d=15, $fn=50);
            }
            
            
            // profile screws
            translate([0, ALU_profile_width-ALU_profile_holder_wall_thickness, tower_height])
            rotate([tower_angle, 0, 0])
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*3, ALU_profile_holder_wall_thickness, -20])
            rotate([0, 90, 0])
            union() {
                cylinder(h = ALU_profile_holder_wall_thickness*4, d=M6_screw_diameter, $fn=50);
                
                translate([0, 0, -ALU_profile_width+5])
                cylinder(h = ALU_profile_width, d=15, $fn=50);
            }
            
            translate([0, -ALU_profile_width+ALU_profile_holder_wall_thickness, tower_height])
            rotate([-tower_angle, 0, 0])
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*3, -ALU_profile_holder_wall_thickness, -20])
            rotate([0, 90, 0])
            union() {
                cylinder(h = ALU_profile_holder_wall_thickness*4, d=M6_screw_diameter, $fn=50);
                
                translate([0, 0, -ALU_profile_width+5])
                cylinder(h = ALU_profile_width, d=15, $fn=50);
            }
            
            
            // drag tenzometer attachment point
            translate([0, 0, tower_height-tower_drag_z_offset+strain_gauge_screw_distance/2])
            rotate([90, 0, -90])
            cylinder(h=ALU_profile_width, d=M4_screw_diameter, $fn=50);
            
            translate([0, 0, tower_height-tower_drag_z_offset-strain_gauge_screw_distance/2])
            rotate([90, 0, -90])
            cylinder(h=ALU_profile_width, d=M4_screw_diameter, $fn=50);
            
            
            adjustment_screw_holes_width = 31;
            
            // angle adjustment hole for screw
            translate([0, 0, tower_height+20])
            rotate([0, 90, 0])
            hull() {
                translate([0, 0, -ALU_profile_width*2])
                cylinder(h=ALU_profile_width*4, d=M6_nut_diameter+5, $fn=50);
                
                translate([-ALU_profile_width, 0, -ALU_profile_width*2])
                cylinder(h=ALU_profile_width*4, d=M6_nut_diameter+5, $fn=50);
            }
            
            // angle adjustment screws holes for NEMA 17
            translate([-ALU_profile_width, adjustment_screw_holes_width/2, tower_height+20.25])
            rotate([0, 90, 0])
            cylinder(h=ALU_profile_width*2, d=M3_screw_diameter, $fn=50);
            
            translate([-ALU_profile_width, -adjustment_screw_holes_width/2, tower_height+20.25])
            rotate([0, 90, 0])
            cylinder(h=ALU_profile_width*2, d=M3_screw_diameter, $fn=50);
            
            // space for NEMA 17
            translate([-ALU_profile_width-ALU_profile_holder_wall_thickness*7, -44/2, tower_height+20.25-7])
            cube([ALU_profile_width, 44, 44]);
        }
    }
}

888_5015();
#888_5015_attachment_points();
