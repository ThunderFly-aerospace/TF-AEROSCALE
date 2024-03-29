include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./lib/ALU_profile.scad>
use <./888_5002.scad>
use <./888_5005.scad>
use <./888_5011.scad>
use <./888_5015.scad>


module 888_5007_attachment_points() {
    // tower arms /////////////////////////////////////////////////////////
    translate([0, mid_base_width/2-ALU_profile_width, 0])
    rotate([tower_angle, 0 ,0])
    translate([0, ALU_profile_width/2 ,0])
    ALU_profile(height=tower_arm_length);

    translate([0, -mid_base_width/2+ALU_profile_width, 0])
    rotate([-tower_angle, 0 ,0])
    translate([0, -ALU_profile_width/2 ,0])
    ALU_profile(height=tower_arm_length);

    // drag attachment point
    translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2+strain_gauge_width+6, 0, tower_height-strain_gauge_length/2-tower_drag_z_offset/2+2])
    rotate([0, -90, 0])
    translate([-strain_gauge_length/2, -strain_gauge_width/2, 0])
    color([0, 0, 1])
    cube([strain_gauge_length, strain_gauge_width, strain_gauge_width]);
}

module 888_5007(print_plate=false) {
    difference() {
        union() {
            difference() {
                hull() {
                    translate([-ALU_profile_width/2+.01, -mid_base_width/2+ALU_profile_width, 0])
                    rotate([-tower_angle, 0 ,0])
                    translate([0, -ALU_profile_width*0.5-ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_arm_length-ALU_profile_width*1.5-0.01])
                    cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);


                    translate([-ALU_profile_width/2+.01, mid_base_width/2-ALU_profile_width, 0])
                    rotate([tower_angle, 0 ,0])
                    translate([0, -ALU_profile_width*0.5+ALU_profile_width/2-ALU_profile_holder_wall_thickness ,tower_arm_length-ALU_profile_width*1.5-0.01])
                    cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width*1.5+ALU_profile_holder_wall_thickness*3]);
                }

                // profile arm cutter
                translate([-ALU_profile_width/2, -mid_base_width/2+ALU_profile_width, 0])
                rotate([-tower_angle, 0 ,0])
                translate([0, -ALU_profile_width/2-ALU_profile_width/2 ,0])
                cube([ALU_profile_width, ALU_profile_width, tower_arm_length]);

                translate([-ALU_profile_width/2, mid_base_width/2-ALU_profile_width, 0])
                rotate([tower_angle, 0 ,0])
                translate([0, -ALU_profile_width/2+ALU_profile_width/2 ,0])
                cube([ALU_profile_width, ALU_profile_width, tower_arm_length]);

                // bottom profile screws holes
                hull() {
                    translate([0, -mid_base_width/2+ALU_profile_width, 0])
                    rotate([-tower_angle, 0 ,0])
                    translate([0, ALU_profile_width+ALU_profile_holder_wall_thickness, tower_arm_length-ALU_profile_width])
                    rotate([90, 0, 0])
                    cylinder(h=ALU_profile_width, d=M6_nut_diameter+5, $fn=50);

                    translate([0, mid_base_width/2-ALU_profile_width, 0])
                    rotate([tower_angle, 0 ,0])
                    translate([0, -ALU_profile_holder_wall_thickness, tower_arm_length-ALU_profile_width])
                    rotate([90, 0, 0])
                    cylinder(h=ALU_profile_width, d=M6_nut_diameter+5, $fn=50);
                }

                // profile screws main holes
                translate([0, -mid_base_width/2+ALU_profile_width, 0])
                rotate([-tower_angle, 0 ,0])
                translate([0, ALU_profile_width*2, tower_arm_length-ALU_profile_width])
                rotate([90, 0, 0])
                cylinder(h=ALU_profile_width*4, d=M6_screw_diameter, $fn=50);

                translate([0, mid_base_width/2-ALU_profile_width, 0])
                rotate([tower_angle, 0 ,0])
                translate([0, ALU_profile_width*2, tower_arm_length-ALU_profile_width])
                rotate([90, 0, 0])
                cylinder(h=ALU_profile_width*4, d=M6_screw_diameter, $fn=50);

                translate([0, -mid_base_width/2+ALU_profile_width, 0])
                rotate([-tower_angle, 0 ,0])
                translate([0, -ALU_profile_width/2, tower_arm_length-12])
                rotate([90, 0, 0])
                cylinder(h=ALU_profile_width, d=M6_screw_diameter, $fn=50);

                translate([0, mid_base_width/2-ALU_profile_width, 0])
                rotate([tower_angle, 0 ,0])
                translate([0, ALU_profile_width*1.5, tower_arm_length-12])
                rotate([90, 0, 0])
                cylinder(h=ALU_profile_width, d=M6_screw_diameter, $fn=50);

                // drag tenzometer attachment point
                translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2+strain_gauge_width+6+2, -1, tower_height-strain_gauge_length/2-tower_drag_z_offset/2+5])
                rotate([0, -90, 0])
                translate([-strain_gauge_length/2, -strain_gauge_width/2-2, 0])
                cube([strain_gauge_length, strain_gauge_width+6, strain_gauge_width+2]);

                // 888_5015 attachment points
                translate([0, 20, tower_height-22])
                rotate([90, 0, -90])
                union() {
                    cylinder(h=ALU_profile_width, d=M6_screw_diameter, $fn=50);

                    translate([0, 0, 2])
                    cylinder(h=10, d=M6_nut_diameter, $fn=6);
                }

                translate([0, -20, tower_height-22])
                rotate([90, 0, -90])
                union() {
                    cylinder(h=ALU_profile_width, d=M6_screw_diameter, $fn=50);

                    translate([0, 0, 2])
                    cylinder(h=10, d=M6_nut_diameter, $fn=6);
                }




                adjustment_screw_holes_width = 31;
                adjustment_screw_holes_offset = ALU_profile_width/2-ALU_profile_holder_wall_thickness*2;

                // angle adjustment screws holes for NEMA 17
                translate([0, adjustment_screw_holes_width/2, tower_height+20.25])
                rotate([0, 90, 0])
                union() {
                    translate([0, 0, -ALU_profile_width/2])
                    cylinder(h=ALU_profile_width*2, d=M3_screw_diameter, $fn=50);

                    cylinder(h=ALU_profile_width*2, d=M3_nut_diameter, $fn=50);
                }

                translate([0, -adjustment_screw_holes_width/2, tower_height+20.25])
                rotate([0, 90, 0])
                union() {
                    translate([0, 0, -ALU_profile_width/2])
                    cylinder(h=ALU_profile_width*2, d=M3_screw_diameter, $fn=50);

                    cylinder(h=ALU_profile_width*2, d=M3_nut_diameter, $fn=50);
                }

                // angle adjustment screws holes

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

            // main rotor attachment point
            translate([(608_bearing_outer_diameter+10+ALU_profile_width)/2+ALU_profile_holder_wall_thickness+15, (26+20)/2, tower_height-12])
            rotate([0, 90, -90])
            union() {
                difference() {
                    hull() {
                        translate([-(608_bearing_outer_diameter+10+11)/2-1.5, -(608_bearing_outer_diameter+10)/2-15, 0])
                        cube([608_bearing_outer_diameter+10+11, 3, 26+20]);
                        cylinder(h=26+20, d=608_bearing_outer_diameter+10, $fn=100);
                    }

                    translate([-25, -18.1, 0])
                    union() {
                        rotate([0, 90, 0])
                        cylinder(h=50, d=20, $fn=30);

                        translate([0, 0, -10])
                        cube([50, 50, 20]);
                    }

                    translate([-25, -18.1, 26+20])
                    union() {
                        rotate([0, 90, 0])
                        cylinder(h=50, d=20, $fn=30);

                        translate([0, 0, -10])
                        cube([50, 50, 20]);
                    }

                    translate([0, 0, -5])
                    cylinder(h=26+30, d=M6_screw_diameter+10, $fn=100);

                    translate([0, 0, -.01+10])
                    cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);

                    translate([0, 0, 26-608_bearing_thickness+10+.01])
                    cylinder(h=608_bearing_thickness, d=608_bearing_outer_diameter, $fn=100);
                }

                if(!print_plate) {
                    translate([0, 0, 608_bearing_thickness+10])
                    888_5011();
                }
            }

            // angle arrow
            translate([ALU_profile_width/2+5, ALU_profile_width/2+5, tower_height-12])
            hull() {
                cube([15, 2, 0.1]);

                translate([0, 0, -5])
                cube([1, 10, 10]);
            }
        }

        translate([15, -20/2, tower_height-25])
        difference() {
            cube([18, 18, 25]);

            translate([-1, 0.25, 0.25])
            cube([22, 17.5, 24.5]);
        }

//        cube([500, 20, 500]);
    }
}

888_5007();

#888_5007_attachment_points();

#888_5015();
