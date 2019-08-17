include <../parameters.scad>
draft = true;
$fs =  draft ? 50 :100;

module 888_3006(draft){

    height = ALU_profile_width;
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
            translate([0, 0, ALU_profile_width/2])
                cube([g3_0_cone1*2, ALU_profile_width+10, ALU_profile_width], center=true);

            for (i = [0:1]){
                rotate([0, 0, i*180+90])
                    translate([g3_0_srcew_dist, 0, 30-18-5])
                        cylinder(h=6, d=M6_nut_diameter+5, $fn=50);
            }
        }

        translate([g3_0_cone1-10, 0, ALU_profile_width/2])
            rotate([90, 0, 0])
                cylinder(d=M5_screw_diameter, h=g3_0_cone1*2, $fn=20, center=true);

        translate([-g3_0_cone1+10, 0, ALU_profile_width/2])
            rotate([90, 0, 0])
                cylinder(d=M5_screw_diameter, h=g3_0_cone1*2, $fn=20, center=true);


        cube([g3_0_cone1*2+5, ALU_profile_width, 100], center=true);

        // srouby pri pridelani na strechu
        for (i = [0:1]){
            rotate([0, 0, i*180+90])
                translate([g3_0_srcew_dist, 0, M6_nut_height+0.25+1])
                    cylinder(h = 100, d = M6_screw_diameter, $fn = 50);
            rotate([0, 0, i*180+90])
                translate([g3_0_srcew_dist, 0, -global_clearance])
                    cylinder(h=M6_nut_height+1, d=M6_nut_diameter+1, $fn=draft?50:100);
        }
    }
}

888_3006(draft);