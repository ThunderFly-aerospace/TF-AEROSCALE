
bearing_outer_diameter=10.2;
Bwall=1.6;
bearing_shaft_length=20.6;
bearing_shaft_shift=2.6;
bearing_inner_diameter=7;
bearing_thickness=4;

connector_w=22;
connector_t=21;
connector_h=4;
connector_hole_w=12;

screw_angle=10;
screw_offset=5.6;
M3_screw_diameter=3.2;
M3_head_diameter=5.5;


function rotorBearingNeck_screw_offset() = screw_offset;
function rotorBearingNeck_screw_angle() = screw_angle;
function rotorBearingNeck_t()=connector_t;
function rotorBearingNeck_h()=bearing_shaft_length+bearing_shaft_shift;
function rotorBearingNeck_d()=bearing_outer_diameter+2*Bwall;

module rotorBearingNeck()
{
    difference()
    {
        union()
        {
            translate([0,0,-connector_h/2])
                cube([connector_w,connector_t,connector_h], center=true);
                
            cylinder(d=bearing_outer_diameter+2*Bwall,h=bearing_shaft_length+bearing_shaft_shift, $fn=120);
        }
        
        //ax hole
        translate([0,0,bearing_shaft_shift+bearing_thickness+0.5])
            cylinder(d=bearing_inner_diameter,h = 100, $fn = 120);
        
        //top bearing
        translate([0,0,bearing_shaft_length+bearing_shaft_shift-bearing_thickness])
            cylinder(d = bearing_outer_diameter, h = bearing_thickness + 0.005, $fn =120);
            
        //bottom bearing
        translate([0, 0, bearing_shaft_shift + bearing_thickness-100])    
            cylinder(d = bearing_outer_diameter, h = 100, $fn=120);
        
        //sešikmení
        translate([0,connector_t/2,0])
            rotate([45,0,0])
                cube([connector_w+0.1,2*connector_h/sqrt(2),2*connector_h/sqrt(2)], center=true);
                
        //dira v sešikmeni
        translate([0,connector_t-connector_h+0.05,0])
                cube([connector_hole_w,connector_t,3*connector_h], center=true);        
        
        //šroubky
        translate([0,-screw_offset])
            rotate([screw_angle,0,0])
            {
                for(i=[-1,1])
                {
                    translate([i*screw_offset,0,0])
                    {
                        cylinder(d = M3_screw_diameter, h = 100, center=true, $fn =120);
                        translate([0,0,-1])
                            cylinder(d = M3_head_diameter, h = 100, $fn =120);
                    }
                }
            }
        
    }
}

module rotorBearingNeckHousing()
{
    difference()
    {
        translate([0,-connector_h/sqrt(2),-0.25*connector_h])
            cube([connector_w+0.1,connector_t+0.1+2*connector_h/sqrt(2),1.5*connector_h], center=true);
        
        translate([0,connector_t/2,0])
            rotate([45,0,0])
                cube([connector_w+0.2,2*connector_h/sqrt(2),20*connector_h/sqrt(2)], center=true);
                
        translate([0,connector_t-connector_h+0.1,0])
                cube([connector_hole_w-0.1,connector_t,3*connector_h], center=true);        
    }
    
    translate([0,-screw_offset,0])
    rotate([screw_angle,0,0])
    {
        for(i=[-1,1])
        {
            translate([i*screw_offset,0,0])
            {
                cylinder(d = M3_screw_diameter, h = 100, center=true, $fn =120);
                translate([0,0,-1])
                    cylinder(d = M3_head_diameter, h = 100, $fn =120);
            }
        }
    }

}

//rotorBearingNeckHousing();

rotorBearingNeck();