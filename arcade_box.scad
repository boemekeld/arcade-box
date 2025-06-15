use <MCAD/boxes.scad>

// ——— Preview resolution ———
$fa = $preview ? 12 : 1;
$fs = $preview ? 2  : 0.4;

// ——— Parameters ———
height        = 56;
border        = 2;
fix           = 0.005;
radius        = 5;
show_box      = false;
show_button   = false;
show_esp32    = false;
esp32_support = true;
use_roundbox  = true;
show_cover    = true;

// USB
use_usb       = true;
usb_w         = 14;
usb_d         = border;
usb_h         = 6;
usb_padd      = 8;

// Support
support_w            = 32;
support_h            = 94;
support_d            = 2;
support_button_padd  = 2;
support_aba          = 6;
pin_diam             = 2.9;
pin_padd             = 2;
pin_h                = 10;

// Button grid
cl_x_count   = 3;
cl_y_count   = 2;
cl_diameter  = 30.1;
cl_padding   = 4;
cl_pad_ext   = cl_padding * 3;
cl_radius    = cl_diameter / 2;
button_h = 22;

// Derived dimensions
width        = cl_x_count*(cl_diameter+cl_padding) - cl_padding + 2*cl_pad_ext;
depth        = cl_y_count*(cl_diameter+cl_padding) - cl_padding + 2*cl_pad_ext;
inner_width  = width  - 2*border;
inner_depth  = depth  - 2*border;

// ——— Helpers ———
module grid_cylinders(count_x, count_y, r, z_offset, cyl_h) {
    for (x=[0:count_x-1])
    for (y=[0:count_y-1]) {
        translate([
            r + cl_pad_ext + x*(2*r + cl_padding),
            r + cl_pad_ext + y*(2*r + cl_padding),
            z_offset
        ]) cylinder(h=cyl_h, r=r);
    }
}

module tabs() {
    tab_w = (inner_width/3) - 1;
    tab_h = 4;
    tab_d = 4;
    translate([border + ((inner_width - tab_w)/2), 0, 0]) {
        translate([0, border - fix, 0]) cube([tab_w, tab_d, tab_h]);
        translate([0, depth - border - tab_d + fix, 0]) cube([tab_w, tab_d, tab_h]);
    }
}

module my_cube(w, d, h, r) {
    translate([0,0,-h]) difference() {
        translate([w/2, d/2, h])
            roundedBox(size=[w,d,h*2], radius=r);
        translate([-fix, -fix, -fix])
            cube([w+2*fix, d+2*fix, h+fix]);
    }
}

// ——— Main box ———
module my_box() {
    translate([0,0,height]) rotate([0,180,0]) {
        union() {
            difference() {
                // Outer shell
                if (use_roundbox) my_cube(width, depth, height, radius);
                else cube([width, depth, height]);

                // Inner cut
                translate([border, border, -fix]) {
                    if (use_roundbox) my_cube(inner_width, inner_depth, height-border, radius);
                    else cube([inner_width, inner_depth, height-border]);
                }

                // Button holes
                grid_cylinders(
                    cl_x_count, cl_y_count, cl_radius,
                    height - border - fix*2,
                    border + fix*4
                );

                // USB cutout
                if (use_usb) {
                    translate([
                        //border + inner_width/2 - usb_w/2,
                        usb_w/2 + border + ((inner_width - usb_w) / 2),
                        usb_d/2,
                        usb_padd + usb_h/2
                    ]) rotate([90,0,0])
                      roundedBox(
                        size=[usb_w, usb_h, usb_d + fix*2],
                        radius=2.6,
                        sidesonly=true
                      );
                }
            }

            // Side tabs
            tabs();
        }

        // Visible buttons
        if (show_button)
            grid_cylinders(
                cl_x_count, cl_y_count, cl_radius,
                height - border - fix*2 - button_h,
                button_h
            );
    }
}

// ——— ESP32 board ———
module esp32_board() {
    board_w = 91; board_d = 29; board_h = 24;
    support_pad = 3.5;

    z0 = board_h + border + button_h + support_button_padd + support_d + support_pad;
    x0 = -border - (inner_width  - board_w)/2;
    y0 =  border + (inner_depth - board_d)/2;

    translate([x0,y0,z0]) rotate([0,180,0])
        cube([board_w, board_d, board_h]);
}

// ——— ESP32 support ———
module esp32_support() {
    support_x_base = -border - ((inner_width  - support_h) / 2);
    support_y_base =  border + ((inner_depth  - support_w) / 2);
    support_z_base =  support_d + border + button_h + support_button_padd;
    orientation_main = [270, 0,  90];
    pin_offset   = pin_diam/2 + pin_padd;
    union() {
        // Main support block + pins
        translate([support_x_base, support_y_base, support_z_base])
            rotate(orientation_main)
                union() {
                    cube([support_w, support_d, support_h]);
                    // Pins
                    for (xpos = [pin_offset, support_w - pin_offset])
                      for (zpos = [pin_offset, support_h - pin_offset])
                        translate([xpos, fix, zpos])
                          rotate([ 90, 90, 0])
                            cylinder(h = pin_h, r = pin_diam/2);
                }

        // Tabs
        for (i = [0,1]) 
            translate([support_x_base + i*(-support_h + support_aba), border - fix, support_z_base])
              rotate(orientation_main)
                cube([ inner_depth + 2*fix, support_d, support_aba ]);
        for (j = [0,1])
            translate([-border + fix, support_y_base + j*(support_w - support_aba), support_z_base])
              rotate(orientation_main)
                cube([ support_aba, support_d, inner_width  + 2*fix ]);
    }
}

module cover() {
    translate([2, 0, 0]) {
        translate([0,0,-border])
            translate([width/2, depth/2, border])
                roundedBox(size=[width,depth,border], radius=radius, sidesonly=true);

        tab_w = (inner_width/4) - 1;
        tab_h = 2;
        tab_d = 8;
        tab_padd = 4.1;
        tab_altura_add = 1.5;
        translate([border + ((inner_width - tab_w)/2), 0, 0]) {
            translate([0, border - fix, tab_padd + tab_altura_add]) cube([tab_w, tab_d, tab_h]);
            translate([0, depth - border - tab_d + fix, tab_padd + tab_altura_add]) cube([tab_w, tab_d, tab_h]);
            
            translate([0, border + tab_padd - 0.1, 0 - fix])
            cube([tab_w, 4, 6.1 + fix]);
            
            translate([0, depth - border - tab_d + fix, tab_padd - (4.1 + fix)])
            cube([tab_w, 4, 6.1 + fix]);
        }
        tab2_w = inner_depth / 2;
        margin = 0; // 0.025
        translate([border + margin, border + ((inner_depth - tab2_w)/2), 1 - fix]) cube([2, tab2_w, 2]);
        translate([inner_width - border + (2 - margin), border + ((inner_depth - tab2_w)/2), 1 - fix]) cube([2, tab2_w, 2]);
    }
}

// ——— Assembly ———
union() {
    if (show_box) {
        my_box();
        if (show_esp32) esp32_board();
        if (esp32_support) esp32_support();
    }
    if (show_cover) cover();
}