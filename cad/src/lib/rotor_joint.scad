/*
pro díl do kterého se zastrkávají matky z boku
    rotor_joint(1);

pro díl který obsahuje jen díry na šrouby M4
    rotor_joint(2);

pro díl co má díry na matky ze shora
    rotor_joint(3);
*/


include <../../parameters.scad>

module screw_nut_hole(thickness=20) {
    difference() {
        translate([(ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), (ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), 0])
            cylinder(d=M4_screw_diameter, h=thickness+0.1, center=true, $fn=20);
        translate([(ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), (ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), thickness/2+.01])
            cylinder(d=M4_screw_diameter, h=1, $fn=20); 
    }

    hull() {
        translate([(ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), (ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), 0])
            rotate([0, 0, 30])
                cylinder(d=M4_nut_diameter, h=M4_nut_height, $fn=6, center=true);

        translate([(ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), (ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter)+M4_screw_diameter*2, 0])
            cube([M4_nut_pocket, M4_screw_diameter, M4_nut_height], center=true);
    }
}

module rotor_joint(mode, thickness=10) {
    screw_nut_hole(thickness=thickness);

    difference() {
        rotor_joint_plate(thickness=thickness);

        rotor_joint_holes(mode=mode, thickness=thickness);
    }
}

module rotor_joint_plate(thickness=10) {
    minkowski() {
            cube([ALU_profile_width+ALU_profile_holder_wall_thickness*2+M4_screw_diameter*2, ALU_profile_width+ALU_profile_holder_wall_thickness*2+M4_screw_diameter*2, thickness/2], center=true);
            cylinder(d=M4_nut_diameter*2, h=thickness/2, $fn=70, center=true);
    }
}

module rotor_joint_holes(mode, thickness=10) {
    if(mode == 1) {
        for(i = [0:90:360]) {
            rotate([0, 0, i])
                screw_nut_hole();
        }
    }
    else if(mode == 2) {
        for(i = [0:90:360])
        rotate([0, 0, i])
        translate([(ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), (ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), 0]) {
            union() {
                cylinder(d=M4_screw_diameter, h=thickness+0.1, $fn=20, center=true);
                
                translate([0, 0, thickness*2+.01])
                cylinder(d=M4_nut_diameter*2+1, h=30, $fn=100, center=true);
            }
        }
    }
    else if(mode == 3) {
        for(i = [0:90:360]) {
            rotate([0, 0, i])
            translate([(ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), (ALU_profile_width/2+ALU_profile_holder_wall_thickness+M4_screw_diameter), 0]) {
                cylinder(d=M4_screw_diameter, h=thickness, $fn=20, center=true);
                translate([0, 0, thickness/2-M4_nut_height+0.1])
                cylinder(d=M4_nut_diameter, h=M4_nut_height+0.1, $fn=6);
            }
        }
    }
}

rotor_joint(2);