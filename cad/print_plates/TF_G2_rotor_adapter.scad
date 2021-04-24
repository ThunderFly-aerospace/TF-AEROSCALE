include <../parameters.scad>
use <../src/TF_G2_rotor_adapter.scad>


translate([0, 0, 14.5])
rotate([0, -90, 0])
TF_G2_rotor_adapter();