/*
 *  OpenSCAD 2D Shapes Library (www.openscad.org)
 *  Copyright (C) 2012 Peter Uithoven
 *
 *  License: LGPL 2.1 or later
*/

/**
2D Shapes - Provides the folowing modules:
------------------------------------------------------
ngon(sides, radius, center=false)
   Creates a regular polygon.
complexRoundSquare(size, rads1=[0, 0], rads2=[0, 0], rads3=[0, 0], rads4=[0, 0], center=true)
   Creates a square with radiused corners.  The radius can be different for each corner.
roundedSquare(pos=[10, 10], r=2)
   Creates a square with radiused corners.  A single radius applies to all corners.
ellipsePart(width, height, numQuarters)
   Creates an elipse or partial elipse with the specified number of quadrants
donutSlice(innerSize, outerSize, start_angle, end_angle) 
   Creates an annulus, or partial annulus.
pieSlice(size, start_angle, end_angle)
   Creates a circle sector.
ellipse(width, height)
   Creates a simple ellipse.
*/

// Example - Uncomment the following line to see each of the modules in use.
//example();

use <layouts.scad>;
module example() {
    module placeHolder() {
        circle(0.001);
    }
    
    grid(110, 110, true, 5) {
        // Ellipse examples
        // Full ellipse
        ellipse(50, 75);
        // Partial ellipse - Three quarters
        ellipsePart(50, 75, 3); 
        // Partial ellipse - Two quarters
        ellipsePart(50, 75, 2);
        // Partial ellipse - One quarter
        ellipsePart(50, 75, 1);
        placeHolder();

        // roundedSquare examples
        // Rounded square
        roundedSquare([80, 80], 20);
        // Rounded rectangle
        roundedSquare([80, 40], 10);
        // Full blend of top and bottom edges
        roundedSquare([40, 80], 19.99);
        // Full blend of left and right edges
        roundedSquare([40, 20], 9.99);
        // Rounded square with centering disabled
        roundedSquare([40, 40], 5, center=false);
        
        // complexRoundSquare examples
        // Symetrical
        complexRoundSquare([75, 100], [20, 10], [20, 10], [20, 10], [20, 10]);
        // Mixed square corners rounded
        complexRoundSquare([75, 100], [0, 0], [0, 0], [30, 50], [20, 10]);
        // Symetrical - uncentred
        complexRoundSquare([50, 50], [10, 20], [10, 20], [10, 20], [10, 20], false);
        // All corners squared
        complexRoundSquare([100, 100]);
        // Rotationally symetrical
        complexRoundSquare([100, 100], rads1=[20, 20], rads3=[20, 20]);

        // pieSlice Examples
        // Simple arc - acute angle
        pieSlice(50, 0, 25);
        // Simple arc - obtuse angle
        pieSlice(50, 45, 190);
        // Simple arc - reflex angle (Waka waka!)
        pieSlice(50, 45, 315);
        // Distorted arc - reflex angle
        pieSlice([50, 20], 45, 315);
        placeHolder();

        // donutSlice Examples
        // Inner and outer radius with reflex angle
        donutSlice(20, 50, 10, 350);
        // Inner and outer radius with acute angle
        donutSlice(30, 50, 190, 270);
        // Inner and outer boundaries with right angle
        donutSlice([40, 22], [50, 30], 180, 270);
        // Inner boundary, outer radius, and right angle
        donutSlice([50, 20], 50, 180, 270);
        // Inner and outer boundaries, and reflex angle
        donutSlice([20, 30], [50, 40], 0, 270);
        
        // ngon Examples
        // Equilateral triangle - default alignment with y axis
        ngon(3, 40);
        // Equilateral triangle - flipped alignment with y axis
        ngon(3, 40, align_closest_edge=true);
        // Regular pentagon - default alignment with x axis
        ngon(5, 40, align_with_y_axis=false);
        // Regular pentagon - - flipped alignment with x axis
        ngon(5, 40, align_with_y_axis=false, align_closest_edge=true);
    }
}

/**
Creates a square with rounded corners.  The degree of rounding can be different for each corner.
Parameters:
   size - width and height of boundaries
   rads1/2/3/4 - width and height of rouding for each corner
   center - When false the result is placed in the first quadrant
*/
module complexRoundSquare(size, rads1=[0, 0], rads2=[0, 0], rads3=[0, 0], rads4=[0, 0], center=true) {
	width = size[0];
	height = size[1];
	//%square(size=[width, height], center=true);
	x1 = 0 - width / 2 + rads1[0];
	y1 = 0 - height / 2 + rads1[1];
	x2 = width / 2 - rads2[0];
	y2 = 0 - height / 2 + rads2[1];
	x3 = width / 2 - rads3[0];
	y3 = height / 2 - rads3[1];
	x4 = 0 - width / 2 + rads4[0];
	y4 = height / 2 - rads4[1];

	scs = 0.1; //straight corner size

	x = (center) ? 0 : width / 2;
	y = (center) ? 0 : height / 2;

