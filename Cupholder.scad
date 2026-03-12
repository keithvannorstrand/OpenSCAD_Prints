use <Lock.scad>;
$fa = $preview ? 12 : 1;
$fs = $preview ? 2 : 0.5;
// $fn = $preview ? 10 : 60;
module cup(innerRadius, outerRadius, height) {
    wallThickness = outerRadius - innerRadius;
    difference() {
        cylinder(height, outerRadius, outerRadius);
        cylinder(height - wallThickness*2, innerRadius, innerRadius);
    }
}

module mountHook(height, width, innerRadius, outerRadius) {
    wallThickness = outerRadius - innerRadius;
    difference() {
        union() {
            cube([width, wallThickness, height]);
            translate([0, wallThickness-outerRadius, height]) {
                rotate([90,0,90])
                    cylinder(h = width, r = outerRadius);
            }
            translate([0, wallThickness-outerRadius*2, height*.75])
                cube([width, wallThickness, height/4]);
        }
        translate([0, wallThickness-outerRadius, height]) {
            rotate([90,0,90])
                cylinder(h = width, r = innerRadius);
        }
        translate([0, (wallThickness-outerRadius) * 2, 0])
            cube([width, innerRadius * 2, height]);
    }
}

rotate([0, 180, 0])
    translate([0,40,-120])
        lock(10, 2);

translate([0, -30, 0]) {
    key(10, 2);
}

translate([0, 110, 0]) {
    cup(45, 48, 150);
}

translate([-25, -43, 0])
    mountHook(70, 50, 23, 28);