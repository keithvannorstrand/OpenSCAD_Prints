// this file needs tile components besides this file:
// - ./Tile Pegboard Hole Component.stl
// - ./Tile Multihole Component.stl
// These files can be downloaded from https://than.gs/m/994663

module MultiboardPegboardHole(location=[0,0],hull=false)
{
    translate([25*location.x,25*location.y,0])
    if(hull)
    {
        translate([12.5,12.5,0])
        scale([1.0001, 1.0001, 2.1])
        translate([-12.5,-12.5,-6.4/2])
        hull()
            import("Tile Pegboard Hole Component.stl");
    }
    else
    {
        import("Tile Pegboard Hole Component.stl");
    }
}

module MultiboardMultihole(location=[0,0],hull=false)
{
    translate([25*location.x,25*location.y,0]) 
    if(hull)
    {
        scale([1.0001, 1.0001, 2.1])
        translate([0,0,-6.4/2])
        hull()
            import("Tile Multihole Component.stl");
    }
    else
    {
        import("Tile Multihole Component.stl");
    }
}

module MultiboardSection(
    start=[1,1],
    end=[5,5], 
    PegsPosX=false,
    PegsNegX=false,
    PegsPosY=false,
    PegsNegY=false,
    PegsNegXNegY=false,
    PegsPosXNegY=false,
    PegsNegXPosY=false,
    PegsPosXPosY=false,
    hull=false) {
    
    assert(start.x<=end.x, "start should become before end");
    assert(start.y<=end.y, "start should become before end");
    
    // sides
    if(PegsPosX && start.y < end.y)
    {
        for (y=[start.y:end.y-1]) {
            MultiboardPegboardHole([end.x, y],hull);
        }
    }
    if(PegsNegX && start.y < end.y)
    {
        for (y=[start.y:end.y-1]) {
            MultiboardPegboardHole([start.x-1, y],hull);
        }
    }
    if(PegsPosY && start.x < end.x)
    {
        for (x=[start.x:end.x-1]) {
            MultiboardPegboardHole([x, end.y],hull);
        }
    }
    if(PegsNegY && start.x < end.x)
    {
        for (x=[start.x:end.x-1]) {
            MultiboardPegboardHole([x, start.y-1],hull);
        }
    }

    // corners
    if(PegsNegXNegY)
    {
        MultiboardPegboardHole([start.x-1, start.y-1],hull);
    }
    if(PegsPosXNegY)
    {
        MultiboardPegboardHole([end.x, start.y-1],hull);
    }
    if(PegsNegXPosY)
    {
        MultiboardPegboardHole([start.x-1, end.y],hull);
    }
    if(PegsPosXPosY)
    {
        MultiboardPegboardHole([end.x, end.y],hull);
    }

    // core elements
    for (x=[start.x:end.x]) {
        for (y=[start.y:end.y]) {
            MultiboardMultihole([x, y],hull);
        }
    }

    if(start.x < end.x && start.y < end.y)
    {
        for (x=[start.x:end.x-1]) {
            for (y=[start.y:end.y-1]) {
                MultiboardPegboardHole([x, y],hull);
            }
        }
    }
}
difference() {
color("red")
    MultiboardSection(
        start=[1,1],
        end=[10,10],
        PegsPosX=false,
        PegsNegX=false,
        PegsPosY=false,
        PegsNegY=false,
        PegsNegXNegY=false,
        PegsPosXNegY=false,
        PegsNegXPosY=false,
        PegsPosXPosY=false);
    MultiboardSection(
        start=[3,5],
        end=[5,7],
        PegsPosX=true,
        PegsNegX=true,
        PegsPosY=true,
        PegsNegY=true,
        PegsNegXNegY=false,
        PegsPosXNegY=false,
        PegsNegXPosY=false,
        PegsPosXPosY=false,
        hull=true);
}
