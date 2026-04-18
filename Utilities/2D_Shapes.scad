module ring2D(innerRadius, outerRadius, fn) {
    $fn = fn;
    difference() {
        circle(outerRadius);
        circle(innerRadius);
    }
}


/*
    Taken from RuggedBoxV1 and tweaked a little bit for my usage
    latchSupportTotalWidth - 
    latchSupportWidth - 
    latchScrewPositionPct -
    latchSupportRadius - 
    latchTolerance - 
*/
module standardLatch2D(
    latchSupportTotalWidth,
    latchSupportWidth,
    latchScrewPositionPct,
    latchSupportRadius,
    latchTolerance,
    openingTolerance,
    screwRadius
) {
    rimWidthMm = 0;
    rimHeightMm = 0;
    latchInsideWidthMm = latchSupportTotalWidth - (2*latchSupportWidth) - (2*latchTolerance);

    // rimChamferPositionAdj = rimWidthMm * tan(67.5);
    rimChamferPositionAdj = 5 * tan(67.5);
    rimChamferRadius = sqrt(rimChamferPositionAdj^2+rimChamferPositionAdj^2);
  
    //rimCutoutPositionAdj = rimChamferPositionAdj+rimHeightMm+(openingTolerance/2)+1;
    //rimCutoutRadius = sqrt(rimCutoutPositionAdj^2+rimCutoutPositionAdj^2);

    difference() {
        union() {
            circle(latchSupportRadius, $fn=8);
            translate([0,-10-openingTolerance])
                circle(latchSupportRadius, $fn=8);
            translate([-latchSupportRadius,-10-openingTolerance])
                square([latchSupportRadius*2, 10+openingTolerance]);
         
            translate([0,-10-openingTolerance])
                rotate(-(90-10))
                    translate([0,3])
                        union() {
                            latchOpenerLength = (latchSupportRadius-3)*2;
                            square([latchOpenerLength,latchSupportRadius-3]);
                            translate([latchOpenerLength, (latchSupportRadius-3)/2]) circle((latchSupportRadius-3)/2, $fn=8);
                        }
            
        }
        // Cutout the screw holes
        circle(screwRadius, $fn=100);
        translate([0,-10-openingTolerance])
            circle(screwRadius, $fn=100);
        
        // translate([0,-10-openingTolerance]) 
        //     rotate(-45)
        //         translate([-latchSupportRadius*4,-3])
        //             square([latchSupportRadius*4,3*2]);
        translate([0,-10-openingTolerance]) 
            rotate(30)
                translate([-latchSupportRadius*4,0])
                    square([latchSupportRadius*4,8]);

    }

}

module hinge2D(mountCenter, mountCenter2, screwCenter, screwSize, fn) {
    innerFn = is_undef(fn) ? 100 : fn;
    innerMountCenter = is_undef(mountCenter) ? [0,0,0] : mountCenter;
    r = screwSize * 0.8;
    if (is_undef(mountCenter2)) {
        difference() {
            hull() {
                translate([innerMountCenter[0], innerMountCenter[1], innerMountCenter[2]]) circle(r, $fn=innerFn);
                translate([screwCenter[0], screwCenter[1], screwCenter[2]]) circle(r, $fn=innerFn);
            }
            translate([screwCenter[0], screwCenter[1], screwCenter[2]]) circle(screwSize/2, $fn=innerFn);
        }
    } else {
        difference() {
            hull() {
                translate([innerMountCenter[0], innerMountCenter[1], innerMountCenter[2]]) circle(r, $fn=innerFn);
                translate([mountCenter2[0], mountCenter2[1], mountCenter2[2]]) circle(r, $fn=innerFn);
                translate([screwCenter[0], screwCenter[1], screwCenter[2]]) circle(screwSize, $fn=innerFn);
            }
            translate([screwCenter[0], screwCenter[1], screwCenter[2]]) circle(screwSize/2, $fn=innerFn);
        }
    }
}