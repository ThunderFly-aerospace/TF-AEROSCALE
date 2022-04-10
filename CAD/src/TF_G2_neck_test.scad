use <TF-G2-rotor-neck.scad>


screw_offset=rotorBearingNeck_screw_offset();
screw_angle=rotorBearingNeck_screw_angle();

difference()
{
    union()
    {
        translate([0,0,-3])
            cube([25,25,6], center=true);
                
    }
    
    rotorBearingNeckHousing();
    
    /*translate([0,-10,-2+0.005])
        cube([20.1,20,4.01], center=true);*/  
        
        
    for(i=[-1,1])  
        translate([i*(screw_offset),-screw_offset,0])
            rotate([screw_angle,0,0])
                translate([0,0,-5.5-10])
                    cylinder(d=5.6,h=10, $fn=6);
}

for(i=[-1,1])  
    translate([i*(screw_offset),-screw_offset,0])
        rotate([screw_angle,0,0])
            translate([0,0,-5.5])
                cylinder(d=5.6,h=0.2, $fn=6);

                      
