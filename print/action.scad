// Backlash between moving parts
backlash = 0.6;

felt_thickness = 3;

dampener_thickness = 7;
dampener_width = 20;
dampener_filet = 2;
dampener_hole_diameter = 3;

dampener_total_height = 20;
dampener_hinge_diameter = dampener_total_height - dampener_thickness - felt_thickness;

hinge_pinhole_diameter = 2;
pin_diameter = 1.5;

arm_width = 10;

dampener_arm_length = 78;
dampener_arm_thickness = 4;
dampener_arm_hollow_width = 8;
dampener_arm_hollow_depth = 3;
dampener_arm_holes_diameter = 3;
dampener_arm_holes_spacing = 6;

fixation_screw_distances = [ 10., 18. ];
fixation_screw_diameter = 4;
fixation_screw_head_space = 8;
fixation_screw_chamfer = 1;
fixation_thickness = 2;

mallet_arm_width = 10;
mallet_arm_length = 50; // from hinge to hinge
mallet_arm_thickness = 10;
mallet_arm_holes_diameter = 3;
mallet_arm_holes_spacing = 5;
mallet_arm_first_hole = 10; // from fixation hinge to first hole
mallet_arm_last_hole = 10; // from forearm hinge to last hole TODO compute this

mallet_forearm_length = 25; // from hinge to end
mallet_forearm_holes_diameter = 3; // diameter of rod fixation holes in forearm
mallet_forearm_holes_distances = [ 5, 13 ]; // distance from forearm end to rod fixation holes
mallet_forearm_rod_length = 20; // rod lenght swallowed by forearm

mallet_rod_diameter = 4; // hole diameter in case of cylindrical rod
mallet_rod_width = 1.7; // width for rectangular rod
mallet_rod_height = 8; // height for rectangular rod
mallet_rod_length = 100; // length of mallet-supporting rod

mallet_forearm_stop_thickness = 6;
mallet_forearm_stop_screw_thickness = 2;
mallet_forearm_stop_screw_head = 8;
mallet_forearm_stop_backlash = 2;

$fn = 48;
//$fn = 12;

// Dampener fixation
// centered around hinge centroid
module dampener_fixation() {
  translate([0.,-0.5*arm_width,-0.5*dampener_hinge_diameter])
  difference() {
    union() {
      translate([0,0,0.5*dampener_hinge_diameter]) rotate([-90,0,0])
        cylinder (d=dampener_hinge_diameter, h=arm_width);
      cube([dampener_hinge_diameter-fixation_thickness, arm_width, .5*dampener_hinge_diameter]);
      hull() {
        cube([.5*dampener_hinge_diameter, arm_width, fixation_thickness]);
        for( hole_distance = fixation_screw_distances )
          translate([hole_distance, .5*arm_width, 0]) cylinder(d=arm_width, h=fixation_thickness);
      }
    }
    union() {
      translate([0, 0.25*arm_width - 0.5*backlash, 0.5*dampener_hinge_diameter])
        rotate([-90,0,0])
          cylinder (d=dampener_hinge_diameter+2.*backlash, h=.5*arm_width + backlash);
      translate([dampener_hinge_diameter-fixation_thickness, 0, .5*dampener_hinge_diameter])
        rotate([-90,0,0])
          cylinder (d=dampener_hinge_diameter - 2*fixation_thickness, h=arm_width);
      translate([0,0,0.5*dampener_hinge_diameter]) rotate([-90,0,0])
        cylinder (d=hinge_pinhole_diameter, h=arm_width);
      for( hole_distance = fixation_screw_distances ) {
        translate([hole_distance, 0.5*arm_width, 0]) {
          cylinder(d=fixation_screw_diameter, h=fixation_thickness);
          translate([0,0,fixation_thickness-fixation_screw_chamfer])
            cylinder(d1=fixation_screw_diameter,d2=fixation_screw_diameter+2*fixation_screw_chamfer,h=fixation_screw_chamfer);
          translate([0,0,fixation_thickness])
            cylinder(d=fixation_screw_diameter, h=dampener_hinge_diameter);
        }
      }
    }
  }
}

