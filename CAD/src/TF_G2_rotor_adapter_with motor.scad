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


motor_distance = 79.03;; // vzdalenost prerotatoru od hlavni pos_y
motor_diameter = 35+2;
motor_axis_diameter = 6.3;
motor_puller_diameter = 20;
motor_screw_diameter = M3_screw_diameter;
motor_mounting_diameter = 25; // vzdalenost protejsich sroubu pro pridelani prerotatoru
motor_sink = 9.5+4; // pro zapusteni bez podlozek na motoru...

module TF_G2_rotor_adapter(){

    // Vypocet uhlu
    rotor_plane_space = 7+3; // Vzdalenost od loziska k rovine rotoru (je to predevsim vzdalenost dvou maticek)

    bearing_shaft_shift = ((rod_size/2 + BaseThickness + M3_screw_diameter/2 + space)/tan(rotor_shaft_angle)) - bearing_shaft_length - rotor_plane_space;

    top=(bearing_outer_diameter+5-rod_size/2-7);
    bottom=-(12+2.5);
    h1=top-bottom;

    translate([0, 0, -bearing_outer_diameter/2 - Bwall])
    difference(){
    union(){
        translate([-rod_size/2, 0, bearing_outer_diameter/2 + Bwall]) rotate([0, 90, 0])
        cylinder(d = bearing_outer_diameter + Bwall*2, h = bearing_shaft_length + bearing_shaft_shift + rod_size/2);
                
        difference() {
            hull() {
                translate([-rod_size/2-7, -12.5, -BaseThickness-5])
                    cube([bearing_outer_diameter+5, 25, 35]);
                
                translate([-12, 0, bearing_outer_diameter/2 + Bwall])
                    rotate([0, 90, 0])
                        rotor_joint_plate(thickness=5);
                
                h1=(bearing_outer_diameter+5-rod_size/2-7)+(12+2.5);
                translate([bottom,0,-motor_distance])
                    rotate([0,90,0])
                        cylinder(d=motor_diameter+5,h=h1);
            }
            translate([bottom-0.1,0,-motor_distance])
                rotate([0,90,0])
                    cylinder(d1=motor_diameter+4, d2=motor_diameter, h= 14.5+5-motor_sink);
            translate([-25,0,-motor_distance])
                rotate([0,90,0])            
                    cylinder(d=motor_puller_diameter, h= 50);
            
            translate([top+0.01, 0, -motor_distance ])
            rotate([0,-90,0]){
                for (i=[[0,1],[0,-1],[1,0], [-1,0]]) {
                    translate([i[0]*motor_mounting_diameter/2, i[1]*motor_mounting_diameter/2, 0]){
                        translate([0,0,M3_screw_head_height-0.1])
                            cylinder(d = motor_screw_diameter, h = motor_sink-M3_screw_head_height , $fn =  50);
                        cylinder(d = M3_nut_diameter, h = M3_screw_head_height+0.5, $fn = 50);
                    }
                }
            }
            
            translate([-14.5, 0, bearing_outer_diameter/2 + Bwall])
                rotate([0, 90, 0])
                    rotor_joint_holes(2,10);
        }
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

    translate([-9/2-11, -9/2, bearing_outer_diameter + Bwall*4])
        cube([20,9,rod_y_distance]);

    // TFPROBE01 RPM sensor
    translate([-TFPROBE01_PCB_thickness + rod_size/2 - TFPROBE01_sensor_height , -TFPROBE01_PCB_width/2, bearing_outer_diameter + Bwall*4])
    cube([TFPROBE01_PCB_thickness, TFPROBE01_PCB_width, rod_y_distance]);

    }
    
    //podpora pro tisk
    translate([0, 0, -bearing_outer_diameter/2 - Bwall])
    translate([bottom,0,-motor_distance])
    rotate([0,90,0])
        difference(){
            cylinder(d=motor_puller_diameter+1, h=-bottom+5-motor_sink);
            translate([0,0,-0.1])
            cylinder(d=motor_puller_diameter, h=-bottom+5-motor_sink+0.2);
        }
}

TF_G2_rotor_adapter();