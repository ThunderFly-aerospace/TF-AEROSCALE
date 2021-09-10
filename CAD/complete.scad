include <./parameters.scad>
use <./src/lib/ALU_profile.scad>
use <./src/888_3007.scad>
use <./src/888_5001.scad>
use <./src/888_5002.scad>
use <./src/888_5003.scad>
use <./src/888_5004.scad>
use <./src/888_5005.scad>
use <./src/888_5006.scad>
use <./src/888_5007.scad>
use <./src/888_5008.scad>
use <./src/888_5009.scad>
use <./src/888_5010.scad>
use <./src/888_5011.scad>
use <./src/888_5012.scad>
use <./src/888_5013.scad>
use <./src/888_5014.scad>
use <./src/888_5015.scad>
use <./src/888_1001.scad>
use <./src/888_1002.scad>
use <./src/888_1003.scad>


base_width = mid_base_width+ALU_profile_width*2+ALU_profile_holder_wall_thickness*2+M6_washer_thickness*2;
side_pillars_offset = -ALU_profile_width/2+base_mid_base_hinge_offset;
mid_base_height_offset = (608_bearing_outer_diameter+10)/2-1;

module tenzometer(mounting_part=true) {
    translate([-strain_gauge_length/2, -strain_gauge_width/2, 0])
    color([0, 0, 1])
    cube([strain_gauge_length, strain_gauge_width, strain_gauge_width]);
    
    if(mounting_part) {
        translate([-7.5, ALU_profile_width/2+ALU_profile_holder_wall_thickness, -ALU_profile_holder_wall_thickness])
        rotate([90, 0 ,-90])
        color([0, 1, 1])
        888_5001();
    }
    
    translate([strain_gauge_length/2-(strain_gauge_screw_distance*1.75)/2, 0, 0])
    rotate([0, 0 ,90])
    color([0, 1, 1])
    888_5002();
}


// base ///////////////////////////////////////////////////////////////
translate([-base_length/2, 0, ALU_profile_width/2])
rotate([0, 90, 0])
ALU_profile(height=base_length);

translate([-base_length/2, base_width/2-ALU_profile_width*2+ALU_profile_holder_wall_thickness+5, ALU_profile_width/2])
rotate([0, 90, 0])
ALU_profile(height=base_length);

translate([-base_length/2, -base_width/2+ALU_profile_width*2-ALU_profile_holder_wall_thickness-5, ALU_profile_width/2])
rotate([0, 90, 0])
ALU_profile(height=base_length);

translate([-base_length/2-ALU_profile_width/2, -base_length/2, ALU_profile_width/2])
rotate([0, 90, 90])
ALU_profile(height=base_length);

translate([base_length/2+ALU_profile_width/2, -base_length/2, ALU_profile_width/2])
rotate([0, 90, 90])
ALU_profile(height=base_length);

translate([mid_base_length/2-mid_base_x_offset+2, 0, ALU_profile_width+ALU_profile_holder_wall_thickness*3])
tenzometer();

// car attachment point
translate([0, 24.8, 0])
rotate([0, 0, 0])
color([0, 1, 1])
888_3007();

//box
translate([mid_base_length/2, -base_length/2+3, ALU_profile_width])
rotate([0, 0, 180])
color([0, 1, 1])
888_5014_back();

translate([mid_base_length/2-150, -base_length/2+3, ALU_profile_width])
rotate([0, 0, 180])
color([0, 1, 1])
888_5014_front();

translate([mid_base_length/2+ALU_profile_width/2, -base_length/2+3+electro_box_width+ALU_profile_width, ALU_profile_width+3])
rotate([0, 0, 180])
color([0, 1, 1])
#cube([electro_box_length, electro_box_width, electro_box_height]);

// front pillar //////////////////////////////////////////////////////
translate([-base_length/2-ALU_profile_width/2, 0, ALU_profile_width])
ALU_profile(height=mid_base_height+tower_height+20);

translate([-base_length/2+ALU_profile_holder_wall_thickness*2, -ALU_profile_width/2-ALU_profile_holder_wall_thickness, tower_height-strain_gauge_length/2-tower_drag_z_offset/2+2+mid_base_height+ALU_profile_width*2+ALU_profile_holder_wall_thickness*2-strain_gauge_length/2+(strain_gauge_screw_distance*1.75)/2+M5_screw_diameter*2.5/2])
rotate([180, 0, 90])
color([0, 1, 1])
888_5003_A();


// side pillars ///////////////////////////////////////////////////////
translate([-side_pillars_offset-ALU_profile_width/2, -base_width/2+ALU_profile_width*2-ALU_profile_holder_wall_thickness-5, ALU_profile_width])
ALU_profile(height=mid_base_height+mid_base_height_offset-ALU_profile_width*2-ALU_profile_holder_wall_thickness*4);

translate([-side_pillars_offset-ALU_profile_width/2, base_width/2-ALU_profile_width*2+ALU_profile_holder_wall_thickness+5, ALU_profile_width])
ALU_profile(height=mid_base_height+mid_base_height_offset-ALU_profile_width*2-ALU_profile_holder_wall_thickness*4);

// mid base hinges - static attachment points
translate([-side_pillars_offset, base_width/2-ALU_profile_width*2+ALU_profile_holder_wall_thickness+5, mid_base_height-mid_base_height_offset])
rotate([90, 0, -90])
color([0, 1, 1])
888_5004();