// Dampener arm
// centered around hinge centroid
module dampener_arm() {
  translate([0.,-0.5*arm_width,-0.5*dampener_hinge_diameter])
  difference() {
    union() {
      translate([0,0,.5*dampener_hinge_diameter]) rotate([-90,0,0])
        cylinder(d=dampener_hinge_diameter, h=arm_width);
      cube([dampener_arm_length-.5*arm_width,arm_width,dampener_arm_thickness]);
      translate([dampener_arm_length-.5*arm_width,.5*arm_width,0])
        cylinder(d=arm_width,h=dampener_arm_thickness);
    }
    union() {
      translate([0, 0, 0.5*dampener_hinge_diameter]) rotate([-90,0,0])
          cylinder (d=dampener_hinge_diameter+2.*backlash, h=.25*arm_width+.5*backlash);
      translate([0, .75*arm_width-.5*backlash, 0.5*dampener_hinge_diameter]) rotate([-90,0,0])
          cylinder (d=dampener_hinge_diameter+2.*backlash, h=.25*arm_width+.5*backlash);
      translate([0,0,0.5*dampener_hinge_diameter]) rotate([-90,0,0])
        cylinder (d=hinge_pinhole_diameter, h=arm_width);
      hull() {
        translate([.5*dampener_hinge_diameter+dampener_arm_hollow_width,.5*arm_width,dampener_arm_thickness-dampener_arm_hollow_depth])
          cylinder(d=dampener_arm_hollow_width,h=dampener_arm_hollow_depth);
        translate([dampener_arm_length-0.5*arm_width,.5*arm_width,dampener_arm_thickness-dampener_arm_hollow_depth])
          cylinder(d=dampener_arm_hollow_width,h=dampener_arm_hollow_depth);
      }
      for( x = [.5*dampener_hinge_diameter+dampener_arm_hollow_width : dampener_arm_holes_spacing : dampener_arm_length-.5*arm_width] )
        translate([x,0.5*arm_width,0])
          cylinder(d=dampener_arm_holes_diameter,h=dampener_arm_thickness);
    }
  }
}

// Dampener
// centered around top hole
module dampener() {
  translate([-0.5*dampener_width,-0.5*dampener_width,-dampener_thickness])
  difference() {
    union() {
      hull() {
        cube([dampener_width,dampener_width,dampener_thickness-2*dampener_filet]);
        translate([0,dampener_filet,dampener_thickness-2*dampener_filet])
          rotate([0,90,0])
            cylinder(r=dampener_filet,h=dampener_width);
        translate([0,dampener_width-dampener_filet,dampener_thickness-2*dampener_filet])
          rotate([0,90,0])
            cylinder(r=dampener_filet,h=dampener_width);
      }
      translate([0,0.5*(dampener_width-arm_width)-dampener_filet,0])
        cube([dampener_width,arm_width+2*dampener_filet,dampener_thickness]);
      translate([0.5*dampener_width+dampener_arm_holes_spacing,0.5*dampener_width,dampener_thickness])
        sphere(d=dampener_arm_holes_diameter-backlash);
    }
    translate([0,0.5*(dampener_width-arm_width)-dampener_filet,dampener_thickness])
      rotate([0,90,0])
        cylinder(r=dampener_filet,h=dampener_width);
    translate([0,0.5*(dampener_width+arm_width)+dampener_filet,dampener_thickness])
      rotate([0,90,0])
        cylinder(r=dampener_filet,h=dampener_width);
    translate([0.5*dampener_width,0.5*dampener_width,0])
      cylinder(d=dampener_hole_diameter,h=dampener_thickness);
  }
}

