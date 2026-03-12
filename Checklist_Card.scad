
difference() {
    cube([40,38,1]);
    translate([-1, 2, 2]){
        rotate([135,0,0]) {
            cube([44,4,5]);
        }
    }
    translate([-1, 38, -1]){
        rotate([45,0,0]) {
            cube([43,4,5]);
        }
    }
}

