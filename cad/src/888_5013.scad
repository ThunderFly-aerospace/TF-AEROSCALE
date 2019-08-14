include <../parameters.scad>

height = 2;

module 888_5013() {
    difference() {
        union() {
            cylinder(d=KSTM08_ball_hole_diameter, h=KSTM08_ball_width/2+height, $fn=160);
            cylinder(d=KSTM08_ball_hole_diameter+2, h=height, $fn=160);
        }
        cylinder(d=M6_screw_diameter, h=1000, $fn=60, center=true);
    }
}

888_5013();