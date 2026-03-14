// This is copying code from RuggedBoxV1 and trying to reduce it t ocreate a little "mount" to attach a kids bike to an adult after dropoff

// leftover global variables
polyLvl = 8;
numberOfLatches = 1;
boxBottomHeightZMm = 20;
boxLengthYMm = 20;
boxTopHeightZMm = 20;
mountWidth = 10;
boxWidthXMm = mountWidth;
rimWidthMm = 5;
rimHeightMm = 5;
// The tolerance of the gaps between the latch and the latch mount so the latch can move.
latchToloerance = 0.2; // .05
// The radius of hinge screw hole does not get threaded and allows the latch to pivot/rotate. 3mmScrew=1.7 
latchScrewLargeRadiusMm = 1.7; // .05
// The radius of hinge screw hole gets threaded and holds the latch together. 3mmScrew=1.5 
latchScrewSmallRadiusMm = 1.45; // .05
// This is the angle of the latch opener tab. The valid values are between 0 and 45 seem to be okay values.
latchOpenerAngle = 10; //[0:1:45]
// Controls the length of the tab that allows you to open the latch. 1 is pretty short, 2 is pretty long. It's easy to make this too short or too long... Somewhere between 1 and 2 seems like a good value.
latchOpenerLengthMultiplier = 1.4; //[.5:.1:3]

// Min: 10, Max: 50. The shallower the angle the Harder it will be to close, at 10 you probably won't be able to bend the latch enough to close it, as you approach 50, it may not hold very well.
latchClipCutoutAngle = 25; //[10:1:50]

// The chamfer radius of the boxes corners.  (NOTE1: the floor/top radius is slightly differentthan the sides to eliminate the need for supports. NOTE2: If you want square inside corners, the boxWallWidthMm must be >= the boxChamferRadiusMm.)
boxChamferRadiusMm = 4; // .1

// The width on the box wall and floor.  (NOTE: If you want square inside corners, the boxWallWidthMm must be > the  boxChamferRadiusMm.)
boxWallWidthMm = 3.0; // [1:0.1:10]

openingTolerance = 0.1;
viewBoxClosed = true;

outerCaseSectionHeight = 8;

outerLatchSupportTotalWidth = 12;
outerLatchSupportWidth = 3;
outerLatchScrewPositionPct = 70;
outerTopCaseHeight = 10;
outerBottomCaseHeight = 15;
outerLatchSupportRadius = 4;
outerLatchToloerance = 0.5;

module StandardLatch(latchSupportTotalWidth, latchSupportWidth, latchScrewPositionPct, topCaseHeight, bottomCaseHeight, latchSupportRadius, latchToloerance) {
    assert(latchSupportTotalWidth - (2*latchSupportWidth) - (2*latchToloerance) > 0, "Latch support radius, width or tolerance invalid");
    latchPolyLvl = polyLvl <= 8 ? 8 : polyLvl;
    echo(latchSupportTotalWidth, 2*latchSupportWidth, 2*latchToloerance);
    latchInsideWidthMm = latchSupportTotalWidth - (2*latchSupportWidth) - (2*latchToloerance);

    latchSpacing = (mountWidth - (numberOfLatches*latchSupportTotalWidth)) / (numberOfLatches + 1);

    echo(viewBoxClosed);
    // StandardLatch2D(latchSupportTotalWidth, latchSupportWidth, latchScrewPositionPct, topCaseHeight, bottomCaseHeight, latchSupportRadius, latchToloerance);
                    

    translate([mountWidth,0,0])
    rotate([0,0,180])
    translate([0,-boxLengthYMm,0]) // add back in the rim width
    translate([0,rimWidthMm,0]) // add back in the rim width
        for (h =[1:numberOfLatches]) { 
            
            actualLatchCenterOffsetMm = 
                h < (numberOfLatches+1)/2 
                    ? -latchCenterOffsetMm 
                    : h == (numberOfLatches+1)/2
                        ? 0
                        : latchCenterOffsetMm;
            latchX = (h*latchSpacing)+((h-1)*latchSupportTotalWidth)+latchSupportWidth+latchToloerance+actualLatchCenterOffsetMm;
            
            if(viewBoxClosed) {
                // Generate the latches as if they are connected to the case
                translate([latchX,boxLengthYMm+latchSupportRadius,(openingTolerance)+(boxTopHeightZMm*(latchScrewPositionPct/100))]) 
                    rotate([90,0,90])
                        linear_extrude(latchInsideWidthMm)
                            StandardLatch2D(latchSupportTotalWidth, latchSupportWidth, latchScrewPositionPct, topCaseHeight, bottomCaseHeight, latchSupportRadius, latchToloerance);
            }
            else {
                echo("view open box")
                // Generate the latches for printing
                echo([latchSupportRadius*4*h,boxLengthYMm+bottomCaseHeight+(topCaseHeight*2)+(latchSupportRadius*2),0]);
                echo(latchInsideWidthMm);
                translate([latchSupportRadius*4*h,boxLengthYMm+bottomCaseHeight+(topCaseHeight*2)+(latchSupportRadius*2),0])
                    linear_extrude(latchInsideWidthMm)
                        StandardLatch2D(latchSupportTotalWidth, latchSupportWidth, latchScrewPositionPct, topCaseHeight, bottomCaseHeight, latchSupportRadius, latchToloerance);
            }
        }
}

