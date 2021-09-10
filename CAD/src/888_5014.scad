include <../parameters.scad>
use <./lib/ALU_profile.scad>

module 888_5014_front() {
    union() {
        difference() {
            translate([0, -electro_box_width-ALU_profile_width-3, -ALU_profile_width+2])
            cube([20, electro_box_width+3+ALU_profile_width, electro_box_height+6+ALU_profile_width-3]);
            
            
            //main box cutter
            translate([-ALU_profile_width/2, -electro_box_width-ALU_profile_width, 2-.01])
            cube([electro_box_length, electro_box_width, electro_box_height]);
            
            //ALU profile cutter
            translate([-ALU_profile_width/2, -1-ALU_profile_width, -ALU_profile_width])
            cube([electro_box_length, ALU_profile_width+2, ALU_profile_width+2]);
            
            //Side cutter
            translate([-ALU_profile_width/2, -ALU_profile_width+20+3, 20+2+3])
            rotate([0, 90, 0])
            hull() {
                cylinder(h=electro_box_length, r=20, $fn=100);
                
                translate([0, 50, 0])
                cylinder(h=electro_box_length, r=20, $fn=100);
                
                translate([-50, 0, 0])
                cylinder(h=electro_box_length, r=20, $fn=100);
            }
            
            //Side screw hole
            translate([0+10, -ALU_profile_width/2, -8])
            rotate([0, 0, 0])
            union() {
                cylinder(h=50, d=M6_screw_diameter, $fn=100);
                
                translate([0, 0, 13])
                cylinder(h=50, d=M6_nut_diameter+5, $fn=100);
            }
            
            //Bottom cutter
            translate([-ALU_profile_width/2, -ALU_profile_width-20-1-3, -20])
            rotate([0, 90, 0])
            hull() {
                cylinder(h=electro_box_length, r=20, $fn=100);
                
                translate([0, -200, 0])
                cylinder(h=electro_box_length, r=20, $fn=100);
                
                translate([50, 0, 0])
                cylinder(h=electro_box_length, r=20, $fn=100);
            }
            
            //Bottom screw hole
            translate([0+10, -ALU_profile_width+9, -ALU_profile_width/2])
            rotate([90, 0, 0])
            union() {
                cylinder(h=50, d=M6_screw_diameter, $fn=100);
                
                translate([0, 0, 13])
                cylinder(h=50, d=M6_nut_diameter+5, $fn=100);
            }
        }
        
        
        //Cable Holder
        translate([20, -ALU_profile_width, ALU_profile_width+5])
        rotate([-90, 0, 90])
        difference() {
            cylinder(d=16, h=20, $fn=50);
            
            translate([0, 0, -1])
            cylinder(d=13, h=22, $fn=50);
            
            translate([-20+2, -10, -1])
            cube([20, 20, 22]);
            
            translate([-20+4, -20, -1])
            cube([20, 20, 22]);
        }
    }
}

module 888_5014_back() {
    union() {
        difference() {
            translate([0, -electro_box_width-ALU_profile_width-3, -ALU_profile_width+2])
            cube([20, electro_box_width+3+ALU_profile_width, electro_box_height+6+ALU_profile_width-3]);
            
            
            //main box cutter
            translate([-ALU_profile_width/2, -electro_box_width-ALU_profile_width, 2-.01])
            cube([electro_box_length, electro_box_width, electro_box_height]);
            
            //ALU profile cutter
            translate([-ALU_profile_width/2, -1-ALU_profile_width-35, -ALU_profile_width])
            cube([electro_box_length, ALU_profile_width+2+35, ALU_profile_width+2]);
            
            //Side cutter
            translate([-ALU_profile_width/2, -ALU_profile_width+20+3, 20+2+3])
            rotate([0, 90, 0])
            hull() {
                cylinder(h=electro_box_length, r=20, $fn=100);
                
                translate([0, 50, 0])
                cylinder(h=electro_box_length, r=20, $fn=100);
                
                translate([-50, 0, 0])
                cylinder(h=electro_box_length, r=20, $fn=100);
            }
            
            //Side screw hole
            translate([0+10, -ALU_profile_width/2, -8])
            rotate([0, 0, 0])
            union() {
                cylinder(h=50, d=M6_screw_diameter, $fn=100);
                
                translate([0, 0, 13])
                cylinder(h=50, d=M6_nut_diameter+5, $fn=100);
            }
            
            //Bottom cutter
            translate([20+3, -ALU_profile_width, -20])
            rotate([90, 0, 0])
            hull() {
                cylinder(h=electro_box_width+20, r=20, $fn=100);
                
                translate([0, -50, 0])
                cylinder(h=electro_box_width+20, r=20, $fn=100);
                
                translate([50, 0, 0])
                cylinder(h=electro_box_width+20, r=20, $fn=100);
            }
            
            //Bottom screw holes
            translate([-10, -15-35-ALU_profile_width, -ALU_profile_width/2])
            rotate([0, 90, 0])
            union() {
                cylinder(h=50, d=M6_screw_diameter, $fn=100);
                
                translate([0, 0, 13])
                cylinder(h=50, d=M6_nut_diameter+5, $fn=100);
            }
            
            translate([-10, -electro_box_width+15-ALU_profile_width, -ALU_profile_width/2])
            rotate([0, 90, 0])
            union() {
                cylinder(h=50, d=M6_screw_diameter, $fn=100);
                
                translate([0, 0, 13])
                cylinder(h=50, d=M6_nut_diameter+5, $fn=100);
            }
        }
        
        //Cable Holder
        translate([20, -ALU_profile_width, ALU_profile_width+5])
        rotate([-90, 0, 90])
        difference() {
            cylinder(d=16, h=20, $fn=50);
            
            translate([0, 0, -1])
            cylinder(d=13, h=22, $fn=50);
            
            translate([-20+2, -10, -1])
            cube([20, 20, 22]);
            
            translate([-20+4, -20, -1])
            cube([20, 20, 22]);
        }
    }
}

translate([150, 0, 0])
888_5014_front();


888_5014_back();

translate([-ALU_profile_width/2, 0, -ALU_profile_width/2])
rotate([90, 0, 0])
#ALU_profile(height=500);

translate([0, -ALU_profile_width/2, -ALU_profile_width/2])
rotate([0, 90, 0])
#ALU_profile(height=500);

translate([-ALU_profile_width/2, -electro_box_width-ALU_profile_width, 2-.01])
#cube([electro_box_length, electro_box_width, electro_box_height]);