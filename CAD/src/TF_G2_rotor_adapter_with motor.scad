include <../parameters.scad>

use <./TF-G2-rotor-neck.scad>

$fn = 100;


connector_hole_w=45;
connector_hole_d=4.2;
connector_h=5;

connector_top_w=25;
connector_top_h=6;



TFPROBE01_PCB_thickness = 1.8;
TFPROBE01_PCB_width = 10.2;
TFPROBE01_sensor_height = 1.1;


motor_distance = -78.8; // vzdalenost prerotatoru od hlavni pos_y
motor_diameter = 35+2;
motor_axis_diameter = 6.3;
motor_puller_diameter = 20;
motor_screw_diameter = M3_screw_diameter;
motor_mounting_diameter = 25; // vzdalenost protejsich sroubu pro pridelani prerotatoru
motor_sink = 9.5+4+1; // pro zapusteni bez podlozek na motoru...


screw_offset=rotorBearingNeck_screw_offset();
screw_angle=rotorBearingNeck_screw_angle();

module TF_G2_rotor_adapter(){

    difference()
    {
        union()
        {        
            hull()
            {

                //podstava
                minkowski()
                {
                    translate([0,0,connector_h/2-motor_sink])
                        cube([connector_hole_w,connector_hole_w,0.001],center=true);
                    cylinder(d=16,h=connector_h,center=true);
                }                 
                
                //zamek
                translate([0,0,-connector_top_h/2])
                    cube([connector_top_w,connector_top_w,connector_top_h],center=true);
                
                //motor
                translate([0,motor_distance,-motor_sink/2])
                    cylinder(d=motor_diameter,h=motor_sink,center=true);
                    
                //rpm
                translate([0,5+rotorBearingNeck_t()/2+2,-TFPROBE01_sensor_height-TFPROBE01_PCB_thickness/2])
                   cube([TFPROBE01_PCB_width+2,10,TFPROBE01_PCB_thickness+2], center=true);
            }
        }
        
        //zámek krčku
        rotorBearingNeckHousing();
       
        //šrouby motoru        
        translate([0,motor_distance,0])
            rotate([0,0,45])
            {
                cylinder(d=motor_puller_diameter, h=5*motor_sink,center=true);
                for(i=[-1,1])
                    translate([i*motor_mounting_diameter/2,0,0])
                    {
                       cylinder(d=motor_screw_diameter,h=5*motor_sink,center=true);
                       translate([0,0,-3])
                            cylinder(d=5.5,h=3.01);
                    }
                for(i=[-1,1])
                    translate([0,i*motor_mounting_diameter/2,0])
                    {
                       cylinder(d=motor_screw_diameter,h=5*motor_sink,center=true);
                       translate([0,0,-3])
                            cylinder(d=5.5,h=3.01);
                    }
            }
        
        //odlehčení
        hull()
        {
            translate([0,-30,0])
                cylinder(d=22,h=5*motor_sink, center=true);
                
            translate([0,-62,0])
                cube([28,1,5*motor_sink], center=true);
        
        }
        
        //rpm senzor
        translate([0,50/2+rotorBearingNeck_t()/2-2,-2.5*motor_sink-TFPROBE01_sensor_height])
           cube([TFPROBE01_PCB_width-2,50,5*motor_sink], center=true);
        translate([0,50/2+rotorBearingNeck_t()/2-2,+2.5*motor_sink-TFPROBE01_sensor_height+0.2])
           cube([TFPROBE01_PCB_width-2,50,5*motor_sink], center=true);
        translate([0,50/2+rotorBearingNeck_t()/2-2,-TFPROBE01_sensor_height-TFPROBE01_PCB_thickness/2])
           cube([TFPROBE01_PCB_width,50,TFPROBE01_PCB_thickness], center=true);
        
        //šrouby
        for(i=[-1,1])
            for(j=[-1,1])
            {
                translate([i*connector_hole_w/2,j*connector_hole_w/2,0])
                {
                    cylinder(d=connector_hole_d,h=5*motor_sink,center=true);
                    translate([0,0,-motor_sink+connector_h])
                        cylinder(d=16,h=5*motor_sink);
                }
            }
            
            
        //matice    
        for(i=[-1,1])  
        translate([i*(screw_offset),-screw_offset,0])
            rotate([screw_angle,0,0])
                translate([0,0,-7-M3_nut_height])
                hull()
                {
                    cylinder(d=M3_nut_pocket+0.9,h=M3_nut_height+0.1, $fn=6);
                    translate([i*50,0,0])
                        cylinder(d=M3_nut_pocket+0.9,h=M3_nut_height+0.1, $fn=6);
                }
        //díra pro štělování ložiska
        cylinder(d=3.5,h=50, center=true);
    }
    
    //vyztuha na vršku matice
    for(i=[-1,1])  
    translate([i*(screw_offset),-screw_offset,0])
        rotate([screw_angle,0,0])
            translate([0,0,-7+0.1])
                cylinder(d=7,h=0.2, $fn=6);

    
    
}


TF_G2_rotor_adapter();