module StandardLatch2D(latchSupportTotalWidth, latchSupportWidth, latchScrewPositionPct, topCaseHeight, bottomCaseHeight, latchSupportRadius, latchToloerance) {
    latchPolyLvl = polyLvl <= 8 ? 8 : polyLvl;
    
    latchInsideWidthMm = latchSupportTotalWidth - (2*latchSupportWidth) - (2*latchToloerance);

    latchSpacing = (boxWidthXMm - (numberOfLatches*latchSupportTotalWidth)) / (numberOfLatches + 1);

    rimChamferPositionAdj = rimWidthMm * tan(67.5);
    rimChamferRadius = sqrt(rimChamferPositionAdj^2+rimChamferPositionAdj^2);
  
    //rimCutoutPositionAdj = rimChamferPositionAdj+rimHeightMm+(openingTolerance/2)+1;
    //rimCutoutRadius = sqrt(rimCutoutPositionAdj^2+rimCutoutPositionAdj^2);

    
    rimCutoutPositionAdj = rimWidthMm;
    rimCutoutRadius = (rimWidthMm*1.5)+rimHeightMm;

    difference() {
        union() {
            circle(latchSupportRadius, $fn=latchPolyLvl);
            translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) circle(latchSupportRadius, $fn=latchPolyLvl);
            translate([-latchSupportRadius,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) square([latchSupportRadius*2, (boxTopHeightZMm*(latchScrewPositionPct/100))+(boxBottomHeightZMm*(latchScrewPositionPct/100))+openingTolerance]);
         
        translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance])   
            rotate(-(90-latchOpenerAngle))
                translate([0,latchScrewLargeRadiusMm])
                    union() {
                        latchOpenerLength = (latchSupportRadius-latchScrewLargeRadiusMm)*2;
                        square([latchOpenerLength*latchOpenerLengthMultiplier,latchSupportRadius-latchScrewLargeRadiusMm]);
                        translate([latchOpenerLength*latchOpenerLengthMultiplier, (latchSupportRadius-latchScrewLargeRadiusMm)/2]) circle((latchSupportRadius-latchScrewLargeRadiusMm)/2, $fn=latchPolyLvl);
                    }
            
        }
        // Cutout the screw holes
        circle(latchScrewLargeRadiusMm, $fn=100);
            translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) circle(latchScrewLargeRadiusMm, $fn=100);
        
        
        translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) 
            rotate(-45)
                translate([-latchSupportRadius*4,-latchScrewLargeRadiusMm])
                    square([latchSupportRadius*4,latchScrewLargeRadiusMm*2]);
        translate([0,-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance]) 
            rotate(latchClipCutoutAngle)
                translate([-latchSupportRadius*4,0])
                    square([latchSupportRadius*4,boxTopHeightZMm]);
        
        
        translate([-latchSupportRadius-rimCutoutPositionAdj,(-(boxTopHeightZMm*(latchScrewPositionPct/100))-(boxBottomHeightZMm*(latchScrewPositionPct/100))-openingTolerance)/2]) 
        circle(r = rimCutoutRadius, $fn=latchPolyLvl*2);

    }

}

module LatchMount(latchSupportTotalWidth, latchSupportWidth, latchScrewPositionPct, caseSectionHeight, latchSupportRadius, latchToloerance) {
    
    latchPolyLvl = polyLvl <= 8 ? 8 : polyLvl;
    
    latchInsideWidthMm = latchSupportTotalWidth - (2*latchSupportWidth) - (2*latchToloerance);

    latchSpacing = (boxWidthXMm - (numberOfLatches*latchSupportTotalWidth)) / (numberOfLatches + 1);


