// this file needs tile components besides this file:
// - ./Tile Pegboard Hole Component.stl
// - ./Tile Multihole Component.stl
// These files can be downloaded from https://than.gs/m/994663

use <BoardModule.scad>;

/* [General] */
// Multiholes in the x direction
size_x = 9;
// Multiholes in the y direction
size_y = 9;
Type = "Core";//[Core, Side, Corner, Custom]

/* [Hole in board] */
NegativePart=false;
StartHole=[-1,-1];
EndHole=[-1,-1];

/* [Peg holes side] */
side_positive_x = true;
side_positive_y = true;
side_negative_x = true;
side_negative_y = true;
corner_negative_x_negative_y = true;
corner_positive_x_negative_y = true;
corner_negative_x_positive_y = true;
corner_positive_x_positive_y = true;

typed_side_positive_x = Type == "Core" || Type == "Side"?true:(Type == "Custom"?side_positive_x:false);
typed_side_positive_y = Type == "Core"?true:(Type == "Custom"?side_positive_y:false);
typed_side_negative_x = Type == "Custom"?side_negative_x:false;
typed_side_negative_y = Type == "Custom"?side_negative_y:false;
typed_corner_negative_x_negative_y = Type == "Custom"?corner_negative_x_negative_y:false;
typed_corner_positive_x_negative_y = Type == "Custom"?corner_positive_x_negative_y:false;
typed_corner_negative_x_positive_y = Type == "Custom"?corner_negative_x_positive_y:false;
typed_corner_positive_x_positive_y = Type == "Core"?true:(Type == "Custom"?corner_positive_x_positive_y:false);

if(NegativePart) {
    assert(StartHole.x<EndHole.x, "start hole should be smaller then end hole");
    assert(StartHole.y<EndHole.y, "start hole should be smaller then end hole");
}

difference() {
    MultiboardSection(
        start=[1,1],
        end=[size_x,size_y],
        PegsPosX=typed_side_positive_x,
        PegsNegX=typed_side_negative_x,
        PegsPosY=typed_side_positive_y,
        PegsNegY=typed_side_negative_y,
        PegsNegXNegY=typed_corner_negative_x_negative_y,
        PegsPosXNegY=typed_corner_positive_x_negative_y,
        PegsNegXPosY=typed_corner_negative_x_positive_y,
        PegsPosXPosY=typed_corner_positive_x_positive_y);
    if(NegativePart) {
        MultiboardSection(
            start=StartHole,
            end=EndHole,
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
}