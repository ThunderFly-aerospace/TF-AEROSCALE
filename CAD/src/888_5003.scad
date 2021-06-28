include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./888_5002.scad>


module 888_5003_A() {
    union() {
        translate([0, -ALU_profile_width-ALU_profile_holder_wall_thickness*2, 0])
        ALU_profile_holder_side(ALU_profile_width);
        
        translate([ALU_profile_width/2+ALU_profile_holder_wall_thickness, -1, 0])
        rotate([-90, 0, 0])
        difference() {
            hull() {
                translate([0, -ALU_profile_width/2, -1])
                    cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2, ALU_profile_width, 4], center=true);
        
                translate([0, -M5_screw_diameter*2.5/2, strain_gauge_width*2])
                    rotate([0, 90, 0])
                        cylinder(d=M5_screw_diameter*2.5, h=strain_gauge_width*2, center=true, $fn=50);
            }
        
        translate([-strain_gauge_width-10, -M5_screw_diameter*2.5/2, strain_gauge_width*2])
        rotate([0, 90, 0])
        union() {
            cylinder(d=M5_screw_diameter, h=strain_gauge_width*2+11, $fn=50);
            cylinder(d=8, h=M5_head_height+10, $fn=50);
            
            translate([0, 0, strain_gauge_width*2+10-M5_nut_height+.1])
            cylinder(d=M5_nut_diameter, h=20, $fn=6);
        }
    
        translate([0, 0, strain_gauge_width/2])
        cube([strain_gauge_width, ALU_profile_width*2+2, strain_gauge_width], center=true);
    
        translate([0, 0, strain_gauge_width*3/2])
        cube([8, ALU_profile_width*2+2, strain_gauge_width*3], center=true);
    
        translate([0, 0, strain_gauge_width])
        rotate([90, 0, 0])
        cylinder(d=strain_gauge_width, h=ALU_profile_width*2+2, $fn=100, center=true);
        }
    }
}

module 888_5003_B() {
    union() {
        translate([0, -ALU_profile_width-ALU_profile_holder_wall_thickness*2, 0])
        ALU_profile_holder_side(ALU_profile_width);
        
        translate([ALU_profile_holder_wall_thickness, -1, ALU_profile_width/2])
        rotate([-90, 90, 0])
        difference() {
            hull() {
                translate([0, -ALU_profile_width/2, -1])
                    cube([ALU_profile_width, ALU_profile_width+ALU_profile_holder_wall_thickness*2, 4], center=true);
        
                translate([(ALU_profile_width-strain_gauge_width*2)/2, -ALU_profile_width/2, strain_gauge_width*2])
                    rotate([0, 90, 0])
                        cylinder(d=M5_screw_diameter*2.5, h=strain_gauge_width*2, center=true, $fn=50);
            }
        
        translate([(ALU_profile_width-strain_gauge_width*2)/2-strain_gauge_width-10, -ALU_profile_width/2, strain_gauge_width*2])
        rotate([0, 90, 0])
        union() {
            cylinder(d=M5_screw_diameter, h=strain_gauge_width*2+11, $fn=50);
            cylinder(d=8, h=M5_head_height+10, $fn=50);
            
            translate([0, 0, strain_gauge_width*2+10-M5_nut_height+.1])
            cylinder(d=M5_nut_diameter, h=20, $fn=6);
        }
    
        translate([(ALU_profile_width-strain_gauge_width*2)/2, 0, strain_gauge_width/2])
        cube([strain_gauge_width, ALU_profile_width*3+2, strain_gauge_width], center=true);
    
        translate([(ALU_profile_width-strain_gauge_width*2)/2, 0, strain_gauge_width*3/2])
        cube([8, ALU_profile_width*3+2, strain_gauge_width*3], center=true);
    
        translate([(ALU_profile_width-strain_gauge_width*2)/2, 0, strain_gauge_width])
        rotate([90, 0, 0])
        cylinder(d=strain_gauge_width, h=ALU_profile_width*2+2, $fn=100, center=true);
        }
    }
}

888_5003_A();

translate([-50, 0, 0])
888_5003_B();
