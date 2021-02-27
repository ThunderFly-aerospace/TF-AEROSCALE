include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./lib/ALU_profile.scad>
use <./888_5005.scad>


module 888_5006_attachment_points() {
    // tower arms /////////////////////////////////////////////////////////
    translate([0, mid_base_width/2-ALU_profile_width, 35])
    rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
    translate([0, ALU_profile_width/2 ,0])
    ALU_profile(height=tower_height/cos(atan((200-ALU_profile_width)/tower_height)));
    
    translate([0, -mid_base_width/2+ALU_profile_width, 35])
    rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
    translate([0, -ALU_profile_width/2 ,0])
    ALU_profile(height=tower_height/cos(atan((200-ALU_profile_width)/tower_height)));
    
    // tower hinges
    translate([ALU_profile_width*.75, -mid_base_width/2+ALU_profile_width+ALU_profile_holder_wall_thickness*2, -ALU_profile_width-ALU_profile_holder_wall_thickness])
    rotate([0, -90 ,0])
    888_5005();
        
    translate([-ALU_profile_width*.75, mid_base_width/2-ALU_profile_width-ALU_profile_holder_wall_thickness*2, -ALU_profile_width-ALU_profile_holder_wall_thickness])
    rotate([0, -90, 180])
    888_5005();
}

module 888_5006(side=1) {
    difference() {
        hull() {
            // hinge cylinder
            translate([0, (-mid_base_width/2+ALU_profile_width/2+ALU_profile_holder_wall_thickness)*side+ALU_profile_width/2+ALU_profile_holder_wall_thickness*3 ,(608_bearing_outer_diameter+10)/2])
            rotate([90, 0, 0])
            cylinder(d=608_bearing_outer_diameter+10, h=ALU_profile_width+ALU_profile_holder_wall_thickness*6, $fn=100);
            
            
            translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, (-mid_base_width/2+ALU_profile_width)*side, 35])
            rotate([(-atan((mid_base_width/2-ALU_profile_width)/tower_height))*side, 0 ,0])
            union() {
                // tower arm cylinder
                translate([0, -ALU_profile_width/2*side ,0])
                rotate([0, 90, 0])
                cylinder(d=ALU_profile_width+ALU_profile_holder_wall_thickness*6, h=ALU_profile_width+ALU_profile_holder_wall_thickness*4, $fn=100);
                
                // tower profile holder arm
                translate([0, -ALU_profile_width*0.5-side*ALU_profile_width/2-ALU_profile_holder_wall_thickness ,0])
                cube([ALU_profile_width+ALU_profile_holder_wall_thickness*4, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5]);
            }
        }
        
        // profile arm cutter
        translate([-ALU_profile_width/2, (-mid_base_width/2+ALU_profile_width)*side, 35])
        rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height)*side, 0 ,0])
        union() {
            translate([0, -ALU_profile_width/2-side*ALU_profile_width/2 ,0])
            cube([ALU_profile_width, ALU_profile_width, tower_height/cos(atan((200-ALU_profile_width)/tower_height))]);
                
            translate([ALU_profile_width/2, 0, 12])
            rotate([side*90, 0, 0])
            union() {
                cylinder(d=M5_screw_diameter, h=ALU_profile_width*2, $fn=100);
                
                translate([0, 0, ALU_profile_width+ALU_profile_holder_wall_thickness])
                cylinder(d=M5_nut_diameter+5, h=ALU_profile_width, $fn=100);
            }
                
            translate([ALU_profile_width/2, side*ALU_profile_width*2, ALU_profile_width+6])
            rotate([side*90, 0, 0])
            union() {
                cylinder(d=M5_screw_diameter, h=ALU_profile_width*4, $fn=100);
                
                translate([0, 0, ALU_profile_width-ALU_profile_holder_wall_thickness])
                cylinder(d=M5_nut_diameter+5, h=ALU_profile_width, $fn=100);
                
                translate([0, 0, ALU_profile_width*3+ALU_profile_holder_wall_thickness])
                cylinder(d=M5_nut_diameter+5, h=ALU_profile_width, $fn=100);
            }
        }
        
        // hinge inside cutter
        translate([-ALU_profile_width, (-mid_base_width/2-M6_washer_thickness+ALU_profile_width/2+ALU_profile_holder_wall_thickness*1.5)*side-ALU_profile_width/2-ALU_profile_holder_wall_thickness*1.5 ,0])
        cube([ALU_profile_width*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2+M6_washer_thickness*2, 608_bearing_outer_diameter+10+1]);
        
        // hinge screw cutter
        translate([0, -mid_base_width/2*side+ALU_profile_width*2 ,(608_bearing_outer_diameter+10)/2])
        rotate([90, 0, 0])
        cylinder(d=M6_screw_diameter, h=ALU_profile_width*4, $fn=100);
        
        // hinge screw nut cutter
        translate([0, (-mid_base_width/2+ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*4)*side+ALU_profile_width*.5,(608_bearing_outer_diameter+10)/2])
        rotate([90, 0, 0])
        cylinder(d=M6_nut_diameter+5, h=ALU_profile_width, $fn=100);
    }   
}

888_5006(side=1);
888_5006(side=-1);
#888_5006_attachment_points();
