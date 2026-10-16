/* 
    Full credit to Andy Levesque https://github.com/AndyLevesque/QuackWorks

    This code is based from the multiconnect_bin.scad and slimmed down for my purposes
*/

include <BOSL2/std.scad>;

multiconnectBackplate(
    backWidth = 110,
    totalHeight = 60,
    distanceBetweenSlots = 25,
    backThickness = 6.5
);

/*
    subtractedSlots - Reduces number of slots
    slotDepthMicroadjustment - [-.5:0.05:.5]
    multiconnectStopDistanceFromBack - Distance from the back of the item holder to where the multiconnect stops (i.e., where the dimple is) (by mm)
    onRampHalfOffset - boolean 
    slotTolerance - [0.925:0.005:1.075]
    slotQuickRelease - boolean - QuickRelease removes the small indent in the top of the slots that lock the part into place
    multiConnectVersion - "v1" or "v2" version of multiconnect being used
    onRampEnabled - boolean - enable a slot on-ramp for easy mounting of tall items
    onRampEveryXSlots - frequency of slots for on-ramp. 1 = every slot; 2 = every 2 slots; etc.;
*/
module multiconnectBackplate(
    backWidth,
    totalHeight,
    distanceBetweenSlots = 25,
    backThickness = 6.5,
    slotStopFromBack = 13,
    edgeRounding = 1,
    subtractedSlots = 0,
    slotDepthMicroadjustment = 0,
    multiconnectStopDistanceFromBack = 13,
    onRampHalfOffset = true,
    slotTolerance = 1.00,
    slotQuickRelease = false,
    multiConnectVersion = "v2",
    onRampEnabled = true,
    onRampEveryXSlots = 1
) {
    //slot count calculates how many slots can fit on the back. Based on internal width for buffer. 
    //slot width needs to be at least the distance between slot for at least 1 slot to generate
    let (backWidth = max(backWidth,distanceBetweenSlots), 
        backHeight = max(totalHeight, 25),
        slotCount = floor(backWidth/distanceBetweenSlots)- subtractedSlots
    ){
        difference() {
            translate(v = [0,-backThickness,0]) 
            cuboid(size = [backWidth,backThickness,backHeight], rounding=edgeRounding, edges=FRONT, except_edges=BOT, anchor=FRONT+LEFT+BOT, $fn = 25);
            //Loop through slots and center on the item
            //Note: I kept doing math until it looked right. It's possible this can be simplified.
            for (slotNum = [0:1:slotCount-1]) {
                translate(v = [
                    distanceBetweenSlots/2+(backWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,
                    -2.35+slotDepthMicroadjustment,
                    backHeight-multiconnectStopDistanceFromBack
                    ]) {
                    multiConnectSlotTool(
                        totalHeight = totalHeight,
                        distanceBetweenSlots = distanceBetweenSlots,
                        slotTolerance = slotTolerance,
                        onRampHalfOffset = onRampHalfOffset,
                        slotQuickRelease = slotQuickRelease,
                        multiConnectVersion = multiConnectVersion);
                }
            }
        }
    }
}

//Create Slot Tool
module multiConnectSlotTool(
    totalHeight,
    distanceBetweenSlots = 25,
    slotTolerance = 1.00,
    onRampHalfOffset = true,
    slotQuickRelease = false,
    multiConnectVersion = "v2",
    onRampEnabled = true,
    onRampEveryXSlots = 1
) {
    //In slotTool, added a new variable distanceOffset which is set by the option:
    distanceOffset = onRampHalfOffset ? distanceBetweenSlots / 2 : 0;
    scale(v = slotTolerance)
    //slot minus optional dimple with optional on-ramp
    let (slotProfile = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,5],[0,5]])
    difference() {
        union() {
            //round top
            rotate(a = [90,0,0,]) 
                rotate_extrude($fn=50) 
                    polygon(points = slotProfile);
            //long slot
            translate(v = [0,0,0]) 
                rotate(a = [180,0,0]) 
                union(){
                    difference() {
                        // Main half slot
                        linear_extrude(height = totalHeight+1) 
                            polygon(points = slotProfile);
                        
                        // Snap cutout
                        if (slotQuickRelease == false && multiConnectVersion == "v2")
                            translate(v= [10.15,0,0])
                            rotate(a= [-90,0,0])
                            linear_extrude(height = 5)  // match slot height (5mm)
                                polygon(points = [[0,0],[-0.4,0],[0,-8]]);  // triangle polygon with multiconnect v2 specs
                        }

                    mirror([1,0,0])
                        difference() {
                            // Main half slot
                            linear_extrude(height = totalHeight+1) 
                                polygon(points = slotProfile);
                            
                            // Snap cutout
                            if (slotQuickRelease == false && multiConnectVersion == "v2")
                                translate(v= [10.15,0,0])
                                rotate(a= [-90,0,0])
                                linear_extrude(height = 5)  // match slot height (5mm)
                                    polygon(points = [[0,0],[-0.4,0],[0,-8]]);  // triangle polygon with multiconnect v2 spec
                        }
                }
            //on-ramp
            if(onRampEnabled)
                for(y = [1:onRampEveryXSlots:totalHeight/distanceBetweenSlots])
                    //then modify the translate within the on-ramp code to include the offset
                    translate(v = [0,-5,(-y*distanceBetweenSlots)+distanceOffset])
                        rotate(a = [-90,0,0]) 
                            cylinder(h = 5, r1 = 12, r2 = 10.15);
        }
        //dimple
        if (slotQuickRelease == false && multiConnectVersion == "v1")
            scale(v = dimpleScale) 
            rotate(a = [90,0,0,]) 
                rotate_extrude($fn=50) 
                    polygon(points = [[0,0],[0,1.5],[1.5,0]]);
    }
}