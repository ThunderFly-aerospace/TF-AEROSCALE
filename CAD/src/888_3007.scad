include <../parameters.scad>
draft = false;
$fn =  draft ? 50 :100;
platform_height = 52;

module 888_3007(draft){

    height = ALU_profile_width;
    magnet_d = 80;
    cylinder_height = magnet_d/2;
    magnet_offset = 35;
    posunuti_vahy = -24.8;
    nut_size = 28; //šížka křídel matky na střeše

    difference(){
        union(){
            hull(){
                cylinder(r = g3_0_cone1, h = 5, $fn = draft?50:100);
                translate([0,0, height/2 - 5])
                    cylinder(r = magnet_d/2 , h = 5, $fn=draft?50:100);
            }
            translate([0, posunuti_vahy, ALU_profile_width/2])
                cube([maximum_printable_size, ALU_profile_width+10, ALU_profile_width], center=true);

            for (i = [0:1]){
                rotate([0, 0, i*180+90])
                    translate([g3_0_srcew_dist, 0, 30-18-5])
                        cylinder(h=6, d=M6_nut_diameter+5, $fn=50);
            }
        }

        //srouby pro montaz profilu
        translate([-maximum_printable_size/2 + M6_screw_diameter*1.5, 0, ALU_profile_width/2])
            rotate([90, 0, 0])
                cylinder(d=M6_screw_diameter, h=g3_0_cone1*2, $fn=20, center=true);

        translate([maximum_printable_size/2 - M6_screw_diameter*1.5, 0, ALU_profile_width/2])
            rotate([90, 0, 0])
                cylinder(d=M6_screw_diameter, h=g3_0_cone1*2, $fn=20, center=true);

        // otvor pro AL profil
        translate([0, posunuti_vahy, 0])
            cube([g3_0_cone1*2.2+5, ALU_profile_width, 100], center=true);

        // srouby pro pridelani na strechu
    #    for (i = [1:4])
                {
                    rotate([0, 0, i*90])
                    {
                        // Washer
                        translate([g3_0_srcew_dist, 0, 0])
                            cylinder(h = 2, d = 19);
                        // Nut hole
                        translate([g3_0_srcew_dist, 0, 2])
                            cylinder(h = M6_nut_height, d = M6_nut_diameter);
                        // Bolt hole
                        translate([g3_0_srcew_dist, 0, 0])
                            cylinder(h = platform_height, d = M6_screw_diameter);

                        if(i==1 || i==3) {
                            translate([g3_0_srcew_dist, 0, 30-18-5+6+2])
                                cylinder(d=nut_size, h=100);
                        }
                    }
                }
    }
}

888_3007(draft);
