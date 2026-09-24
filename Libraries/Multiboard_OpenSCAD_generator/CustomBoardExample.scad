// this file needs tile components besides this file:
// - ./Tile Pegboard Hole Component.stl
// - ./Tile Multihole Component.stl
// These files can be downloaded from https://than.gs/m/994663

use <BoardModule.scad>;

MultiboardSection(start=[4,1], end=[6,8], PegsPosY=true);
MultiboardSection(start=[1,4], end=[3,5], PegsPosX=true);
MultiboardSection(start=[3,6], end=[3,8], 
    PegsNegX=true, PegsPosX=true,     
    PegsNegXNegY=true,
    PegsPosXNegY=true,
    PegsNegXPosY=true,
    PegsPosXPosY=true,
);