use <MCAD/boxes.scad>

$fa = $preview ? 12 : 1;
$fs = $preview ? 2 : 0.4;

//$fa = 1;
//$fs = 0.4;

height = 56;
border = 2;

cl_x_count = 3;
cl_y_count = 2;
cl_padding = 4;
cl_padding_ext = 3;
cl_diametro = 30.1;
button_h = 22;
radius = 5;
show_button = false;
show_esp32 = false;
esp32_support = true;
use_roundbox = true;

//usb
use_usb = true;
usb_w = 13.5;
usb_d = border;
usb_h = 5.5;
usb_padd = 6;

//support
support_w = 32;
support_h = 94;
support_d = 2;
support_button_padd = 2; //distancia entre botoes e o suporte
pin_diam = 2.9;
pin_padd = 2;
pin_h = 10;
support_aba = 6;

fix = 0.005;
cl_raio = cl_diametro / 2;
width = ((cl_x_count * (cl_diametro + cl_padding)) - cl_padding) + (2 * (cl_padding * cl_padding_ext));
depth = ((cl_y_count * (cl_diametro + cl_padding)) - cl_padding) + (2 * (cl_padding * cl_padding_ext));

module my_box() {
    translate([0, 0, height])
    rotate([0, 180, 0]) {
        union() {
            difference() {
                if (use_roundbox) {
                    my_cube(width, depth, height, radius);
                } else {
                    cube([width, depth, height]);
                }
                translate([border, border, 0 - fix]) {
                    if (use_roundbox) {
                        my_cube(width - (border * 2), depth - (border * 2), height - border, radius);
                    } else {
                        cube([width - (border * 2), depth - (border * 2), height - border]);
                    }
                    
                }
                
                //button places
                cl_x_start = cl_raio;
                cl_y_start = cl_raio;
                for (x=[0:1:cl_x_count - 1]) {
                    for (y=[0:1:cl_y_count - 1]) {
                        translate([
                            cl_x_start + (((cl_x_start * 2) + cl_padding) * x) + (cl_padding * cl_padding_ext),
                            cl_y_start + (((cl_y_start * 2) + cl_padding) * y) + (cl_padding * cl_padding_ext),
                            height - border - (fix * 2)
                        ]) {
                            cylinder(h=border + (fix * 4), r=cl_raio);
                        }
                    }
                }
                
                if (use_usb) {
                    translate([(usb_w / 2) + border + (((width - (border * 2)) / 2) - (usb_w / 2)), (usb_d / 2), (usb_h / 2) + usb_padd])
                    rotate([90, 0, 0])
                    roundedBox(size=[usb_w, usb_h, usb_d + (fix * 2)], radius=2.6, sidesonly=true);
                }
            }
            
            //abas
            aba_w = width / 3;
            aba_h = 4;
            aba_d = 4;
            width_int = width - (border * 2);
            translate([(width_int - aba_w) / 2, border - fix, 0])
            cube([aba_w, aba_d, aba_h]);
            
            translate([(width_int - aba_w) / 2, depth - border - aba_d + fix, 0])
            cube([aba_w, aba_d, aba_h]);
        }
        
        if (show_button) {
            cl_x_start = cl_raio;
            cl_y_start = cl_raio;
            for (x=[0:1:cl_x_count - 1]) {
                for (y=[0:1:cl_y_count - 1]) {
                    translate([
                        cl_x_start + (((cl_x_start * 2) + cl_padding) * x) + (cl_padding * cl_padding_ext),
                        cl_y_start + (((cl_y_start * 2) + cl_padding) * y) + (cl_padding * cl_padding_ext),
                        (height - border - (fix * 2)) - button_h
                    ]) {
                        cylinder(h=button_h, r=cl_raio);
                    }
                }
            }
        }
        
    }
}

module my_cube(width, depth, height, radius) {
    translate([0, 0, -height]) {
        difference() {
            translate([width / 2, depth / 2, (height * 2) / 2]) {
                roundedBox(size=[width, depth, height * 2], radius=radius, sidesonly=false);
            }
            translate([-fix, -fix, -fix]) {
                cube([width + (fix * 2), depth + (fix * 2), height + fix]);
            }
        }
    }
}
module esp32_18650() {
    esp32_w = 91;
    esp32_d = 29;
    esp32_h = 24;
    suppurt_padd = 3.5;
    echo(esp32_h + border + button_h + support_button_padd + support_d + suppurt_padd);
    translate([-border -(((width - (border * 2)) - esp32_w) / 2), border+ (((depth - (border * 2)) - esp32_d) / 2), esp32_h + border + button_h + support_button_padd + support_d + suppurt_padd])
    rotate([0, 180, 0]) {
        cube([esp32_w, esp32_d, esp32_h]);
    }
}

module esp32_support() {
    union() {
        translate([-border -(((width - (border * 2)) - support_h) / 2), border + (((depth - (border * 2)) - support_w) / 2), support_d + border + button_h + support_button_padd])
        rotate([270, 0, 90]) {
            union() {
                cube([support_w, support_d, support_h]);

                translate([(pin_diam / 2) + pin_padd, fix, (pin_diam / 2) + pin_padd])
                rotate([90, 90, 0])
                cylinder(h=pin_h, r = pin_diam / 2);

                translate([support_w - ((pin_diam / 2) + pin_padd), fix, (pin_diam / 2) + pin_padd])
                rotate([90, 90, 0])
                cylinder(h=pin_h, r = pin_diam / 2);

                translate([(pin_diam / 2) + pin_padd, fix, support_h - (pin_diam / 2) - pin_padd])
                rotate([90, 90, 0])
                cylinder(h=pin_h, r = pin_diam / 2);

                translate([support_w - ((pin_diam / 2) + pin_padd), fix, support_h - (pin_diam / 2) - pin_padd])
                rotate([90, 90, 0])
                cylinder(h=pin_h, r = pin_diam / 2);
            }
        }
        
        //abas
        translate([-border -(((width - (border * 2)) - support_h) / 2), border - fix, support_d + border + button_h + support_button_padd])
        rotate([270, 0, 90]) {
            cube([depth - (border * 2) + (2 * fix), support_d, support_aba]);
        }
        
        translate([(-border -(((width - (border * 2)) - support_h) / 2)) - support_h + support_aba, border - fix, support_d + border + button_h + support_button_padd])
        rotate([270, 0, 90]) {
            cube([depth - (border * 2) + (2 * fix), support_d, support_aba]);
        }
        
        translate([-border + fix, border + (((depth - (border * 2)) - support_w) / 2), support_d + border + button_h + support_button_padd])
        rotate([270, 0, 90]) {
            cube([support_aba, support_d, width - (border * 2) + (2 * fix)]);
        }
        
        translate([-border + fix, (border + (((depth - (border * 2)) - support_w) / 2)) + support_w - support_aba, support_d + border + button_h + support_button_padd])
        rotate([270, 0, 90]) {
            cube([support_aba, support_d, width - (border * 2) + (2 * fix)]);
        }
    }
}

union() {
    my_box();
    if (show_esp32) esp32_18650();
    if (esp32_support) esp32_support();
}
