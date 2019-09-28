include <../parameters.scad>

module 888_5002() {
    joint_width = 8;
    
    difference() {
        hull() {
            translate([0, 0, -1])
                cube([strain_gauge_width*1.5, strain_gauge_screw_distance*1.75, 2], center=true);

            translate([0, 0, strain_gauge_width*2])
                rotate([0, 90, 0])
                    cylinder(d=M5_screw_diameter*1.6, h=strain_gauge_width*1.5, center=true, $fn=50);
        }

        translate([0, 0, strain_gauge_width*2])
            rotate([0, 90, 0])
                cylinder(d=M5_screw_diameter, h=strain_gauge_width*2, center=true, $fn=50);

        translate([0, 0, strain_gauge_width/2])
            cube([strain_gauge_width, strain_gauge_width*2, strain_gauge_width], center=true);

        translate([0, 0, strain_gauge_width*3/2])
            cube([joint_width, strain_gauge_width*2, strain_gauge_width*3], center=true);

        translate([0, strain_gauge_screw_distance/2, 0])
            cylinder(d=M4_screw_diameter, h=10, center=true, $fn=20);

        translate([0, -strain_gauge_screw_distance/2, 0])
            cylinder(d=M4_screw_diameter, h=10, center=true, $fn=20);

        translate([0, 0, strain_gauge_width])
            rotate([90, 0, 0])
                cylinder(d=strain_gauge_width, h=strain_gauge_width*2, $fn=100, center=true);
    }
}

888_5002();