include <../parameters.scad>
use <./lib/ALU_profile_holder_side.scad>
use <./888_5002.scad>


module 888_5003() {
    union() {
        translate([0, -ALU_profile_width-ALU_profile_holder_wall_thickness*2, 0])
        ALU_profile_holder_side(ALU_profile_width);
        
        translate([ALU_profile_width/2+ALU_profile_holder_wall_thickness, -.01 ,ALU_profile_width/2])
        rotate([-90, 90, 0])
        888_5002();
    }
}

888_5003();
