/* [Basic Dimensions] */
// Keycap width (1u, 2u...)
key_u_width = 1;
// Keycap depth (1u, 2u...)
key_u_depth = 1;

/* [Stem Configuration] */
// Stem layout base unit
stem_u_size = 1; // [1:1u (Standard), 1.25:1.25u, 1.5:1.5u, 1.75:1.75u]

/* [Height & Thickness] */
// Top solid face thickness (mm) [0.8:0.1:10.0]
top_thickness = 1.5;

/* [Legend] */
// Enable legend engraving
enable_legend = true;
// Legend mode: Text or Shape
legend_mode = 0; // [0:Text, 1:Shape]

/* [Text Options] */
// Legend text content (used when legend_mode = 0)
key_text = "A";
// Text size (mm)
text_size = 8.0;
// Text engraving depth (mm)
text_depth = 0.8;
// Font name
font_name = "Liberation Sans:style=Bold";
// Stroke outline width (mm)
stroke_width = 0.9;
// Hole-fill radius for morphological closing (must be > largest counter hole radius)
counter_fill_r = 5.0;

/* [Shape Options] */
// Shape type (used when legend_mode = 1)
shape_type = 0; // [0:Circle, 1:Triangle Up, 2:Triangle Down, 3:Triangle Left, 4:Triangle Right, 5:Square, 6:Square Rounded, 7:Play-Pause, 8:Next Track, 9:Prev Track, 10:Vol+, 11:Vol-, 12:Mute]
// Shape size (mm) — diameter for circle, side length for others
shape_size = 7.0;
// Shape engraving depth (mm)
shape_depth = 0.8;
// Corner radius for Square Rounded only (mm)
shape_corner_r = 1.5;
// Shape stroke outline width (mm)
shape_stroke_width = 1.0;

/* [Advanced Settings] */
// 1u base physical size (mm)
unit_mm = 19.05;
// Keycap wall thickness (mm)
wall_thickness = 1.5;
// Keycap gap clearance (mm)
key_gap = 0.8;

/* [Hidden] */
// Corner edge fillet radius (mm)
corner_radius = 1.0;
// Stem post outer radius (mm)
stem_outer_r = 2.8;
// MX stem cross-hole depth (mm)
cross_depth = 4.0;
// Render resolution
$fn = 64;

total_height = cross_depth + top_thickness;

difference() {
    union() {
        keycap_shell_smooth();
        generate_stem_posts();
    }
    keycap_cavity_cutout();
    generate_stem_cross_cuts();
    generate_legend_cutout();
}

// ─── Legend dispatcher ────────────────────────────────────────────────────────

module generate_legend_cutout() {
    if (enable_legend) {
        if (legend_mode == 0) {
            legend_text_cutout();
        } else {
            legend_shape_cutout();
        }
    }
}

// Text mode: stroke-outline engraving via morphological closing
module legend_text_cutout() {
    if (key_text != "") {
        safe_depth = min(text_depth, top_thickness - 0.2);
        translate([0, 0, total_height - safe_depth]) {
            linear_extrude(height = safe_depth + 0.1) {
                difference() {
                    offset(r = -counter_fill_r)
                        offset(r = counter_fill_r)
                            offset(delta = stroke_width)
                                text(text = key_text, size = text_size, font = font_name,
                                     halign = "center", valign = "center");
                    text(text = key_text, size = text_size, font = font_name,
                         halign = "center", valign = "center");
                }
            }
        }
    }
}

// Shape mode: stroke-outline engraving (shape_stroke_width wide ring around shape edge)
module legend_shape_cutout() {
    safe_depth = min(shape_depth, top_thickness - 0.2);
    translate([0, 0, total_height - safe_depth]) {
        linear_extrude(height = safe_depth + 0.1) {
            difference() {
                offset(delta = shape_stroke_width) legend_shape_2d();
                legend_shape_2d();
            }
        }
    }
}

// ─── 2D shape library ─────────────────────────────────────────────────────────