    translate([boxWidthXMm,0,0])
    rotate([0,0,180])
    translate([0,-boxLengthYMm,0]) // add back in the rim width
        for (h =[1:numberOfLatches]) { 
            
            actualLatchCenterOffsetMm = 
                h < (numberOfLatches+1)/2 
                    ? -latchCenterOffsetMm 
                    : h == (numberOfLatches+1)/2
                        ? 0
                        : latchCenterOffsetMm;
            latchMountX = (h*latchSpacing)+((h-1)*latchSupportTotalWidth)+latchSupportWidth+latchToloerance+actualLatchCenterOffsetMm;
            
            
            difference () {
                union() {
                    // Main latch cylinder
                    translate([latchMountX-(latchSupportWidth+latchToloerance),(boxLengthYMm+latchSupportRadius)+rimWidthMm,-((latchScrewPositionPct/100)*caseSectionHeight)]) rotate([0,90,0])
                        cylinder(latchSupportWidth,latchSupportRadius,latchSupportRadius, $fn=latchPolyLvl);
                    translate([latchMountX+latchInsideWidthMm+latchToloerance,(boxLengthYMm+latchSupportRadius)+rimWidthMm,-((latchScrewPositionPct/100)*caseSectionHeight)]) rotate([0,90,0])
                        cylinder(latchSupportWidth,latchSupportRadius,latchSupportRadius, $fn=latchPolyLvl);
                    

                    translate([latchMountX-latchToloerance,boxLengthYMm+(latchSupportRadius*2)+rimWidthMm,-((latchScrewPositionPct/100)*caseSectionHeight)]) rotate([90,0,-90]) linear_extrude(latchSupportWidth) square([(latchSupportRadius*2)+rimWidthMm, ((latchScrewPositionPct/100)*caseSectionHeight)]);
                    translate([latchMountX+latchInsideWidthMm+latchToloerance+latchSupportWidth,boxLengthYMm+(latchSupportRadius*2)+rimWidthMm,-((latchScrewPositionPct/100)*caseSectionHeight)]) rotate([90,0,-90]) linear_extrude(latchSupportWidth) square([(latchSupportRadius*2)+rimWidthMm, ((latchScrewPositionPct/100)*caseSectionHeight)]);
                    
                    // ribs
                    translate([latchMountX-latchToloerance,boxLengthYMm-(boxChamferRadiusMm),0]) rotate([90,0,-90]) linear_extrude(latchSupportWidth) Wall2D(boxWallWidthMm, (rimWidthMm*2), caseSectionHeight, false);
                    translate([latchMountX+latchInsideWidthMm+latchToloerance+latchSupportWidth,boxLengthYMm-(boxChamferRadiusMm),0]) rotate([90,0,-90]) linear_extrude(latchSupportWidth) Wall2D(boxWallWidthMm, (rimWidthMm*2), caseSectionHeight, false);
                    
                    // Attach the hinge to the top
                    adjustment = sqrt((latchSupportRadius^2)/2);
                    hingeConnectorHeight = sqrt(latchSupportRadius^2+latchSupportRadius^2) + (latchSupportRadius-adjustment);    
                    
                    difference() {
                        union() {
                            translate([0, adjustment+rimWidthMm, -(latchSupportRadius-adjustment)-(2*adjustment)-((latchScrewPositionPct/100)*caseSectionHeight)])
                                translate([latchMountX-(latchSupportWidth+latchToloerance),(boxLengthYMm+latchSupportRadius),latchSupportRadius])
                                    rotate([45,0,0])
                                        // TODO: calculate the langth of the attachment piece, don't just use 6 :-/
                                        translate([0,-latchSupportRadius*6,0])
                                            cube([latchSupportWidth, latchSupportRadius*6, hingeConnectorHeight]);
                            translate([0, adjustment+rimWidthMm, -(latchSupportRadius-adjustment)-(2*adjustment)-((latchScrewPositionPct/100)*caseSectionHeight)])
                                translate([latchMountX+latchInsideWidthMm+latchToloerance,(boxLengthYMm+latchSupportRadius),latchSupportRadius])
                                    rotate([45,0,0])
                                        // TODO: calculate the langth of the attachment piece, don't just use 6 :-/
                                        translate([0,-latchSupportRadius*6,0])
                                            cube([latchSupportWidth, latchSupportRadius*6, hingeConnectorHeight]);
                        }                   
                        // TODO: fix this cutout as it doesn't work when the case is very curved!!!
                        //translate([0,boxLengthYMm-boxWallWidthMm-boxLengthYMm,-caseSectionHeight])
                        //    cube([boxWidthXMm,boxLengthYMm,caseSectionHeight]);
                    }
                };
                // Cut the screw hole out
                translate([latchMountX-((latchSupportWidth+latchToloerance)+.1),boxLengthYMm+latchSupportRadius+rimWidthMm,-((latchScrewPositionPct/100)*caseSectionHeight)]) rotate([0,90,0])
                    cylinder(latchInsideWidthMm+(latchSupportWidth*2)+(latchToloerance*2)+.2,latchScrewSmallRadiusMm,latchScrewSmallRadiusMm, $fn=100);
            }
    }
}

// TODO: modify this so the bottom corner angle always starts at 60+ degrees.  be careful here so we can honor the poly counts and still connect correctly to the sides and bottom.
module Wall2D(wallThickness, additionalWallThickness, height, isRimIncluded, isForRotation) {
    