translate([-side_pillars_offset-ALU_profile_width, -base_width/2+ALU_profile_width*2-ALU_profile_holder_wall_thickness-5, mid_base_height-mid_base_height_offset])
rotate([90, 0 ,90])
color([0, 1, 1])
888_5004();

// mid base ///////////////////////////////////////////////////////////
translate([-mid_base_length/2-mid_base_x_offset, mid_base_width/2-ALU_profile_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 0])
ALU_profile(height=mid_base_length);

translate([-mid_base_length/2-mid_base_x_offset, -mid_base_width/2+ALU_profile_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 0])
ALU_profile(height=mid_base_length);

translate([-mid_base_length/2-ALU_profile_width/2-mid_base_x_offset, -mid_base_width/2, ALU_profile_width/2+mid_base_height])
rotate([0, 90, 90])
ALU_profile(height=mid_base_width);

translate([mid_base_length/2-ALU_profile_width/2-mid_base_x_offset, -mid_base_width/2, ALU_profile_width*1.5+mid_base_height])
rotate([0, 90, 90])
ALU_profile(height=mid_base_width);

// lift strain gauge attachment point    
translate([mid_base_length/2+ALU_profile_holder_wall_thickness*2-mid_base_x_offset, -ALU_profile_width/2+strain_gauge_width, mid_base_height-ALU_profile_holder_wall_thickness+ALU_profile_width])
rotate([-90, -90 ,0])
color([0, 1, 1])
888_5003_B();
    
// base hinges
translate([ALU_profile_width*.75-base_mid_base_hinge_offset, -mid_base_width/2+ALU_profile_width+ALU_profile_holder_wall_thickness*2, mid_base_height-ALU_profile_holder_wall_thickness])
rotate([0, -90 ,0])
color([0, 1, 1])
888_5005();
    
translate([-ALU_profile_width*.75-base_mid_base_hinge_offset, mid_base_width/2-ALU_profile_width-ALU_profile_holder_wall_thickness*2, mid_base_height-ALU_profile_holder_wall_thickness])
rotate([0, -90, 180])
color([0, 1, 1])
888_5005();

// tower hinges attachment points
translate([ALU_profile_width*.75, -mid_base_width/2+ALU_profile_width+ALU_profile_holder_wall_thickness*2, mid_base_height-ALU_profile_holder_wall_thickness])
rotate([0, -90 ,0])
color([0, 1, 1])
888_5005();
    
translate([-ALU_profile_width*.75, mid_base_width/2-ALU_profile_width-ALU_profile_holder_wall_thickness*2, mid_base_height-ALU_profile_holder_wall_thickness])
rotate([0, -90, 180])
color([0, 1, 1])
888_5005();


// tower ///////////////////////////////////////////////////////////////////
translate([0, mid_base_width/2-ALU_profile_width, ALU_profile_width+mid_base_height+35])
rotate([tower_angle, 0 ,0])
translate([0, ALU_profile_width/2 ,0])
ALU_profile(height=tower_arm_length);

translate([0, -mid_base_width/2+ALU_profile_width, ALU_profile_width+mid_base_height+35])
rotate([-tower_angle, 0 ,0])
translate([0, -ALU_profile_width/2 ,0])
ALU_profile(height=tower_arm_length);

// tower hinges
translate([0, 0, ALU_profile_width+mid_base_height])
color([0, 1, 1])
888_5006(side=-1);
    
translate([0, 0, ALU_profile_width+mid_base_height])
color([0, 1, 1])
888_5006(side=1);

// rotor joint mekanism
translate([0, 0, ALU_profile_width+mid_base_height+35])
rotate([0, 0, 0])
color([0, 1, 1])
888_5007();

translate([0, 0, ALU_profile_width+mid_base_height+35])
rotate([0, 0, 0])
color([0, 1, 1])
888_5015();
    
translate([(608_bearing_outer_diameter+10+ALU_profile_width)/2+ALU_profile_holder_wall_thickness+15, 0, 70+(608_bearing_outer_diameter+10+5)/2+tower_height+mid_base_height+35+ALU_profile_width-12])
rotate([180, 0, 90])
color([0, 1, 1])
888_5008(); 

translate([(608_bearing_outer_diameter+10+ALU_profile_width)/2+ALU_profile_holder_wall_thickness+5, -M6_square_nut_diameter/2-1, 70+(608_bearing_outer_diameter+10+5)/2+tower_height+mid_base_height+ALU_profile_width-6])
rotate([180, 0, 90])
color([0, 1, 1])
888_5009();

// drag strain gauge attachment point
translate([-ALU_profile_width/2-ALU_profile_holder_wall_thickness*2+strain_gauge_width+6, 0, tower_height-strain_gauge_length/2-tower_drag_z_offset/2+2+mid_base_height+ALU_profile_width*2+ALU_profile_holder_wall_thickness*2])
rotate([0, 90, 180])
tenzometer(mounting_part=false);

// calibration device
translate([-base_length/2, -ALU_profile_width/2, mid_base_height+tower_height+20])
rotate([0, 0, 180])
color([1, 1, 0])
union() {
    888_1001();
    
    translate([calibration_arm_x_offset, -.5, calibration_arm_y_offset])
    rotate([90, 0, 0])
    888_1002();
}