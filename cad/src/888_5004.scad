include <../parameters.scad>
use <./lib/ALU_profile_holder_top.scad>


height = ALU_profile_width+608_bearing_outer_diameter-2+ALU_profile_holder_wall_thickness*2+5;


module 888_5004_hinge_attachment() {
    translate([-(50)/2, height, ALU_profile_width/2])
    rotate([0, 90, 0])
    cylinder(h=50, d=8);
    
    
    translate([-(ALU_profile_width+ALU_profile_holder_wall_thickness*2)/2, height-10, ALU_profile_width/2-10])
    cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, 20, 20]);
}

module 888_5004() {

    translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness, -55-ALU_profile_holder_wall_thickness*2, 0])
        ALU_profile_holder_top(50);

    difference() {
        hull() {
            translate([-50/2, -5, 0])
            cube([50, height+5, ALU_profile_width]);

            translate([ALU_profile_width/-2-ALU_profile_holder_wall_thickness, -ALU_profile_holder_wall_thickness*2-5+.01, 0])
            cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_holder_wall_thickness*2, ALU_profile_width]);

            translate([(3+M6_nut_height)/2, height, ALU_profile_width/2])
            rotate([0, 90, 0])
            cylinder(d=608_bearing_outer_diameter, h=50+3+M6_nut_height, center=true, $fn=40);
        }

        translate([-(ALU_profile_width+ALU_profile_holder_wall_thickness*2+4)/2, 0, -0.1])
        cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2+4, height+608_bearing_outer_diameter/2, ALU_profile_width+0.2]);

        translate([-50/2-0.1, height, ALU_profile_width/2])
        rotate([0, 90, 0])
        union() {
            cylinder(d=M8_screw_diameter, h=50, $fn=20);
            cylinder(d=M6_screw_diameter, h=70, $fn=20);
            
            translate([0, 0, 50+3])
            cylinder(d=M6_nut_diameter, h=70, $fn=6);
        }
    }
}

888_5004();

#888_5004_hinge_attachment();
