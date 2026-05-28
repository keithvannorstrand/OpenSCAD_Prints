/*
  width - inner width of box - X
  length - inner length of box - Y
  height - inner height of box - Z
  wallThickness - Thickenss of walls of the box
  cutoutSpacing - Spacing between cutouts for usb cord exits
  outletCutoutWidth - Width of the cutout for the power cord
*/
module mainBox(width, length, height, wallThickness, cutoutSpacing, outletCutoutWidth) {
  innerWidth = width;
  innerLength = length;
  innerHeight = height;
  assert(innerHeight > wallThickness);
  outerWidth = innerWidth + wallThickness * 2;
  outerLength = innerLength + wallThickness * 2;
  outerHeight = innerHeight + wallThickness;
  slotOverhang = 0.2; // excess size so the slots will fully cutout
  outletCutoutWidth = outletCutoutWidth ? outletCutoutWidth : 10;


  difference() {
    cube([outerWidth, outerLength, outerHeight]);
    translate([wallThickness, wallThickness, wallThickness])
      cube([innerWidth, innerLength, innerHeight + slotOverhang]);
    // side slots
    for (x = [wallThickness : cutoutSpacing : innerLength]) {
      translate([x, -slotOverhang/2, wallThickness])
        #cube([5, wallThickness + slotOverhang, innerHeight - wallThickness]);
      translate([x, outerLength - wallThickness - slotOverhang/2, wallThickness])
        #cube([5, wallThickness + slotOverhang, innerHeight - wallThickness]);
    }
    // Power cord cutout
    translate([0 - slotOverhang/2, outerLength/2 - outletCutoutWidth/2, wallThickness])
      #cube([wallThickness + slotOverhang, outletCutoutWidth, innerHeight - wallThickness]);
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

mainBox(
  width = 130,
  length = 150,
  height = 20,
  wallThickness = 5,
  cutoutSpacing = 20,
  outletCutoutWidth = 20
);

translate([150, 150, 0])
  boxLid(
    x = 130,
    y = 150,
    wallThickness = 5,
    cutoutSize = 5,
    cutoutSpacing = 20
  );