// Dampener felt (not for print)
// centered around top face center
module dampener_felt() {
  color([0,.5,0])
    translate([-.5*dampener_width,-.5*dampener_width,-felt_thickness])
      cube([dampener_width, dampener_width, felt_thickness]);
}

// Pin centered around centroid (not for print)
module hinge_pin() {
  color([.5,.5,.5]) union() {
    translate([0,-.5*arm_width-pin_diameter,0]) {
      rotate([-90,0,0]) cylinder(d=pin_diameter,h=arm_width+2*pin_diameter);
      sphere(d=pin_diameter);
      rotate([180,0,0]) cylinder(d=pin_diameter,h=3);
    }
  }
}

// Mallet arm fixation
// centered around hinge centroid
module mallet_arm_fixation() {
  difference() {
    union() {
      hull() {
        rotate([-90,0,0])
          cylinder (d=mallet_arm_thickness, h=mallet_arm_width, center=true);
        translate([0,-0.5*mallet_arm_width,-0.5*mallet_arm_thickness])
          cube([max(fixation_screw_distances),mallet_arm_width,fixation_thickness]);
      }
      translate([max(fixation_screw_distances), 0, -0.5*mallet_arm_thickness])
        cylinder(d=mallet_arm_width, h=fixation_thickness);
    }
    rotate([-90,0,0])
      cylinder (d=mallet_arm_thickness+2.*backlash, h=.5*mallet_arm_width + backlash, center=true);
    rotate([-90,0,0])
      cylinder (d=hinge_pinhole_diameter, h=mallet_arm_width, center=true);
    hull() {
      for( hole_distance = fixation_screw_distances )
        translate([hole_distance, 0, -0.5*mallet_arm_thickness+fixation_thickness])
          cylinder(h=mallet_arm_thickness, d=fixation_screw_head_space);
    }
    for( hole_distance = fixation_screw_distances ) {
      translate([hole_distance, 0, -0.5*mallet_arm_thickness]) {
        cylinder(d=fixation_screw_diameter, h=fixation_thickness);
        translate([0,0,fixation_thickness-fixation_screw_chamfer])
          cylinder(d1=fixation_screw_diameter,d2=fixation_screw_diameter+2*fixation_screw_chamfer,h=fixation_screw_chamfer);
        translate([0,0,fixation_thickness])
          cylinder(d=fixation_screw_diameter+2*fixation_screw_chamfer,h=mallet_arm_thickness);
      }
    }
  }
}

// Mallet arm
// centered aroud fixation hinge centroid
module mallet_arm() {
  difference() {
    union() {
      rotate([90,0,0])
        cylinder(d=mallet_arm_thickness,h=0.5*mallet_arm_width-backlash, center=true);
      translate([-mallet_arm_length,0,0]) rotate([90,0,0])
        cylinder(d=mallet_arm_thickness,h=mallet_arm_width,center=true);
      difference() {
        translate([-0.5*mallet_arm_length,0,0])
          cube([mallet_arm_length,mallet_arm_width,mallet_arm_thickness], center=true);
        translate([0,-0.5*mallet_arm_width,0]) rotate([-90,0,0])
          cylinder(d=mallet_arm_width+2*backlash,h=0.25*mallet_arm_width+0.5*backlash, center=false);
        translate([-0.5*mallet_arm_thickness-backlash,-0.5*mallet_arm_width,0])
          cube([mallet_arm_thickness+2*backlash,0.25*mallet_arm_width+0.5*backlash,0.5*mallet_arm_thickness]);
        translate([0,0.5*mallet_arm_width,0]) rotate([90,0,0])
          cylinder(d=mallet_arm_width+2*backlash,h=0.25*mallet_arm_width+0.5*backlash, center=false);
        translate([-0.5*mallet_arm_thickness-backlash,0.25*mallet_arm_width-0.5*backlash,0])
          cube([mallet_arm_thickness+2*backlash,0.25*mallet_arm_width+0.5*backlash,0.5*mallet_arm_thickness]);
      }
    }
    translate([-mallet_arm_length,0,0]) rotate([90,0,0]) {
      cylinder(d=mallet_arm_thickness+2*backlash,h=0.5*mallet_arm_width+backlash,center=true);
      cylinder(d=hinge_pinhole_diameter,h=mallet_arm_width,center=true);
    }
    translate([-mallet_arm_length,-0.25*mallet_arm_width-0.5*backlash,0])
      cube([0.5*mallet_arm_thickness+backlash,0.5*mallet_arm_width+backlash,0.5*mallet_arm_thickness+backlash]);
    rotate([90,0,0]) cylinder(d=hinge_pinhole_diameter,h=mallet_arm_width,center=true);
    for (x = [mallet_arm_first_hole : mallet_arm_holes_spacing : mallet_arm_length-mallet_arm_first_hole]) {
      translate([-x,0,0]) cylinder(d=mallet_arm_holes_diameter, h=mallet_arm_thickness, center=true);
    }
  }
}