module legend_shape_2d() {
    if      (shape_type == 0)  shape_circle_2d();
    else if (shape_type == 1)  shape_triangle_2d(0);
    else if (shape_type == 2)  shape_triangle_2d(180);
    else if (shape_type == 3)  shape_triangle_2d(90);
    else if (shape_type == 4)  shape_triangle_2d(270);
    else if (shape_type == 5)  shape_square_2d();
    else if (shape_type == 6)  shape_square_rounded_2d();
    else if (shape_type == 7)  shape_play_pause_2d();
    else if (shape_type == 8)  shape_next_track_2d();
    else if (shape_type == 9)  shape_prev_track_2d();
    else if (shape_type == 10) shape_vol_up_2d();
    else if (shape_type == 11) shape_vol_down_2d();
    else if (shape_type == 12) shape_mute_2d();
}

// Circle — diameter = shape_size
module shape_circle_2d() {
    circle(d = shape_size);
}

// Equilateral triangle inscribed in a circle of radius = shape_size/2
// rot_angle: 0=up, 180=down, 90=left, 270=right
module shape_triangle_2d(rot_angle) {
    r = shape_size / 2;
    rotate([0, 0, rot_angle])
    polygon([
        [ 0,                    r          ],
        [-r * sin(120),  r * cos(120)],
        [ r * sin(120),  r * cos(120)]
    ]);
}

// Square — side = shape_size
module shape_square_2d() {
    square([shape_size, shape_size], center = true);
}

// Square with rounded corners — side = shape_size, corner radius = shape_corner_r
module shape_square_rounded_2d() {
    safe_r = min(shape_corner_r, shape_size / 2 - 0.1);
    inner = shape_size - 2 * safe_r;
    offset(r = safe_r) square([inner, inner], center = true);
}

// ── Media key shapes ──────────────────────────────────────────────────────────

// Reusable speaker body (box + cone, opening faces right, centered left of origin)
module speaker_body_2d() {
    s = shape_size;
    union() {
        translate([-s*0.42, 0]) square([s*0.2, s*0.28], center = true);
        polygon([
            [-s*0.32,  s*0.14],
            [-s*0.32, -s*0.14],
            [-s*0.04, -s*0.30],
            [-s*0.04,  s*0.30]
        ]);
    }
}

// Play/Pause: two vertical bars (pause) on left + right-pointing triangle (play)
module shape_play_pause_2d() {
    s = shape_size;
    union() {
        translate([-s*0.38, 0]) square([s*0.15, s*0.65], center = true);
        translate([-s*0.18, 0]) square([s*0.15, s*0.65], center = true);
        polygon([
            [ s*0.02,  s*0.33],
            [ s*0.42,  0     ],
            [ s*0.02, -s*0.33]
        ]);
    }
}

// Next Track: right-pointing triangle + vertical bar on the right
module shape_next_track_2d() {
    s = shape_size;
    union() {
        translate([-s*0.12, 0]) polygon([
            [0,      s*0.33],
            [s*0.36, 0     ],
            [0,     -s*0.33]
        ]);
        translate([s*0.32, 0]) square([s*0.13, s*0.66], center = true);
    }
}

// Prev Track: vertical bar on the left + left-pointing triangle
module shape_prev_track_2d() {
    s = shape_size;
    union() {
        translate([s*0.12, 0]) polygon([
            [0,      s*0.33],
            [-s*0.36, 0    ],
            [0,     -s*0.33]
        ]);
        translate([-s*0.32, 0]) square([s*0.13, s*0.66], center = true);
    }
}

// Vol+: speaker body + plus sign on the right
module shape_vol_up_2d() {
    s = shape_size;
    union() {
        speaker_body_2d();
        translate([s*0.28, 0]) square([s*0.30, s*0.10], center = true);
        translate([s*0.28, 0]) square([s*0.10, s*0.30], center = true);
    }
}

// Vol-: speaker body + minus sign on the right
module shape_vol_down_2d() {
    s = shape_size;
    union() {
        speaker_body_2d();
        translate([s*0.28, 0]) square([s*0.30, s*0.10], center = true);
    }
}

// Mute: speaker body + X mark on the right
module shape_mute_2d() {
    s = shape_size;
    union() {
        speaker_body_2d();
        translate([s*0.28, 0]) {
            rotate([0, 0,  45]) square([s*0.10, s*0.36], center = true);
            rotate([0, 0, -45]) square([s*0.10, s*0.36], center = true);
        }
    }
}

// ─── Keycap geometry ──────────────────────────────────────────────────────────

