include <../parameters.scad>
use <./lib/rotor_joint.scad>

$fn = 100;

space = 1; // parametr z dilu 1002, rika tloustku steny

rotor_shaft_angle = 10;

rod_size = 8; // delka hrany sloupku
Bwall = 1.6; // wall around bearing

BaseThickness = 0;
BaseBoldDiameter = M3_screw_diameter;
BaseBoldHeadDiameter = M3_nut_diameter + 0.5;
BaseBoldHeadHeight = M3_nut_height;

bearing_inner_diameter = 7;

// nastaveni delek tahel
rod_x_dist = 30;

rod_y_distance = rod_x_dist*2 - 3*2; // 3 je delka kuloveho cepu
rod_x_distance = rod_x_dist - rod_size/2 - BaseThickness - M3_screw_diameter/2 - space;

TFPROBE01_PCB_thickness = 1.8;
TFPROBE01_PCB_width = 10.2;
TFPROBE01_sensor_height = 1.1;

module TF_G2_rotor_adapter(){

    // Vypocet uhlu
    rotor_plane_space = 7+3; // Vzdalenost od loziska k rovine rotoru (je to predevsim vzdalenost dvou maticek)

    bearing_shaft_shift = ((rod_size/2 + BaseThickness + M3_screw_diameter/2 + space)/tan(rotor_shaft_angle)) - bearing_shaft_length - rotor_plane_space;

    translate([0, 0, -bearing_outer_diameter/2 - Bwall])
    difference(){
    union(){
        translate([-rod_size/2, 0, bearing_outer_diameter/2 + Bwall]) rotate([0, 90, 0])
        cylinder(d = bearing_outer_diameter + Bwall*2, h = bearing_shaft_length + bearing_shaft_shift + rod_size/2);
    
        translate([-rod_size/2, -12.5, -BaseThickness-5])
        cube([bearing_outer_diameter, 25, 25]);
        
        translate([-rod_size/2-2, -12.5, -BaseThickness-5])
        cube([bearing_outer_diameter, 25, 42.85]);
        
        
        translate([-10, 0, bearing_outer_diameter/2 + Bwall])
        rotate([0, 90, 0])
        rotor_joint(2);
    }


    // Zapusteni pro loziska
    translate([bearing_shaft_shift + bearing_shaft_length - bearing_shaft_length + bearing_thickness - 100, 0, bearing_outer_diameter/2 + Bwall])
        rotate([0, 90, 0])
            cylinder(d = bearing_outer_diameter, h = 100);

    translate([bearing_shaft_shift + bearing_shaft_length - bearing_shaft_length + bearing_thickness + layer_thickness, 0, bearing_outer_diameter/2 + Bwall])
        rotate([0, 90, 0])
            cylinder(d = bearing_inner_diameter, h = 100);

    translate([bearing_shaft_shift + bearing_shaft_length - bearing_thickness, 0, bearing_outer_diameter/2 + Bwall])
        rotate([0, 90, 0])
            cylinder(d = bearing_outer_diameter, h = bearing_thickness + 0.1 + 100);

    translate([-9/2-6, -9/2, bearing_outer_diameter + Bwall*4])
        cube([15,9,rod_y_distance]);

    // TFPROBE01 RPM sensor
    translate([-TFPROBE01_PCB_thickness + rod_size/2 - TFPROBE01_sensor_height , -TFPROBE01_PCB_width/2, bearing_outer_diameter + Bwall*4])
    cube([TFPROBE01_PCB_thickness, TFPROBE01_PCB_width, rod_y_distance]);

    }
}

TF_G2_rotor_adapter();