// Mallet forearm
// centered aroud centroid of hinge with arm
module mallet_forearm() {
  difference() {
    union() {
      rotate([90,0,0])
        cylinder(d=mallet_arm_thickness,h=0.5*mallet_arm_width-backlash, center=true);
      difference() {
        translate([-0.5*mallet_forearm_length,0,0])
          cube([mallet_forearm_length,mallet_arm_width,mallet_arm_thickness], center=true);
        translate([0,-0.5*mallet_arm_width,0]) rotate([-90,0,0])
          cylinder(d=mallet_arm_width+2*backlash,h=0.25*mallet_arm_width+0.5*backlash, center=false);
        translate([-0.5*mallet_arm_thickness-backlash,-0.5*mallet_arm_width,0])
          cube([mallet_arm_thickness+2*backlash,0.25*mallet_arm_width+0.5*backlash,0.5*mallet_arm_thickness]);
        translate([0,0.5*mallet_arm_width,0]) rotate([90,0,0])
          cylinder(d=mallet_arm_width+2*backlash,h=0.25*mallet_arm_width+0.5*backlash, center=false);
        translate([-0.5*mallet_arm_thickness-backlash,0.25*mallet_arm_width-0.5*backlash,0])
          cube([mallet_arm_thickness+2*backlash,0.25*mallet_arm_width+0.5*backlash,0.5*mallet_arm_thickness]);
      }
    }
    rotate([90,0,0]) cylinder(d=hinge_pinhole_diameter,h=mallet_arm_width,center=true);
    // Holes for mounting cylindrical rod
    /*
    translate([-mallet_forearm_length,0,0]) {
      rotate([0,90,0]) cylinder(d=mallet_rod_diameter, h=mallet_rod_length);

      for( hole_distance = mallet_forearm_holes_distances )
        translate([hole_distance,0,0])
          cylinder(d=mallet_forearm_holes_diameter, h=mallet_arm_thickness, center=true);
    }
    */
    // Holes for mounting rectangular section rod
    translate([-mallet_forearm_length,0,0]) {
      translate([0.5*mallet_forearm_rod_length,0,0])
        cube([mallet_forearm_rod_length,mallet_rod_width,mallet_rod_height], center=true);
      for( hole_distance = mallet_forearm_holes_distances )
        translate([hole_distance,0,0]) rotate([90,0,0])
          cylinder(d=mallet_forearm_holes_diameter, h=mallet_arm_thickness, center=true);
    }
  }
}

