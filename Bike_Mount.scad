use <./Utilities/2D_Shapes.scad>;

basketDiameter = 31;
bikeDiameter = 31;
length = 10;
thickness = 5;

module mainBody2D(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize) {
    primaryOuterRadius = primaryDiameter/2 + wallThickness;
    secondaryOuterRadius = secondaryDiameter/2 + wallThickness;
    largestRadius = primaryOuterRadius > secondaryOuterRadius ? primaryOuterRadius : secondaryOuterRadius;

    extendedShaftLength = shaftLength + wallThickness/2;

    fullLength = primaryOuterRadius * 2 + secondaryOuterRadius * 2 + shaftLength;

    difference() {
        union(){
            ring2D(primaryDiameter / 2, primaryOuterRadius, 100);
            translate([extendedShaftLength / 2 + primaryOuterRadius - wallThickness / 4, 0, 0])
                square([extendedShaftLength, wallThickness*2], center=true);
            translate([primaryOuterRadius + shaftLength + secondaryOuterRadius, 0, 0])
                ring2D(secondaryDiameter / 2, secondaryOuterRadius, 100);
            hull() {
                translate([-primaryDiameter + wallThickness/2, wallThickness/2, wallThickness/2])
                    circle(r=wallThickness/3*2, $fn = 100);
                translate([-primaryDiameter/3*2, wallThickness, wallThickness/2])
                    square([wallThickness/3*2,wallThickness/3*2], center=true);
            }
        }
        union() {
            translate([fullLength/2 - primaryOuterRadius, -largestRadius/2, 0]) 
                square([fullLength + wallThickness, largestRadius], center = true);
            translate([-primaryDiameter + wallThickness/2, wallThickness/2, wallThickness/2])
                circle(r = screwSize/2, $fn=100);
        }
    }
}

// TODO: First attempt at a reusable 2D hinge. Really not reusable
/*
    screwSize - Diameter of the hole for the hinge
    r - Size of the circles used for creating the general shape of the hinge.
*/
module hinge2D(screwSize, r, fn) {
    innerFn = is_undef(fn) ? 100 : fn;
    difference() {
        hull() {
            // translate([r, r, 0]) circle(r/2, $fn=innerFn);
            translate([r*2, -r/2, 0]) circle(r/2, $fn=innerFn);
            translate([-r/2, r*1.5, 0]) circle(r, $fn=innerFn);
        }
        translate([-r/2, r*1.5, 0]) circle(screwSize/2, $fn=innerFn);
    }
    
}

/*
    primaryDiameter - Inner diameter of the first ring
    secondaryDiameter - Inner diameter of the second ring
    shaftLenght - Length of connection between the rings
    wallThickness - Thickness of the rings and the height of the final 3d shape
    screwSize - Size (mm) of the screws that will be used for the latch and hinge
*/
module topHalf(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize) {
    fullLength = primaryDiameter + secondaryDiameter + shaftLength + wallThickness * 2;

    translate([fullLength, screwSize * 2 , wallThickness/4])
        rotate([0, 0, 180])
            linear_extrude(height = wallThickness/2) 
                hinge2D(screwSize = screwSize, r = wallThickness - 1);
    linear_extrude(height = wallThickness) 
        mainBody2D(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize = screwSize);

}

/*
    primaryDiameter - Inner diameter of the first ring
    secondaryDiameter - Inner diameter of the second ring
    shaftLenght - Length of connection between the rings
    wallThickness - Thickness of the rings and the height of the final 3d shape
    screwSize - Size (mm) of the screws that will be used for the latch and hinge
*/
module bottomHalf(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize) {
    fullLength = primaryDiameter + secondaryDiameter + shaftLength + wallThickness * 2;

    translate([fullLength, screwSize * 2 , 0])
        rotate([0, 0, 180])
            linear_extrude(height = wallThickness/4) 
                hinge2D(screwSize = screwSize, r = wallThickness - 1);
    translate([fullLength, screwSize * 2 , wallThickness*3/4])
        rotate([0, 0, 180])
            linear_extrude(height = wallThickness/4) 
                hinge2D(screwSize = screwSize, r = wallThickness - 1);
    linear_extrude(height = wallThickness) 
        mainBody2D(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize = screwSize);
}

topHalf(
    primaryDiameter = basketDiameter,
    secondaryDiameter = bikeDiameter,
    shaftLength = length,
    wallThickness = thickness,
    screwSize = 3
);

translate([0,-20,thickness])
    rotate([180,0,0])
        bottomHalf(
            primaryDiameter = basketDiameter,
            secondaryDiameter = bikeDiameter,
            shaftLength = length,
            wallThickness = thickness,
            screwSize = 3
        );

standardLatch2D(
    latchSupportTotalWidth = thickness,
    latchSupportWidth = thickness - 2,
    latchScrewPositionPct = 80,
    latchSupportRadius = 4,
    latchTolerance = 0.1,
    openingTolerance = 0.1
);