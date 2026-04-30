use <./Utilities/2D_Shapes.scad>;

basketDiameter = 31;
bikeDiameter = 31;
length = 10;
thickness = 20;
height = 10;

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
                square([extendedShaftLength, wallThickness*1.8], center=true);
            translate([primaryOuterRadius + shaftLength + secondaryOuterRadius, 0, 0])
                ring2D(secondaryDiameter / 2, secondaryOuterRadius, 100);
        }
        union() {
            translate([fullLength/4, -largestRadius/2, 0]) 
                square([fullLength + wallThickness*5, largestRadius], center = true);
            // translate([-primaryDiameter + wallThickness/2, wallThickness/2, wallThickness/2])
            //     #circle(r = screwSize/2, $fn=100);
        }
    }
}

/*
    primaryDiameter - Inner diameter of the first ring
    secondaryDiameter - Inner diameter of the second ring
    shaftLength - Length of connection between the rings
    wallThickness - Thickness of the rings and the height of the final 3d shape
    screwSize - Size (mm) of the screws that will be used for the latch and hinge
*/
module topHalf(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, height, screwSize) {
    fullLength = primaryDiameter + secondaryDiameter + shaftLength + wallThickness * 2;
    primaryMidRadius = primaryDiameter/2 + wallThickness-1;
    secondaryMidRadius = secondaryDiameter/2 + wallThickness - 1;
    secondaryCenterX = primaryDiameter/2 + shaftLength + wallThickness*2 + secondaryDiameter/2;
    latchTolerance = 0.5;

    // hinge 1/4 wallThickness - 3/4 wallThickness
    translate([0,0, height/4 + latchTolerance])
        linear_extrude(height = height/2 - latchTolerance * 2) 
            hinge2D(
                mountCenter = [secondaryCenterX + cos(10) * secondaryMidRadius, sin(10) * secondaryMidRadius, 0],
                screwCenter = [secondaryCenterX + secondaryDiameter/2 + wallThickness + screwSize * 2, 0, 0],
                screwSize = screwSize);

    linear_extrude(height = height) 
        mainBody2D(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize = screwSize);
    
    // latch 0-1/4 wall thickness and 3/4-1 wallThickness
    linear_extrude(height = height/4 - latchTolerance)
        hinge2D(
            mountCenter = [-primaryMidRadius * cos(10), primaryMidRadius * sin(10), 0],
            screwCenter = [-(primaryDiameter/2 + wallThickness + screwSize * 2), screwSize * 2, 0],
            screwSize = screwSize
        );
    translate([0, 0, height * 3/4 + latchTolerance])
        linear_extrude(height = height/4 - latchTolerance)
            hinge2D(
                mountCenter = [-primaryMidRadius * cos(10), primaryMidRadius * sin(10), 0],
                screwCenter = [-(primaryDiameter/2 + wallThickness + screwSize * 2), screwSize * 2, 0],
                screwSize = screwSize
            );
}

/*
    primaryDiameter - Inner diameter of the first ring
    secondaryDiameter - Inner diameter of the second ring
    shaftLength - Length of connection between the rings
    wallThickness - Thickness of the rings and the height of the final 3d shape
    screwSize - Size (mm) of the screws that will be used for the latch and hinge
*/
module bottomHalf(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, height, screwSize) {
    fullLength = primaryDiameter + secondaryDiameter + shaftLength + wallThickness * 2;
    primaryMidRadius = primaryDiameter/2 + wallThickness-1;
    midRadius = (secondaryDiameter/2 + wallThickness - 1);
    secondaryCenterX = primaryDiameter/2 + shaftLength + wallThickness*2 + secondaryDiameter/2;
    latchTolerance = 0.5;

    linear_extrude(height = height/4 - latchTolerance) 
        hinge2D(
            mountCenter = [secondaryCenterX + cos(10) * midRadius, sin(10) * midRadius, 0],
            screwCenter = [secondaryCenterX + secondaryDiameter/2 + wallThickness + screwSize * 2, 0, 0],
            screwSize = screwSize);
    translate([0,0,height * 3/4 + latchTolerance])
        linear_extrude(height = height/4 - latchTolerance) 
            hinge2D(
                mountCenter = [secondaryCenterX + cos(10) * midRadius, sin(10) * midRadius, 0],
                screwCenter = [secondaryCenterX + secondaryDiameter/2 + wallThickness + screwSize * 2, 0, 0],
                screwSize = screwSize);
    linear_extrude(height = height) 
        mainBody2D(primaryDiameter, secondaryDiameter, shaftLength, wallThickness, screwSize = screwSize);

    // latch 0-1/4 wall thickness and 3/4-1 wallThickness
    linear_extrude(height = height/4 - latchTolerance)
        hinge2D(
            mountCenter = [-primaryMidRadius * cos(10), primaryMidRadius * sin(10), 0],
            screwCenter = [-(primaryDiameter/2 + wallThickness + screwSize * 2), screwSize * 2, 0],
            screwSize = screwSize
        );
    translate([0, 0, height * 3/4 + latchTolerance])
        linear_extrude(height = height/4 - latchTolerance)
            hinge2D(
                mountCenter = [-primaryMidRadius * cos(10), primaryMidRadius * sin(10), 0],
                screwCenter = [-(primaryDiameter/2 + wallThickness + screwSize * 2), screwSize * 2, 0],
                screwSize = screwSize
            );
}

topHalf(
    primaryDiameter = basketDiameter,
    secondaryDiameter = bikeDiameter,
    shaftLength = length,
    wallThickness = thickness,
    height = height,
    screwSize = 3
);

translate([0,-20,thickness])
    rotate([180,0,0])
        bottomHalf(
            primaryDiameter = basketDiameter,
            secondaryDiameter = bikeDiameter,
            shaftLength = length,
            wallThickness = thickness,
            height = height,
            screwSize = 3
        );

translate([-60, -3, 0])
    linear_extrude(height = thickness / 2 - 1)
        latch2D(
            screwSpacing = 3*4,
            wallThickness = 2,
            screwDiameter = 3,
            handleSize = 6
        );