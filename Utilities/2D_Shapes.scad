module ring2D(innerRadius, outerRadius, fn) {
    $fn = fn;
    difference() {
        circle(outerRadius);
        circle(innerRadius);
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

// necessary latch parameters
// screwSpacing - distance between center of each screw.
// wallThickness - Something to determine how thick the wall is on the latch
// screwDiameter - 
// handleSize - Not sure on this but the size of the little tab to help open the latch
module latch2D(
    screwSpacing,
    wallThickness,
    screwDiameter,
    handleSize
) {
    screwLatchTolerance = 0.1;
    difference() {
        // main body
        union() {
            hull() {
                circle(r=screwDiameter/2 + wallThickness, $fn=50);
                translate([0, screwSpacing, 0])
                    circle(r=screwDiameter/2 + wallThickness, $fn=50);
            }
            translate([screwDiameter/2 * cos(-15), screwDiameter/2 * sin(-15) - handleSize, 0])
                square([wallThickness, handleSize]);
            translate([(screwDiameter/2 + wallThickness/2) * cos(-12), screwDiameter/2 - wallThickness - handleSize, 0])
                circle(r=wallThickness/2, $fn=100);
        }
        // screw hole
        circle(r=screwDiameter/2, $fn=100);
        // latching side hole
        translate([0, screwSpacing, 0])
            circle(r=screwDiameter/2 + screwLatchTolerance, $fn=100);
        // main body cutout
        translate([screwDiameter/2 * cos(45), screwDiameter/2 * sin(45), 0])
            rotate([0, 0, 135])
                #square([6.5, screwDiameter]);
        // round out the latch edge
        translate([screwDiameter/2 * cos(135), screwDiameter/2 * sin(135), 0])
            rotate([0, 0, 120])
                #square([2, 4]);
    }
}