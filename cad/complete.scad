include <./parameters.scad>
use <./src/lib/ALU_profile.scad>
use <./src/888_3007.scad>
use <./src/888_5001.scad>
use <./src/888_5002.scad>
use <./src/888_5003.scad>
use <./src/888_5004.scad>
use <./src/888_5005.scad>
use <./src/888_5006.scad>


base_width = mid_base_width+ALU_profile_width*2+ALU_profile_holder_wall_thickness*2;
side_pillars_offset = (M6_screw_diameter+10)/2-ALU_profile_holder_wall_thickness+base_mid_base_hinge_offset;

module tenzometer() {
    translate([-strain_gauge_screw_distance/2-10, strain_gauge_width/-2, ALU_profile_width/2+ALU_profile_holder_wall_thickness*2+3])
    color([0, 0, 1]) cube([strain_gauge_length, strain_gauge_width, strain_gauge_width]);
    
    translate([15, ALU_profile_width/2+ALU_profile_holder_wall_thickness, ALU_profile_width/2+ALU_profile_holder_wall_thickness*2])
    rotate([90, 0 ,-90])
    color([0, 1, 1])
    888_5001();
    
    translate([45, 0, 39])
    rotate([0, 0 ,90])
    color([0, 1, 1])
    888_5002();
}


// base ///////////////////////////////////////////////////////////////
translate([-250, 0, ALU_profile_width/2])
rotate([0, 90, 0])
ALU_profile(height=500);

translate([-250, base_width/2-ALU_profile_width/2, ALU_profile_width/2])
rotate([0, 90, 0])
ALU_profile(height=500);

translate([-250, -base_width/2+ALU_profile_width/2, ALU_profile_width/2])
rotate([0, 90, 0])
ALU_profile(height=500);

translate([-250-ALU_profile_width/2, -base_width/2, ALU_profile_width/2])
rotate([0, 90, 90])
ALU_profile(height=base_width);

translate([250+ALU_profile_width/2, -base_width/2, ALU_profile_width/2])
rotate([0, 90, 90])
ALU_profile(height=base_width);

translate([155+ALU_profile_width/2, 0, ALU_profile_width/2])
tenzometer();

// car attachment point
translate([0, 24.8, 0])
rotate([0, 0 ,0])
color([0, 1, 1])
888_3007();


// side pillars ///////////////////////////////////////////////////////
translate([-side_pillars_offset-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, -base_width/2+ALU_profile_width/2, ALU_profile_width])
ALU_profile(height=mid_base_height);

translate([-side_pillars_offset-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2, base_width/2-ALU_profile_width/2, ALU_profile_width])
ALU_profile(height=mid_base_height);

// mid base hinges - static attachment points
translate([-side_pillars_offset, base_width/2+ALU_profile_holder_wall_thickness, mid_base_height-ALU_profile_width])
rotate([0, 0 ,-90])
color([0, 1, 1])
888_5004();

translate([-side_pillars_offset, -base_width/2+ALU_profile_width+ALU_profile_holder_wall_thickness, mid_base_height-ALU_profile_width])
rotate([0, 0 ,-90])
color([0, 1, 1])
888_5004();

// front pillar ///////////////////////////////////////////////////////
translate([-250-ALU_profile_width/2, 0, ALU_profile_width])
ALU_profile(height=mid_base_height+75);

translate([-250-ALU_profile_width/2, 0, ALU_profile_width+mid_base_height+30])
rotate([180, -90, 0])
tenzometer();

// mid base ///////////////////////////////////////////////////////////
translate([-mid_base_length/3, mid_base_width/2-ALU_profile_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 0])
ALU_profile(height=mid_base_length);

translate([-mid_base_length/3, -mid_base_width/2+ALU_profile_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 0])
ALU_profile(height=mid_base_length);

translate([-mid_base_length/3-ALU_profile_width/2, -mid_base_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 90])
ALU_profile(height=mid_base_width);

translate([mid_base_length/3*2+ALU_profile_width/2, -mid_base_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 90])
ALU_profile(height=mid_base_width);

// strain gauge attachment point    
translate([mid_base_length/3*2-ALU_profile_holder_wall_thickness, -ALU_profile_width/2, mid_base_height-ALU_profile_holder_wall_thickness*2])
rotate([-90, 0 ,0])
color([0, 1, 1])
888_5003();
    
// base hinges
translate([-ALU_profile_width*.75-base_mid_base_hinge_offset, -mid_base_width/2+ALU_profile_width+ALU_profile_holder_wall_thickness*2, mid_base_height+ALU_profile_width+ALU_profile_holder_wall_thickness])
rotate([0, 90 ,0])
color([0, 1, 1])
888_5005();
    
translate([ALU_profile_width*.75-base_mid_base_hinge_offset, mid_base_width/2-ALU_profile_width-ALU_profile_holder_wall_thickness*2, mid_base_height+ALU_profile_width+ALU_profile_holder_wall_thickness])
rotate([0, 90, 180])
color([0, 1, 1])
888_5005();

// tower hinges
translate([ALU_profile_width*.75, -mid_base_width/2+ALU_profile_width+ALU_profile_holder_wall_thickness*2, mid_base_height-ALU_profile_holder_wall_thickness])
rotate([0, -90 ,0])
color([0, 1, 1])
888_5005();
    
translate([-ALU_profile_width*.75, mid_base_width/2-ALU_profile_width-ALU_profile_holder_wall_thickness*2, mid_base_height-ALU_profile_holder_wall_thickness])
rotate([0, -90, 180])
color([0, 1, 1])
888_5005();


// tower arms /////////////////////////////////////////////////////////
translate([0, mid_base_width/2-ALU_profile_width, ALU_profile_width+mid_base_height+35])
rotate([atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
translate([0, ALU_profile_width/2 ,0])
ALU_profile(height=tower_height/cos(atan((200-ALU_profile_width)/tower_height)));

translate([0, -mid_base_width/2+ALU_profile_width, ALU_profile_width+mid_base_height+35])
rotate([-atan((mid_base_width/2-ALU_profile_width)/tower_height), 0 ,0])
translate([0, -ALU_profile_width/2 ,0])
ALU_profile(height=tower_height/cos(atan((200-ALU_profile_width)/tower_height)));


translate([0, 0, ALU_profile_width+mid_base_height])
color([0, 1, 1])
888_5006(side=-1);
    
translate([0, 0, ALU_profile_width+mid_base_height])
color([0, 1, 1])
888_5006(side=1);


