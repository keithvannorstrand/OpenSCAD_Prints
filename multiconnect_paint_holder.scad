include <BOSL2/std.scad>
use <./Utilities/multiconnect_backplate.scad>;

$fn = 100;

multiconnectPaintHolder(
    backplateWidth = 150,
    backplateHeight = 90,
    paintDiameter = 34,
    paintRows = 2,
    rotateX = -60,
    subtractedSlots = 3
);
// xrot(-45) up(50) right(50)
    // paintHolder(
    //     diameter = 34,
    //     length = 150,
    //     wallThickness = 2,
    //     rotateX = -75
    // );

module multiconnectPaintHolder(
    backplateWidth,
    backplateHeight,
    paintDiameter,
    paintHolderWallThickness = 2,
    paintHolderLength = 50,
    paintRows = 3,
    rotateX = -60,
    subtractedSlots = 0) {
    multiconnectBackplate(
        backWidth = backplateWidth,
        totalHeight = backplateHeight,
        subtractedSlots = subtractedSlots
    );
    
    holderCount = floor(backplateWidth/(paintDiameter + paintHolderWallThickness));
    initialUp = (paintDiameter + paintHolderWallThickness * 2) * cos(90 - abs(rotateX));
    upTranslate = (paintDiameter + paintHolderWallThickness) / cos(90 - abs(rotateX));
    /*
    Figure out the number of vertical rows based on the backplateHeight. Probably based on the paintDiameter and the xrot sent to paintHolder
    paintHolderHeight = paintHolderLength * sin(-45);
    echo("paintHolderHeight", paintHolderHeight);
    rowCount = min(paintRows, backplateHeight);
    */
    for(holderRow = [0:1:paintRows - 1]) {
        for(holderNum = [0:1:holderCount - 1]){
            // if (holderRow % 2 == 0) {
                up(initialUp + holderRow * upTranslate)
                back(-2)
                right(holderNum * (paintDiameter + paintHolderWallThickness))
                xrot(rotateX)
                    paintHolder(
                        diameter = paintDiameter,
                        length = paintHolderLength,
                        wallThickness = paintHolderWallThickness,
                        holeSize = paintDiameter * 2 / 3
                    );
            // }
            // if (holderRow % 2 == 1) {
            //     xrot(rotateX) up(holderRow * upTranslate) right(holderNum * (paintDiameter + paintHolderWallThickness)) 
            //         paintHolder(
            //             diameter = paintDiameter,
            //             length = paintHolderLength,
            //             wallThickness = paintHolderWallThickness,
            //             holeSize = paintDiameter * 2 / 3
            //         );
            // }
        }
    }
}

module paintHolder(diameter, length, wallThickness, holeSize) {
    up(length/2) back(diameter/2 + wallThickness) right(diameter/2 + wallThickness) difference() {
        cyl(l=length, d = diameter + wallThickness * 2);
        up(wallThickness) cyl(l=length, d=diameter);
        down(wallThickness) cyl(l=length, d=holeSize);
    }
    
}