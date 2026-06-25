/*
  x - inner width of box - X
  y - inner length of box (Size of edge with the outlet cord) - Y
  height - inner height of box - Z
  wallThickness - Thickness of walls of the box
  cutoutSpacing - Spacing between cutouts for usb cord exits
  cutoutWidth - Width of the cutout for USB cables
  chargerX - Width of the charger
  chargerY - Length of the charger (Size of the edge with the outlet cord)
  chargerHeight - Height of charger
  outletCutoutWidth - Width of the cutout for the power cord
*/
module mainBox(x, y, height, wallThickness, cutoutSpacing, cutoutWidth, chargerX, chargerY, chargerHeight, outletCutoutWidth) {
  innerX = x;
  innerY = y;
  innerHeight = height;
  assert(innerHeight > wallThickness);
  outerX = innerX + wallThickness * 2;
  outerY = innerY + wallThickness * 2;
  outerHeight = innerHeight + wallThickness;
  slotOverhang = 0.2; // excess size so the slots will fully cutout
  outletCutoutWidth = outletCutoutWidth ? outletCutoutWidth : 10;


  difference() {
    cube([outerX, outerY, outerHeight]);
    translate([wallThickness, wallThickness, wallThickness])
      cube([innerX, innerY, innerHeight + slotOverhang]);
    // side slots
    for (x = [wallThickness : cutoutSpacing : innerX]) {
      translate([x, -slotOverhang/2, wallThickness])
        #cube([cutoutWidth, wallThickness + slotOverhang, innerHeight - wallThickness]);
      translate([x, outerY - wallThickness - slotOverhang/2, wallThickness])
        #cube([cutoutWidth, wallThickness + slotOverhang, innerHeight - wallThickness]);
    }
    // Power cord cutout
    translate([0 - slotOverhang/2, outerY/2 - outletCutoutWidth/2, wallThickness])
      #cube([wallThickness + slotOverhang, outletCutoutWidth, innerHeight - wallThickness]);
  }
  
  translate([wallThickness, wallThickness + (innerY - chargerY)/2, wallThickness])
    difference() {
        cube([chargerX + wallThickness, chargerY + wallThickness, chargerHeight]);
        translate([0, wallThickness/2, 0])
            cube([chargerX + wallThickness/2, chargerY, chargerHeight]);
    }
}

module boxLid(x, y, wallThickness, cutoutSize, cutoutSpacing) {
  cutoutOverhang = 0.2;
  outerX = x + wallThickness * 2;
  outerY = y + wallThickness * 2;
  perimeterHeight = wallThickness;
  fullHeight = wallThickness * 1.5;
  difference() {
    union() {
      cube([outerX, outerY, perimeterHeight]);
      translate([wallThickness, wallThickness, 0])
        cube([x, y, fullHeight]);
    }
    // cutouts for top dividers
    for (cutoutX = [wallThickness : cutoutSpacing : outerX]) {
      translate([cutoutX, wallThickness, -cutoutOverhang/2])
        #cube([cutoutSize, cutoutSize, fullHeight + cutoutOverhang]);
      translate([cutoutX, outerY - wallThickness - cutoutSize, -cutoutOverhang/2])
        #cube([cutoutSize, cutoutSize, fullHeight + cutoutOverhang]);
    }
  }

}

minkowski() {
  mainBox(
    x = 150,
    y = 150,
    height = 35,
    wallThickness = 3,
    cutoutSpacing = 20,
    cutoutWidth = 8,
    chargerX = 80,
    chargerY = 130,
    chargerHeight = 5,
    outletCutoutWidth = 20
  );
  sphere(r=1);
}


// minkowski() {
//   translate([150, 150, 0])
//     boxLid(
//       x = 150,
//       y = 150,
//       wallThickness = 2,
//       cutoutSize = 5,
//       cutoutSpacing = 20
//     );
//   sphere(r=1);
// }
