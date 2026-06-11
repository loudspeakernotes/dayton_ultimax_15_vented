// Basic vented box for Dayton Ultimax 15" subwoofer
// Modelled in WinISD

// Volume 300L (not including ports, speaker, stuffing
// Tuning 25Hz
// 4 ports triangle shaped
// Triangle port area equivalent to 9cm x 9cm square ports

// Max cone excursion at 600W happens at 20Hz
// Set highpass filter higher than 20Hz

iw = 590;
id = 710;
ih = 800;
t = 19;
front_setback = 50;


// each triangle port area is equivalent to 90x90mm square port
pl = 443; // port length
pis = 127; // port inner side length
pid = sqrt(pis*pis*2); // port inner diagonal length
echo(str("Port panels short width: ", pl, " x ", pid));
pos = pis+sqrt(t*t*2); // port outer side length
pod = sqrt(pos*pos*2); // port outer diagonal length
echo(str("Port panels long width: ", pl, " x ", pod));

// subwoofer details
// dayton ultimax 15 UMII15-22
// see spec sheet at https://www.daytonaudio.com/images/resources/295-714--dayton-audio-UMII15-22-spec-sheet.pdf
// and general info at
// https://www.daytonaudio.com/product/2065/umii15-22-ultimax-ii-15-dvc-subwoofer-2-ohms-per-coil

subd = 354;

// base
translate([0, 0, 0]) {
    w = t + iw + t;
    d = t + id + t;
    cube([w, d, t]);
    echo(str("Bottom: ", d, " x ", w));
}

// top
translate([0, 0, t+ih]) {
    w = t + iw + t;
    d = t + id + t;
    cube([w, d, t]);
    echo(str("Bottom: ", d, " x ", w));
}

// side
translate([0, 0, t]) {
    d = t + id + t;
    h = ih;
    color("blue") cube([t, d, h]);
    echo(str("Side: ", h, " x ", d));
}

// side
translate([t+iw, 0, t]) {
    d = t + id + t;
    h = ih;
    //color("blue") cube([t, d, h]);
    echo(str("Side: ", h, " x ", d));
}

// front
translate([t, front_setback, t]) {
    w = iw;
    h = ih;
    difference() {
        color("red") cube([w, t, h]);
        echo(str("Front: ", h, " x ", w));
        // port cutouts
        // bottom left
        translate([0, -1, pos]) {
            rotate([0, 90+45, 0]) {
                cube([1000, t+2, 1000]);
            }
        }
        // bottom right
        translate([iw-pos, -1, 0]) {
            rotate([0, 45, 0]) {
                cube([1000, t+2, 1000]);
            }
        }
        // top left
        translate([0, -1, ih-pos]) {
            rotate([0, -45, 0]) {
                cube([1000, t+2, 1000]);
            }
        }
        // top right
        translate([iw-pos, -1, ih]) {
            rotate([0, 45, 0]) {
                cube([1000, t+2, 1000]);
            }
        }
        // sub hole
        translate([iw/2, -1, ih/2]) {
            rotate([270, 0, 0]) {
                // cutout diameter 353mm +- 0.5
                cylinder(d=subd, h=t+2, $fn=300);
                echo(str("Sub cutout diameter: ", subd));
            }
        }
    }
}

// back
translate([t, t+id, t]) {
    w = iw;
    h = ih;
    color("green") cube([w, t, h]);
    echo(str("Back: ", h, " x ", w));
}



// ports
port_yoffset = 3;
// bottom left
translate([t-sqrt((t*t)/2), port_yoffset, t+pos-sqrt((t*t)/2)]) {
    rotate([0, 45, 0]) {
        color("magenta") cube([pod, pl, t]);
    }
}
// bottom right
translate([t, port_yoffset, t+ih-pos]) {
    rotate([0, -45, 0]) {
        color("magenta") cube([pod, pl, t]);
    }
}

// top right
translate([t+iw-pos, port_yoffset, t+ih]) {
    rotate([0, 45, 0]) {
        color("magenta") cube([pod, pl, t]);
    }
}

// bottom right
translate([t+iw-pos+sqrt((t*t)/2), port_yoffset, t-sqrt((t*t)/2)]) {
    rotate([0, -45, 0]) {
        color("magenta") cube([pod, pl, t]);
    }
}

// volume
subv = 5; // litres, as a guess
portv = pos*pos/2 * (pl-t-front_setback) / 1000000;
boxv = iw * (id-front_setback) * ih / 1000000;
v = boxv - subv - portv;
echo(str("Box volume: ", v, " litres"));