	translate([x, y, 0]) {
		hull() {
			// top left
			if (rads1[0] > 0 && rads1[1] > 0)
				translate([x1, y1]) 
                    mirror([1, 0])		
                        ellipsePart(rads1[0] * 2, rads1[1] * 2, 1);
			else 
				translate([x1, y1]) 						
                    square(size=[scs, scs]);
			
			// top right
			if (rads2[0] > 0 && rads2[1] > 0)
				translate([x2, y2]) 						
                    ellipsePart(rads2[0] * 2, rads2[1] * 2, 1);	
			else 
				translate([width / 2 - scs, 0 - height / 2]) 	
                    square(size=[scs, scs]);

			// bottom right
			if (rads3[0] > 0 && rads3[1] > 0)
				translate([x3, y3]) 
                    mirror([0, 1]) 		
                        ellipsePart(rads3[0] * 2, rads3[1] * 2, 1);
			else 
				translate([width / 2 - scs, height / 2 - scs]) 	
                    square(size=[scs, scs]);
			
			// bottom left
			if (rads4[0] > 0 && rads4[1] > 0)
				translate([x4, y4]) 
                    rotate([0, 0, -180]) 	
                        ellipsePart(rads4[0] * 2, rads4[1] * 2, 1);
			else 
				translate([x4, height / 2 - scs]) 	        
                    square(size=[scs, scs]);
		}
	}
}

/**
Creates a square with radiused corners.  A single radius applies to all corners.
Parameters:
   pos - width and height of boundaries
   r - Radius of rounding
*/
module roundedSquare(pos=[10, 10], r=2, center=true) {
    translate([center ? 0 : pos[0] / 2, center ? 0 : pos[1] / 2])
	minkowski() {
		square([pos[0] - r * 2, pos[1] - r * 2], center=true);
		circle(r=r);
	}
}

/**
Creates a regular polygon.
Parameters:
   sides - Number of sides
   radius - Radius from centre to tip of each vertex.
   center - if false the shape is moved to the first quadrant.
   align_with_y_axis - If true at least one edge is aligned to the y axis, 
                       if false the edge will be aligned to the x axis.
   align_closest_edge=false - if true the aligned edge will be one closest 
                              to the alignment axis, if false it will be the
                              edge furthest form the axis.
*/
module ngon(sides, radius, center=true, align_with_y_axis=true, align_closest_edge=false) {
    translate([center ? 0 : radius, center ? 0 : radius])
        rotate([0, 0, (360 / sides / 2) + (align_closest_edge ? 180 : 0) + (align_with_y_axis ? 0 : 90)]) 
            circle(r=radius, center=center, $fn=sides);
}

/**
Creates an elipse or partial elipse with the specified number of quadrants
Parameters:
   width - Unit width.
   height - Unit height.
   numQuarters - Valid values are 1 to 4, first quadrant is +x/-y, 
                 further quadrants are added anti-clockwise about 
                 the origin as per convention.
*/
module ellipsePart(width, height, numQuarters) {
    // Slight difference to avoid congruent edges
    d = 0.0001; 
    difference() {
        ellipse(width, height);
        if (numQuarters <= 3)
            translate([0 - width / 2 - d, 0 - height / 2 - d, 0]) 
                square([width / 2 + d, height / 2 + d]);
        if (numQuarters <= 2)
            translate([0 - width / 2 - d, -d, 0]) 
                square([width / 2 + d, height / 2 + d * 2]);
        if (numQuarters < 2)
            translate([-d, 0, 0]) 
                square([width / 2 + d * 2, height / 2 + d]);
    }
}

/**
Creates an annulus, or partial annulus.
Parameters:
   innerSize - Cutout region.  A scalar value is treated as radius, a vector is treated as [width, height]
   outerSize - Full region.  Scalar or vector as per innerSize parameter
   start_angle - Starting angle, 0 being the +ive x axis and progressing anti-clockwise by convention.
   end_angle - Ending angle.
*/
module donutSlice(innerSize, outerSize, start_angle, end_angle) {   
    difference(){
        pieSlice(outerSize, start_angle, end_angle);
        if(len(innerSize) > 1) 
            ellipse(innerSize[0]*2, innerSize[1]*2);
        else 
            circle(innerSize);
    }
}

/**
Creates a circle sector.
Parameters:
   size - Radius of the circle
   start_angle - Starting angle, 0 being the +ive x axis and progressing anti-clockwise by convention.
   end_angle - Ending angle.
   center - if false the shape is moved to the first quadrant.
*/
module pieSlice(size, start_angle, end_angle, center=true) {	
    rx = ((len(size) > 1) ? size[0] : size);
    ry = ((len(size) > 1) ? size[1] : size);
    trx = rx * sqrt(2) + 1;
    try = ry * sqrt(2) + 1;
    a0 = (4 * start_angle + 0 * end_angle) / 4;
    a1 = (3 * start_angle + 1 * end_angle) / 4;
    a2 = (2 * start_angle + 2 * end_angle) / 4;
    a3 = (1 * start_angle + 3 * end_angle) / 4;
    a4 = (0 * start_angle + 4 * end_angle) / 4;
    if (end_angle > start_angle) {
        translate([center ? 0 : size, center ? 0 : size]) {
            intersection() {
                if(len(size) > 1)
                    ellipse(rx*2, ry*2);
                else
                    circle(rx);
                polygon([
                    [0, 0], 
                    [trx * cos(a0), try * sin(a0)], 
                    [trx * cos(a1), try * sin(a1)], 
                    [trx * cos(a2), try * sin(a2)], 
                    [trx * cos(a3), try * sin(a3)], 
                    [trx * cos(a4), try * sin(a4)], 
                    [0, 0]
               ]);
            }
        }
    }
}

/**
Creates a simple ellipse.
Parameters:
   width - Width of the ellipse
   height - Height of ellipse
   center - if false the shape is moved to the first quadrant.
*/
module ellipse(width, height, center=true) {
    translate([center ? 0 : width / 2, center ? 0 : height / 2]) {
        scale([1, height/width, 1]) {
            circle(r=width/2);
        }
    }
}