module keycap_shell_smooth() {
    real_w = (key_u_width * unit_mm) - key_gap;
    real_d = (key_u_depth * unit_mm) - key_gap;
    _edge_fillet = 0.5;
    base_h = total_height - _edge_fillet;
    hull() {
        layer_rounded_rect(real_w, real_d, corner_radius, 0, 0.1);
        layer_rounded_rect(real_w, real_d, corner_radius, base_h, 0.01);
    }
    steps = 10;
    union() {
        for (i = [0 : steps-1]) {
            hull() {
                angle_1 = (i / steps) * 90;
                offset_1 = _edge_fillet * (1 - cos(angle_1));
                z_1 = base_h + (_edge_fillet * sin(angle_1));
                angle_2 = ((i + 1) / steps) * 90;
                offset_2 = _edge_fillet * (1 - cos(angle_2));
                z_2 = base_h + (_edge_fillet * sin(angle_2));
                layer_rounded_rect(real_w - (offset_1*2), real_d - (offset_1*2), corner_radius - offset_1, z_1, 0.01);
                layer_rounded_rect(real_w - (offset_2*2), real_d - (offset_2*2), corner_radius - offset_2, z_2, 0.01);
            }
        }
    }
}

module layer_rounded_rect(w, d, r, z, h_thick) {
    safe_r = max(0.01, r);
    translate([0, 0, z])
    hull() {
        translate([-(w/2)+safe_r, -(d/2)+safe_r, 0]) cylinder(r=safe_r, h=h_thick);
        translate([(w/2)-safe_r, -(d/2)+safe_r, 0]) cylinder(r=safe_r, h=h_thick);
        translate([(w/2)-safe_r, (d/2)-safe_r, 0]) cylinder(r=safe_r, h=h_thick);
        translate([-(w/2)+safe_r, (d/2)-safe_r, 0]) cylinder(r=safe_r, h=h_thick);
    }
}

module generate_stem_posts() {
    count_x = max(1, floor(key_u_width / stem_u_size));
    count_y = max(1, floor(key_u_depth / stem_u_size));
    stem_unit_real_mm = stem_u_size * unit_mm;
    offset_x = (count_x - 1) * stem_unit_real_mm / 2;
    offset_y = (count_y - 1) * stem_unit_real_mm / 2;
    legend_margin = enable_legend ? (max(text_depth, shape_depth) + 0.5) : 0.5;

    for (ix = [0 : count_x - 1]) {
        for (iy = [0 : count_y - 1]) {
            pos_x = (ix * stem_unit_real_mm) - offset_x;
            pos_y = (iy * stem_unit_real_mm) - offset_y;
            translate([pos_x, pos_y, 0])
                cylinder(r=stem_outer_r, h=total_height - legend_margin);
        }
    }
}

module keycap_cavity_cutout() {
    real_w = (key_u_width * unit_mm) - key_gap;
    real_d = (key_u_depth * unit_mm) - key_gap;
    inner_w = real_w - (wall_thickness * 2);
    inner_d = real_d - (wall_thickness * 2);
    cavity_height = total_height - top_thickness;
    difference() {
        translate([0,0,-0.1])
        hull() {
            layer_rounded_rect(inner_w, inner_d, corner_radius, 0, cavity_height);
        }
        generate_stem_posts();
    }
}

module generate_stem_cross_cuts() {
    count_x = max(1, floor(key_u_width / stem_u_size));
    count_y = max(1, floor(key_u_depth / stem_u_size));
    stem_unit_real_mm = stem_u_size * unit_mm;
    offset_x = (count_x - 1) * stem_unit_real_mm / 2;
    offset_y = (count_y - 1) * stem_unit_real_mm / 2;

    for (ix = [0 : count_x - 1]) {
        for (iy = [0 : count_y - 1]) {
            pos_x = (ix * stem_unit_real_mm) - offset_x;
            pos_y = (iy * stem_unit_real_mm) - offset_y;
            translate([pos_x, pos_y, 0]) mx_cross_shape();
        }
    }
}

module mx_cross_shape() {
    cross_len = 4.1;
    cross_thick = 1.2;
    translate([0,0,-0.1]) {
        union() {
            translate([-(cross_len/2), -(cross_thick/2), 0])
                cube([cross_len, cross_thick, cross_depth]);
            translate([-(cross_thick/2), -(cross_len/2), 0])
                cube([cross_thick, cross_len, cross_depth]);
        }
    }
}
