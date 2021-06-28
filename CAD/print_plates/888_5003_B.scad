//@set_slicing_config(../slicing/default.ini)

include <../parameters.scad>
use <../src/888_5003.scad>

888_5003_B();
        
difference() {
    translate([ALU_profile_width/2+3, strain_gauge_width*2-4, strain_gauge_width])
    cube([M5_screw_diameter*2.5, M5_screw_diameter*2, 8], center=true);
    
    translate([ALU_profile_width/2+3, strain_gauge_width*2-4, strain_gauge_width-0.5])
    cube([M5_screw_diameter*2.5-2, M5_screw_diameter*2-2, 10], center=true);
}