    floorChamferRadius = sqrt(boxChamferRadiusMm^2+boxChamferRadiusMm^2);
    chamferTrimAdj = sqrt(((floorChamferRadius-wallThickness)^2)/2);
    
    //floorAddition = sqrt(floorChamferRadius^2 - boxChamferRadiusMm^2);
    //floorAddition = boxChamferRadiusMm/2;
    floorAddition = (boxChamferRadiusMm*2)-floorChamferRadius;
    
    additionCount = ceil(additionalWallThickness/wallThickness);
    
    difference() {
        // make it wider if asked for
        for(cnt = [0:additionCount]) {
            additionXAdj = 
                (cnt == additionCount && ((additionalWallThickness % wallThickness) != 0)) 
                    ? ((cnt-1)*wallThickness)+(additionalWallThickness % wallThickness)
                    : cnt*wallThickness;
            
            translate([-boxChamferRadiusMm-(additionXAdj),0])
                union() {
                    // Add the rim
                    if(isRimIncluded) {
                        rimChamferPositionAdj = rimWidthMm * tan(67.5);
                        rimChamferRadius = sqrt(rimChamferPositionAdj^2+rimChamferPositionAdj^2);
                        
                        
                        difference() {
                            // 45 degree angle chamfer
                            translate([0,-rimHeightMm]) circle(r = rimWidthMm, $fn=4);
                            translate([-rimWidthMm-.1,-rimHeightMm]) square([(rimWidthMm*2)+.2, rimWidthMm+.1]);
                            translate([0,-rimHeightMm-rimWidthMm-.1]) square([(rimWidthMm*2)+.2, (rimWidthMm*2)+.2]);
                            
                            // This is the chamfer that allows the poly level to change.  No longer used... didn't like it
                            //translate([rimChamferPositionAdj,-rimHeightMm]) circle(r = rimChamferRadius, $fn=polyLvl*2);
                            //translate([rimChamferPositionAdj-rimChamferRadius-.1,-0]) square([(rimChamferRadius*2)+.2, rimChamferRadius+.1]);
                            //translate([0,-(rimChamferRadius*2)-.2]) square([(rimChamferRadius*2)+.2, (rimChamferRadius*2)+.2]);
                        }
                        
                        translate([-rimWidthMm,-rimHeightMm]) square([rimWidthMm,rimHeightMm]);
                    }

                    translate([0,-height + boxChamferRadiusMm]) square([wallThickness, height - boxChamferRadiusMm]);

                    //translate([boxChamferRadiusMm-floorAddition, -height]) square([floorAddition, wallThickness]);
                    translate([boxChamferRadiusMm-floorAddition, -height]) square([floorAddition, wallThickness]);

                    translate([floorChamferRadius, -height + boxChamferRadiusMm]) 
                        difference() {
                            translate([0,0]) circle(r = floorChamferRadius, $fn = polyLvl*2);
                            translate([0,0]) circle(r = (floorChamferRadius-wallThickness), $fn = polyLvl*2);
                            translate([-floorChamferRadius - .1,0]) square([(floorChamferRadius*2)+.2, floorChamferRadius + .1]);
                            if(wallThickness <= boxChamferRadiusMm) {
                                translate([-chamferTrimAdj,-floorChamferRadius - .1]) square([floorChamferRadius + chamferTrimAdj + .1, (floorChamferRadius*2)+.2]);
                            }
                            translate([-floorChamferRadius - .1,-(boxChamferRadiusMm*2)]) square([(floorChamferRadius*2)+.2, boxChamferRadiusMm]);
                        };
                }
        }      
        
        // NOT sure what this was for :-/
        //translate([(-wallThickness-additionalWallThickness)+chamferTrimAdj,-height]) square([(wallThickness+additionalWallThickness)-chamferTrimAdj, wallThickness]);
        
        // If we are rotating, we need to cut off any execess floor or wall on the other side of the y axis
        if(isForRotation) {
            translate([0,-(height*2)]) square([wallThickness*20, (height*2)+.2]);
        }
    }
}

LatchMount(
    latchSupportTotalWidth = outerLatchSupportTotalWidth,
    latchSupportWidth = outerLatchSupportWidth,
    latchScrewPositionPct = outerLatchScrewPositionPct,
    caseSectionHeight = outerCaseSectionHeight,
    latchSupportRadius = outerLatchSupportRadius,
    latchToloerance = outerLatchToloerance);

StandardLatch(
    latchSupportTotalWidth = outerLatchSupportTotalWidth,
    latchSupportWidth = outerLatchSupportWidth,
    latchScrewPositionPct = outerLatchScrewPositionPct,
    topCaseHeight = outerTopCaseHeight,
    bottomCaseHeight = outerBottomCaseHeight,
    latchSupportRadius = outerLatchSupportRadius,
    latchToloerance = outerLatchToloerance);