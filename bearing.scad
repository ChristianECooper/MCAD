/*
 * Bearing model.
 *
 * Originally by Hans Häggström, 2010.
 * Dual licenced under Creative Commons Attribution-Share Alike 3.0 and LGPL2 or later
 */

/**
Bearing - Provides the following functions & modules:
-----------------------------------------------------
mo: bearing(pos, angle, model, outline, material, sideMaterial)
    Constructs a bearing
fn: bearingDimensions(model)
   Dimensions for standard bearing models.
fn: bearingWidth(model)
   Width for standard bearing models.
fn: bearingInnerDiameter(model)
   Inner diameter for standard bearing models.
fn: bearingOuterDiameter(model)
   Outer diameter for standard bearing models.

Supported bearings models are: 608, 623, 624, 627, 688, & 698, unknwon models requested are defaulted to a 608 model.
*/

include <units.scad>
include <materials.scad>

// Example, uncomment to view
//test_bearing();
//test_bearing_hole();

// Build example bearings
module test_bearing(){
    bearing();
    bearing(pos=[5 * cm, 0,0], angle=[90, 0, 0]);
    bearing(pos=[-2.5 * cm, 0,0], model=688);
}

// Build example void for a bearing
module test_bearing_hole(){
    difference() {
        translate([0, 0, 3.5]) 
            cube(size=[30, 30, 7 - 10 * epsilon], center=true);
        bearing(outline=true);
    }
}

// Standard indices
BEARING_INNER_DIAMETER = 0;
BEARING_OUTER_DIAMETER = 1;
BEARING_WIDTH = 2;

// Common bearing names
SkateBearing = 608;

// Bearing dimensions
// model == XXX ? [inner dia, outer dia, width]:
function bearingDimensions(model) =
  model == 608 ? [8*mm, 22*mm, 7*mm]:
  model == 623 ? [3*mm, 10*mm, 4*mm]:
  model == 624 ? [4*mm, 13*mm, 5*mm]:
  model == 627 ? [7*mm, 22*mm, 7*mm]:
  model == 688 ? [8*mm, 16*mm, 4*mm]:
  model == 698 ? [8*mm, 19*mm, 6*mm]:
  [8*mm, 22*mm, 7*mm]; // this is the default - a 608 bearing


function bearingWidth(model) = bearingDimensions(model)[BEARING_WIDTH];
function bearingInnerDiameter(model) = bearingDimensions(model)[BEARING_INNER_DIAMETER];
function bearingOuterDiameter(model) = bearingDimensions(model)[BEARING_OUTER_DIAMETER];

/**
Constructs a bearing
Parameters:
   pos - Displacement from origin (applied after rotation), defaults to origin.
   angle - Rotation to apply about the axes of the origin, dafaults to no rotation.
   model - Model number of the bearing to build
   outline - If true will return the void a bearing would fill. (Useful for binary operations.)
   material - material to apply to the inner and outer bearing radial faces
   sideMaterial - material to apply to bearing covers
*/
module bearing(
    pos=[0, 0, 0], 
    angle=[0, 0, 0], 
    model=SkateBearing, 
    outline=false,
    material=Steel, 
    sideMaterial=Brass) {

    // Common bearing names
    model = model == "Skate" 
        ? 608 
        : model;

    w = bearingWidth(model);
    innerD = outline == false 
        ? bearingInnerDiameter(model) 
        : 0;
    outerD = bearingOuterDiameter(model);
    innerRim = innerD + (outerD - innerD) * 0.2;
    outerRim = outerD - (outerD - innerD) * 0.2;
    midSink = w * 0.1;

    translate(pos) 
    rotate(angle) 
    union() {
        color(material)
        difference() {
            // Basic ring
            Ring([0, 0, 0], outerD, innerD, w, material, material);
            if (outline == false) {
                // Side shields
                Ring([0, 0, -epsilon], outerRim, innerRim, epsilon + midSink, sideMaterial, material);
                Ring([0, 0, w - midSink], outerRim, innerRim, epsilon + midSink, sideMaterial, material);
            }
        }
    }

    // Constructs a cylinder with a cylindrical hole on the same axis.
    module Ring(pos, od, id, h, material, holeMaterial) {
        color(material) {
            translate(pos)
            difference() {
                cylinder(r=od / 2, h=h,  $fs=0.01);
                color(holeMaterial)
                    translate([0, 0, -10 * epsilon])
                        cylinder(r=id / 2, h=h + 20 * epsilon,  $fs=0.01);
            }
        }
    }
}


