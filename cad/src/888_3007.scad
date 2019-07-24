use <lib/naca4.scad>
include <../parameters.scad>
use <lib/curvedPipe.scad>
draft = true;
$fs =  draft ? 50 :100;

module 888_3006(draft){

    height = 50;
    magnet_d = 80;
    cylinder_height = magnet_d/2;
    magnet_offset = 35;

    difference(){
        union(){
            hull(){
                cylinder(r = g3_0_cone1, h = 5, $fn = draft?50:100);
                translate([0,0, height/2 - 5])
                    cylinder(r = magnet_d/2 , h = 5, $fn=draft?50:100);
            }
            cylinder(r = magnet_d/2 , h = 50, $fn=draft?50:100);

        }

        cylinder(d = M5_screw_diameter, h=100, $fn=draft?50:100);
        cylinder(d = M5_head_diameter, h= 50-20-15, $fn=6);

            translate([-50, -31/2, 50-15])
                cube([100, 31, 31]);

        // srouby pri pridelani na strechu
        for (i = [0:3]){
            rotate([0, 0, i*90])
                translate([g3_0_srcew_dist, 0, -global_clearance])
                    cylinder(h = 100, d = M6_screw_diameter, $fn = 50);
            rotate([0, 0, i*90])
                translate([g3_0_srcew_dist, 0, -global_clearance])
                    cylinder(h=1, d1=M6_screw_diameter+2, d2=M6_screw_diameter, $fn=draft?50:100);
            rotate([0, 0, i*90])
                translate([g3_0_srcew_dist, 0, 30-18-5])
                    rotate([0,0,30])
                        cylinder(h=20, d=M6_nut_diameter, $fn=6);
        }
    }
}

888_3006(draft);