// Mallet forearm stop
// centered aroud centroid of hinge between arm and forearm
module mallet_forearm_stop() {
  difference() {
    union() {
      translate([mallet_arm_last_hole+mallet_arm_holes_spacing,0,-0.5*mallet_arm_thickness-mallet_forearm_stop_thickness])
        cylinder(d=mallet_arm_width, h=mallet_forearm_stop_thickness);
      translate([-mallet_forearm_length,-0.5*mallet_arm_width,-0.5*mallet_arm_thickness-mallet_forearm_stop_thickness])
        cube([mallet_forearm_length+mallet_arm_last_hole+mallet_arm_holes_spacing,mallet_arm_width,mallet_forearm_stop_thickness]);
      translate([mallet_arm_last_hole,0,-0.5*mallet_arm_thickness])
        cylinder(d1=mallet_arm_holes_diameter, d2=0, h=0.5*mallet_arm_holes_diameter);
    }
    translate([-mallet_forearm_length,-0.5*mallet_arm_width,-0.5*mallet_arm_thickness-felt_thickness])
      cube([mallet_forearm_length,mallet_arm_width,felt_thickness]);
    translate([mallet_arm_last_hole+mallet_arm_holes_spacing,0,-0.5*mallet_arm_thickness-mallet_forearm_stop_thickness]) {
      cylinder(d=mallet_arm_holes_diameter, h=mallet_forearm_stop_thickness);
      cylinder(d=mallet_forearm_stop_screw_head, h=mallet_forearm_stop_thickness-mallet_forearm_stop_screw_thickness);
    }
    translate([0,-0.5*mallet_arm_width,-0.5*mallet_arm_thickness])
      rotate([-90,0,0])
        scale([1.*mallet_forearm_stop_backlash/felt_thickness,1.,1.])
          cylinder(h=mallet_arm_width, r=felt_thickness);
  }
}

// Mallet-supporting rod
// centered on forearm centroid
module mallet_forearm_rod() {
  translate([-mallet_forearm_length+mallet_forearm_rod_length-0.5*mallet_rod_length,0,0])
    cube([mallet_rod_length,mallet_rod_width,mallet_rod_height], center=true);
}

// Mallet
// Centered around fixation hole on rod
module mallet() {
  rotate([90,0,0])
    difference() {
      hull() {
        translate([0,31,0])
          rotate_extrude() translate([5,0,0]) circle(r=5);
        cylinder(d=12, h=10, center=true);
      }
      hull() {
        translate([0,7,0]) cylinder(d=5, h=10, center=true);
        translate([0,32,0]) cylinder(d=5, h=10, center=true);
      }
      cylinder(d=3, h=10, center=true);
      cube([20, mallet_rod_height, mallet_rod_width], center=true);
    }
}

module mallet_arm_assembly() {
  mallet_arm_fixation();
  mallet_arm();
  translate([-mallet_arm_length,0,0]) {
    mallet_forearm();
    mallet_forearm_stop();
    mallet_forearm_rod();
    translate([-90, 0, 0]) mallet();
  }
}

//mallet_arm_assembly();

//mallet_forearm_stop();
//dampener_fixation();

module print_layout() {
  //translate([0,0,.5*dampener_hinge_diameter]) dampener_fixation();
  //translate([0,arm_width+5,.5*dampener_hinge_diameter]) dampener_arm();
  //translate([6,1.5*arm_width+.5*dampener_width+10,dampener_thickness]) dampener();
  
  mallet_arm_fixation();
  translate([0,20,0]) mallet_arm();
  translate([0,40,0]) mallet_forearm();
  translate([0,60,mallet_forearm_stop_thickness]) mallet_forearm_stop();
  translate([0,80,0]) rotate([0,0,-90]) rotate([90,0,0]) mallet();
}

print_layout();

module dampener_assembly() {
  rotate([180,0,0]) dampener_fixation();
  dampener_arm();
  hinge_pin();
  translate([.5*dampener_hinge_diameter+dampener_arm_hollow_width,0.,-0.5*dampener_hinge_diameter]) {
    dampener();
    translate([0,0,-dampener_thickness]) dampener_felt();
  }
  // TODO link to mallet arm
}

//print_layout();
//dampener_assembly();


