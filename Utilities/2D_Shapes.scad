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
    openingTolerance
) {
    latchInsideWidthMm = latchSupportTotalWidth - (2*latchSupportWidth) - (2*latchTolerance);

    latchSpacing = (boxWidthXMm - (numberOfLatches*latchSupportTotalWidth)) / (numberOfLatches + 1);

    rimChamferPositionAdj = rimWidthMm * tan(67.5);
    rimChamferRadius = sqrt(rimChamferPositionAdj^2+rimChamferPositionAdj^2);
  
    //rimCutoutPositionAdj = rimChamferPositionAdj+rimHeightMm+(openingTolerance/2)+1;
    //rimCutoutRadius = sqrt(rimCutoutPositionAdj^2+rimCutoutPositionAdj^2);

    
    rimCutoutPositionAdj = rimWidthMm;
    rimCutoutRadius = (rimWidthMm*1.5)+rimHeightMm;

    difference() {
        union() {
            circle(latchSupportRadius, $fn=8);
            translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance])
                circle(latchSupportRadius, $fn=8);
            translate([-latchSupportRadius,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance])
                square([latchSupportRadius*2, (boxTopHeightZMm*(latchScrewPositionPct/100))+(boxBottomHeightZMm*(latchScrewPositionPct/100))+openingTolerance]);
         
            translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance])   
                rotate(-(90-latchOpenerAngle))
                    translate([0,latchScrewLargeRadiusMm])
                        union() {
                            latchOpenerLength = (latchSupportRadius-latchScrewLargeRadiusMm)*2;
                            square([latchOpenerLength*latchOpenerLengthMultiplier,latchSupportRadius-latchScrewLargeRadiusMm]);
                            translate([latchOpenerLength*latchOpenerLengthMultiplier, (latchSupportRadius-latchScrewLargeRadiusMm)/2]) circle((latchSupportRadius-latchScrewLargeRadiusMm)/2, $fn=8);
                        }
            
        }
        // Cutout the screw holes
        circle(latchScrewLargeRadiusMm, $fn=100);
        translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance])
            circle(latchScrewLargeRadiusMm, $fn=100);
        
        
        translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) 
            rotate(-45)
                translate([-latchSupportRadius*4,-latchScrewLargeRadiusMm])
                    square([latchSupportRadius*4,latchScrewLargeRadiusMm*2]);
        translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) 
            rotate(latchClipCutoutAngle)
                translate([-latchSupportRadius*4,0])
                    square([latchSupportRadius*4,boxTopHeightZMm]);
        
        
        translate([-latchSupportRadius-rimCutoutPositionAdj,(-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance)/2]) 
            circle(r = rimCutoutRadius, $fn=16);

    }

}