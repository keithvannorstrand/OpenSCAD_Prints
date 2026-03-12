difference() {   
    color("red", 1)
        import("routine_tracker_4.stl");

    for (i=[0:3]) {
        color("green")    
            translate([21 + 42*i, 47.7, 2])
                cylinder(h=3, r=3.5, $fn=6, center=true);
        
        color("green")    
            translate([21 + 42*i, 67.5, 2])
                cylinder(h=3, r=3.5, $fn=6, center=true);
    }
}