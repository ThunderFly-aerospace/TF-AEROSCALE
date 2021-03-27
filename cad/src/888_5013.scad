include <../parameters.scad>
use <./lib/ALU_profile.scad>

module 888_5013() {
    difference() {
        union() {
            translate([-1/2-3, 0, 15/2])
            cube([1, 9, 15], center=true);
            
            translate([-5/2+1, 0, 15/2])
            cube([5, 8.2, 15], center=true);
            
            translate([1, 0, 15/2])
            cube([2, 20, 15], center=true);
            
            translate([-1, 0, 0])
            difference() {
                cylinder(d=16, h=15, $fn=50);
                
                translate([0, 0, -1])
                cylinder(d=13, h=17, $fn=50);
                
                translate([-20+2, -10, -1])
                cube([20, 20, 17]);
                
                translate([-20+4, -20, -1])
                cube([20, 20, 17]);
            }
        }
        
        translate([-5/2, 0, 16/2-.01])
        cube([5, 6.2, 16], center=true);
    }
}

888_5013();

#translate([-ALU_profile_width/2, 0, 0])
ALU_profile(height=30);