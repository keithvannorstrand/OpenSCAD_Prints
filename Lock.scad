lockDiskRadius=10;

// cube lock cases
// cube([width,depth,height], center)
// cube([lockDiskRadius * 2.5, 10, lockCasingHeight]);

// lock insert
module lockCavity(keyRadius) {
    // calculated diskRadius to give tolerance
    calcDiskRadius = keyRadius + 1;
    //entryway
    rotate([90,90,0]) {
        translate([0,0,-calcDiskRadius]){
            cylinder(calcDiskRadius * 2, calcDiskRadius, calcDiskRadius);
        }
    }
    // front slot
    translate([-calcDiskRadius/2,-calcDiskRadius,0]) {
        cube([calcDiskRadius, calcDiskRadius, calcDiskRadius*3]);
    }
    
    //inner verticle
    translate([-calcDiskRadius, 0, 0]) {
        cube([calcDiskRadius*2, calcDiskRadius, calcDiskRadius*3]);
    }
    rotate([90,90,0]) {
        translate([-calcDiskRadius*3, 0, -calcDiskRadius]) {
            cylinder(calcDiskRadius, calcDiskRadius, calcDiskRadius);
        }
    }
};

module tooth(diskRadius)  {
    rotate([90,90,0]) {
        translate([0,0,-diskRadius]){
            cylinder(diskRadius, diskRadius, diskRadius);
        }
    }
    rotate([90, 90, 0]) {
        cylinder(diskRadius, diskRadius/2, diskRadius/2);
    }
}

module lock(diskRadius, numInserts) {
    height = diskRadius * 6;
    for (i = [0:numInserts - 1]) {
        difference() {
            translate([-diskRadius*1.5, 0, height*i]) {
                cube([diskRadius*3, diskRadius*2.5, height]);
            }
            translate([0, diskRadius, diskRadius*1.5 + height * i]) {
                lockCavity(diskRadius);
            }
        }
    }
}

module key(diskRadius, numTeeth) {
    gap = diskRadius*4;
    height = diskRadius*2;
    width = diskRadius*2;
    depth = diskRadius;
    for (i = [0:numTeeth-1]) {
        translate([0, diskRadius, diskRadius + gap * i + height*i]) {
            tooth(lockDiskRadius);
        }
        
        translate([-width*0.5, -depth, (height + gap) * i]) {
            cube([width, depth, height]);
        }
        if (i < numTeeth-1) {
            translate([-width*0.5, -depth, (height + gap) * i + height]) {
                cube([width, depth, gap]);
            }
        }
    }
}

lock(10, 2);
translate([100, 0, 0])
    key(10, 2);