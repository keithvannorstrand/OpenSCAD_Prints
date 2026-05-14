/*
  width - inner width of box - X
  length - inner length of box - Y
  height - inner height of box - Z

*/
module mainBox(innerWidth, innerLength, innerHeight, wallThickness, cutoutSpacing) {
  assert(innerHeight > wallThickness);
  outerWidth = innerWidth + wallThickness * 2;
  outerLength = innerLength + wallThickness * 2;
  outerHeight = innerHeight + wallThickness;

  difference() {
    cube([outerWidth, outerLength, outerHeight]);
    translate([wallThickness, wallThickness, wallThickness])
      cube([innerWidth, innerLength, innerHeight + 1]);
    for (x = [wallThickness : cutoutSpacing : innerLength]) {
      echo(x);
      translate([x, -0.5, wallThickness]) 
        #cube([5, wallThickness + 1, innerHeight - wallThickness]);
    }
  }
}

mainBox(
  innerWidth = 130,
  innerLength = 150,
  innerHeight = 20,
  wallThickness = 5,
  cutoutSpacing = 20
);