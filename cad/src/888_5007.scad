include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./lib/ALU_profile.scad>
use <./888_5002.scad>
use <./888_5005.scad>
use <./888_5011.scad>


module 888_5007_attachment_points() {
    // tower arms /////////////////////////////////////////////////////////
    translate([0, mid_base_width/2-ALU_profile_width, 0])
    rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
    translate([0, ALU_profile_width/2 ,0])
    ALU_profile(height=tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height)));
    
    translate([0, -mid_base_width/2+ALU_profile_width, 0])
    rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
    translate([0, -ALU_profile_width/2 ,0])
    ALU_profile(height=tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height)));
    
    // drag attachment point
    translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*3, 0, -ALU_profile_width+tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height))-75])
    rotate([90, 0, -90])
    888_5002();
}

module 888_5007(side=1) {
    union() {
        difference() {
            hull() {
                translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, (-mid_base_width/2+ALU_profile_width)*side, 0])
                rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
                translate([0, -ALU_profile_width*0.5-ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height))-ALU_profile_width*1.5-0.01])
                cube([ALU_profile_width+ALU_profile_holder_wall_thickness*4, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
                
                
                translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, mid_base_width/2-ALU_profile_width, 0])
                rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
                translate([0, -ALU_profile_width*0.5+ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height))-ALU_profile_width*1.5-0.01])
                cube([ALU_profile_width+ALU_profile_holder_wall_thickness*4, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
            }
            
            // profile arm cutter
            translate([-ALU_profile_width/2, (-mid_base_width/2+ALU_profile_width)*side, 0])
            rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height)*side, 0 ,0])
            translate([0, -ALU_profile_width/2-ALU_profile_width/2 ,0])
            cube([ALU_profile_width, ALU_profile_width, tower_height/cos(atan((200-ALU_profile_width)/tower_height))]);
            
            translate([-ALU_profile_width/2, mid_base_width/2-ALU_profile_width, 0])
            rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
            translate([0, -ALU_profile_width/2+ALU_profile_width/2 ,0])
            cube([ALU_profile_width, ALU_profile_width, tower_height/cos(atan((200-ALU_profile_width)/tower_height))]);
            
            // bottom profile screws holes
            hull() {
                translate([0, (-mid_base_width/2+ALU_profile_width)*side, 0])
                rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height)*side, 0 ,0])
                translate([0, ALU_profile_width+ALU_profile_holder_wall_thickness, tower_height/cos(atan((200-ALU_profile_width)/tower_height))-ALU_profile_width])
                rotate([90, 0, 0])
                cylinder(h=ALU_profile_width, d=M5_nut_diameter+5, $fn=50);
                
                translate([0, mid_base_width/2-ALU_profile_width, 0])
                rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
                translate([0, -ALU_profile_holder_wall_thickness, tower_height/cos(atan((200-ALU_profile_width)/tower_height))-ALU_profile_width])
                rotate([90, 0, 0])
                cylinder(h=ALU_profile_width, d=M5_nut_diameter+5, $fn=50);
            }
            
            // profile screws main holes
            translate([0, (-mid_base_width/2+ALU_profile_width)*side, 0])
            rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height)*side, 0 ,0])
            translate([0, ALU_profile_width*2, tower_height/cos(atan((200-ALU_profile_width)/tower_height))-ALU_profile_width])
            rotate([90, 0, 0])
            cylinder(h=ALU_profile_width*4, d=M5_screw_diameter, $fn=50);
            
            translate([0, mid_base_width/2-ALU_profile_width, 0])
            rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
            translate([0, ALU_profile_width*2, tower_height/cos(atan((200-ALU_profile_width)/tower_height))-ALU_profile_width])
            rotate([90, 0, 0])
            cylinder(h=ALU_profile_width*4, d=M5_screw_diameter, $fn=50);
            
            translate([0, (-mid_base_width/2+ALU_profile_width)*side, 0])
            rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height)*side, 0 ,0])
            translate([0, -ALU_profile_width/2, tower_height/cos(atan((200-ALU_profile_width)/tower_height))-12])
            rotate([90, 0, 0])
            cylinder(h=ALU_profile_width, d=M5_screw_diameter, $fn=50);
            
            translate([0, mid_base_width/2-ALU_profile_width, 0])
            rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
            translate([0, ALU_profile_width*1.5, tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height))-12])
            rotate([90, 0, 0])
            cylinder(h=ALU_profile_width, d=M5_screw_diameter, $fn=50);
            
            // drag tenzometer attachment point
            translate([0, 0, -ALU_profile_width+tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height))-75+strain_gauge_screw_distance/2])
            rotate([90, 0, -90])
            union () {
                cylinder(h=ALU_profile_width, d=M4_screw_diameter, $fn=50);
                cylinder(h=ALU_profile_width/3, d=M4_nut_diameter, $fn=6);
            }
            
            translate([0, 0, -ALU_profile_width+tower_height/cos(atan((mid_base_width/2-ALU_profile_width)/tower_height))-75-strain_gauge_screw_distance/2])
            rotate([90, 0, -90])
            union () {
                cylinder(h=ALU_profile_width, d=M4_screw_diameter, $fn=50);
                cylinder(h=ALU_profile_width/3, d=M4_nut_diameter, $fn=6);
            }
            
            // angle adjustment screws holes
            adjustment_screw_holes_width = 34;
            adjustment_screw_holes_offset = ALU_profile_width/2-ALU_profile_holder_wall_thickness;
            
            translate([-adjustment_screw_holes_offset, adjustment_screw_holes_width/2, tower_height+18])
            union() {
                translate([0, 0, -ALU_profile_width/2])
                cylinder(h=ALU_profile_width, d=M5_screw_diameter, $fn=50);
                
                translate([-ALU_profile_holder_wall_thickness*6, -M5_nut_pocket/2, 0])
                cube([ALU_profile_holder_wall_thickness*6, M5_nut_pocket, M5_nut_height]);
                
                cylinder(h=M5_nut_height, d=M5_nut_diameter, $fn=6);
            }
            
            translate([-adjustment_screw_holes_offset, -adjustment_screw_holes_width/2, tower_height+18])
            union() {
                translate([0, 0, -ALU_profile_width/2])
                cylinder(h=ALU_profile_width, d=M5_screw_diameter, $fn=50);
                
                translate([-ALU_profile_holder_wall_thickness*6, -M5_nut_pocket/2, 0])
                cube([ALU_profile_holder_wall_thickness*6, M5_nut_pocket, M5_nut_height]);
                
                cylinder(h=M5_nut_height, d=M5_nut_diameter, $fn=6);
            }
            
            // angle adjustment hole for screw
            translate([0, 0, tower_height+20])
            rotate([0, 90, 0])
            hull() {
                translate([0, 0, -ALU_profile_width*2])
                cylinder(h=ALU_profile_width*4, d=M6_nut_diameter+5, $fn=50);
                
                translate([-ALU_profile_width, 0, -ALU_profile_width*2])
                cylinder(h=ALU_profile_width*4, d=M6_nut_diameter+5, $fn=50);
            }
        }
        
        translate([(608_bearing_outer_diameter+10+ALU_profile_width)/2+ALU_profile_holder_wall_thickness+15, ALU_profile_width/2, tower_height-12])
        rotate([0, 90, -90])
        union() {
            difference() {
                hull() {
                    translate([-ALU_profile_width*.75, -(608_bearing_outer_diameter+10)/2-15, 0])
                    cube([ALU_profile_width*1.5, 3, ALU_profile_width]);
                    cylinder(h=ALU_profile_width, d=608_bearing_outer_diameter+10, $fn=100);
                }
                translate([0, 0, -5])
                cylinder(h=ALU_profile_width+10, d=M6_screw_diameter+10, $fn=100);
                
                translate([0, 0, -.01])
                cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
                
                translate([0, 0, ALU_profile_width-608_bearing_thickness+.01])
                cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
            }
        
            translate([0, 0, 608_bearing_thickness])
            888_5011();
        }
    }   
}

888_5007();
#888_5007_attachment_points();
