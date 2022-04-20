/*
    This is now being modified for a Pico Ducky!
    Modified and now made by: Aask
    Original model: github.com/revk/PCBCase.git
    
    Designed to allow the Picoducky to be completely in the box, resiliant to
    dust and pokey fingers.
    
    * Configurable connector holes
    * Either holes, for screws/bolts, or mounting pins for the picoducky
        
    TODO:
    * Fix lip on lid to be centered
    * Validate bottom text prints as expected
    * Tighten USB hole
    * Document more of the sections
*/

// THINGIVERSE customizer does not understand true/flase, so use 1/0 instead

/* [parts] */
make_bottom=1;   // [0:No,1:Yes] 
make_top=0;      // [0:No,1:Yes] 
make_sliders=0;

/* [connectors] */
usb_cable_hole = 1; // [0:No,1:Yes] 
power_hole = 0;  // [0:No,1:Yes] 
selector_switch_hole = 1;   // [0:No,1:Yes] 
usb_hole = 0;    // [0:No,1:Yes] 
camera_hole = 0; // [0:No,1:Yes] 
gpio_hole = 0;   // [0:No,1:Yes] 
pins = 1;        // [0:No,1:Yes] 

/* [box] */
// gap around picoducky inside the box
gap = 1.0;
// wall thickness of box
shell_thickness = 1.6;
// standoffs picoducky sits on in the box
standoffs = 1.5;

/* [Text on lid] */
// Add an engraved text on the top, 'help->font list' for available
add_text = 1;  // [0:No,1:Yes]
lid_text = "picoducky";

text_font="Dyslexie";
/* [picoducky options] */
// show an engineering model
dummy_picoducky = 0;  // [0:No,1:Yes] 
// do we need height for a header
//pd_header = 0; // not tested, problems with heights 
// allow for solder on bottom, standoffs take care of this
//pd_solder = 0;    // don't need to allow for this as we have standoffs

// the picoducky engineering model with the measurements we use, includes don't work in thingiverse customizer
//include <picoduckyw.scad>;

//////////////////////////////
//
// Start of included picoducky engineering model
//
////////////////////
/* [picoducky dimensions DO NOT ALTER] */
/* [pico ducky dimensions YOU'RE NOT MY REAL MOM] */

pd_length = 67; // not including sd card protrusion
pd_width = 36;  // not including any connector protrusions
pd_pcb_thickness = 1.53; // including solder mask
pd_component_max_height = (3.1 - pd_pcb_thickness); // hdmi is max
pd_rounded_edge_offset = 1.0;
pd_botton_pin_height = 1.0;  // solder pins for gpio connector

pd_mount_hole_dia = 3.25; 
pd_mount_hole_offset = 3.1; // from edge
pd_mount_hole_dia_clearance = 7; 

pd_gpio_length = 50.8; // total 
pd_gpio_width = 5;  // total
pd_gpio_x_offset = 32.5;  // from left hand edge to centre of connector
pd_gpio_y_offset = 3.5; // long edge centre form pcb edge
pd_gpio_height = (10 - pd_pcb_thickness); // wihtout pcb thickness

pd_usb_hole_y_offset = 17.68;
pd_usb_hole_length = 15; // sdcard present
pd_usb_hole_width = 12;
pd_usb_hole_protrusion = 2.3; // sdcard present
pd_usb_hole_height = (10.6 - pd_pcb_thickness); 

pd_camera_y_offset = 15;
pd_camera_length = 5;
pd_camera_width = 10;
pd_camera_protrusion = 1.1; // no cable present
pd_camera_height = 10;//(2.65 - pd_pcb_thickness);

pd_hdmi_x_offset = 12.4;
pd_hdmi_length = 11.2;
pd_hdmi_width = 7.6;
pd_hdmi_protrusion = 0.5; // no cable present
pd_hdmi_height = (4.7 - pd_pcb_thickness);

pd_usb_power_x_offset = 54;
pd_usb_x_offset = 41.4;
pd_usb_length = 8;
pd_usb_width = 5.6;
pd_usb_protrusion = 1; // no cable present
pd_usb_height = (3.96 - pd_pcb_thickness);

pd_max_length = pd_length + pd_usb_hole_protrusion + pd_camera_protrusion;
pd_max_width = pd_width + pd_usb_protrusion;

slider_hole_one = 28.5;
slider_hole_two = 52;
slider_hole_three = 10.5;
///////////////////////////////////
//
// End of picoducky definitions
//
////////////////////

//////////////////////////////////
//
// Start of picoducky functions/modules
//
////////////////////////
function pd_get_max_height(gpio_header, gpio_solder) =
    pd_pcb_thickness  + 
    (pd_botton_pin_height * (gpio_solder?1:0)) + 
    (pd_gpio_height * (gpio_header?1:0)) +
    (pd_component_max_height * (gpio_header?0:1));


module pdw(gpio_header = true, gpio_solder = true) { 

    pd_max_height = pd_get_max_height(gpio_header, gpio_solder);
    
    echo("pi max length ", pd_max_length);
    echo("pi max width  ", pd_max_width);
    echo("pi max height ", pd_max_height);

    module pdw_solid() {
        // rounded edges on pcb
        x_round = [pd_rounded_edge_offset, (pd_length - pd_rounded_edge_offset)];
        y_round= [pd_rounded_edge_offset, (pd_width - pd_rounded_edge_offset)];
        for (x = x_round, y = y_round)
            translate([x, y, 0])
            {
                $fn = 40;
                cylinder(d=(2*pd_rounded_edge_offset), h=pd_pcb_thickness);
            }  

        // pcb split into bits to conform with rounded edges
        translate([pd_rounded_edge_offset, 0, 0])
            cube([pd_length - (2 * pd_rounded_edge_offset), pd_width, pd_pcb_thickness]);
        translate([0, pd_rounded_edge_offset, 0])
            cube([pd_length, pd_width - (2 * pd_rounded_edge_offset), pd_pcb_thickness]);

        // gpio 
        if (gpio_header)
        translate([pd_gpio_x_offset-(pd_gpio_length/2), 
                  (pd_width-pd_gpio_y_offset-(pd_gpio_width/2)), 
                  pd_pcb_thickness])
         #    cube([pd_gpio_length, pd_gpio_width, pd_gpio_height]);

        // gpio underside solder
        if (gpio_solder)
        translate([pd_gpio_x_offset-(pd_gpio_length/2), 
                  (pd_width-pd_gpio_y_offset-(pd_gpio_width/2)), 
                  -pd_botton_pin_height])
            cube([pd_gpio_length, pd_gpio_width, pd_botton_pin_height]);
        
        // ~~sdcard~~
        // USB Cable hole
        translate([-pd_usb_hole_protrusion, 
                  (pd_usb_hole_y_offset-(pd_usb_hole_width/2)), 
                  pd_pcb_thickness])
            cube([pd_usb_hole_length, pd_usb_hole_width, pd_usb_hole_height]);

        // camera
        translate([(pd_length - pd_camera_length + pd_camera_protrusion), 
                   (pd_camera_y_offset-(pd_camera_width/2)), 
                    pd_pcb_thickness])
            cube([pd_camera_length, pd_camera_width, pd_camera_height]);
            
        // hdmi 
        translate([(pd_hdmi_x_offset - (pd_hdmi_length/2)), 
                   -pd_hdmi_protrusion, 
                    pd_pcb_thickness])
            cube([pd_hdmi_length, pd_hdmi_width, pd_hdmi_height]);
            
        // usb power 
        translate([(pd_usb_power_x_offset - (pd_usb_length/2)), 
                   -pd_usb_protrusion, 
                    pd_pcb_thickness])
            cube([pd_usb_length, pd_usb_width, pd_usb_height]);
        
        // usb 
        translate([(pd_usb_x_offset - (pd_usb_length/2)), 
                   -pd_usb_protrusion, 
                    pd_pcb_thickness])
            cube([pd_usb_length, pd_usb_width, pd_usb_height]);
    }
    
    // make 0,0,0 centre
    translate([pd_camera_protrusion+pd_camera_protrusion-pd_max_length/2, 
               pd_usb_protrusion-pd_max_width/2, 
               0])
    difference () {
        pdw_solid();

        // mounting holes
        x_holes = [pd_mount_hole_offset, (pd_length - pd_mount_hole_offset)];
        y_holes = [pd_mount_hole_offset, (pd_width - pd_mount_hole_offset)];
        for (x = x_holes, y = y_holes)
            translate([x, y, -pd_pcb_thickness])
            {
                $fn = 40;
                cylinder(d=pd_mount_hole_dia, h=10);
            }
   }
}
////////////////////////////////////////
//
// End of picoducky functions/modules
//
////////////////////////////

case_inside_length = pd_max_length + 2*gap;
case_inside_width = pd_max_width + 2*gap;
case_inside_height = pd_get_max_height(true, true) + standoffs; 

case_outside_length = case_inside_length + (2*shell_thickness);
case_outside_width = case_inside_width + (2*shell_thickness);
case_outside_height = case_inside_height; //+ (2*shell_thickness);

module rounded_box(length, 
             width, 
             height, 
             rounded_edge_radius) 
{    
    
    // rounded edges
    x_round = [rounded_edge_radius, (length - rounded_edge_radius)];
    y_round= [rounded_edge_radius, (width - rounded_edge_radius)];
    for (x = x_round, y = y_round)
        translate([x, y, 0])
        {
            $fn = 40;
            cylinder(d=(2*rounded_edge_radius), h=height);
        }  

    // pcb split into bits to conform with rounded edges
    translate([rounded_edge_radius, 0, 0])
        cube([length - (2 * rounded_edge_radius), 
                width, 
                height]);
    translate([0, rounded_edge_radius, 0])
        cube([length, 
                width - (2 * rounded_edge_radius), 
                height]);    
}

module shell(inside_length, 
             inside_width, 
             inside_height, 
             thickness, 
             rounded_edge_radius) 
{
    difference () 
    {
        // outside
        translate([-thickness, -thickness, -thickness])
            rounded_box(case_outside_length, 
                case_outside_width, 
                case_outside_height,
                rounded_edge_radius);
    
        // inside, remove top by extending it through the outside
        rounded_box(inside_length, inside_width, case_outside_height+1, rounded_edge_radius);
        
        if (usb_cable_hole) {
            offset = 12.4 + gap; // magic number for centre line
            translate([-case_outside_length/8, offset, standoffs+pd_pcb_thickness +0])
                #cube([case_outside_length/4, pd_usb_hole_width+3, pd_usb_hole_height]);
        }
        
        if (usb_hole) {
            offset = 37.9 + gap;
            translate([offset, -case_outside_width/4, standoffs-0.6])
                #cube([pd_usb_length+3.5, case_outside_length/4, 7]);
        }

        if (power_hole) {
            offset = 50.5 + gap;
            translate([offset, -case_outside_width/4, standoffs-0.6])
                #cube([pd_usb_length+3.5, case_outside_length/4, 7]);
        }
        
        // hole for camera
        if (camera_hole) {
            offset = 8.5 + gap;
            translate([case_outside_length/1.25, offset, (standoffs+pd_pcb_thickness)])
                #cube([case_outside_length/4, pd_camera_width-2, 1.2]);
        }

        // Hole for selector switch
        if (selector_switch_hole) {
            offset = slider_hole_one + gap;
            translate([offset, -case_outside_width/4, standoffs+pd_pcb_thickness/2 + 2])
                #cube([14, case_outside_length/4, 3]);
        }
        if (selector_switch_hole) {
            offset = slider_hole_two + gap;
            translate([offset, -case_outside_width/4, standoffs+pd_pcb_thickness/2 + 4])
                #cube([10, case_outside_length/4, 4]);
        }
        if (selector_switch_hole) {
            offset = slider_hole_three + gap;
            translate([offset, -case_outside_width/4, standoffs+pd_pcb_thickness/2 + 4])
                #cube([10, case_outside_length/4, 4]);
        }
        
    }
}

module bottom_shell() {
    translate([-case_inside_length/2, -case_inside_width/2, 0])
        shell(case_inside_length, 
              case_inside_width, 
              case_inside_height, 
              shell_thickness, 
              pd_rounded_edge_offset);

    // mounting standoffs and pins for picoducky
    translate([pd_camera_protrusion+pd_camera_protrusion-pd_max_length/2,
                pd_usb_protrusion-pd_max_width/2, 0]) 
    {
        x_pins = [pd_mount_hole_offset, (pd_length - pd_mount_hole_offset)];
        y_pins = [pd_mount_hole_offset, (pd_width - pd_mount_hole_offset)];
        for (x = x_pins, y = y_pins)
            translate([x, y, 0])
            {
                $fn = 40;
                cylinder(d=pd_mount_hole_dia_clearance, h=standoffs);
                translate([0, 0, standoffs])
                    if (pins) 
                    {
                        // allow for some slack in the hole diameter, 0.9
                        // pins longer then pcb is thick so pcb can't slip out
                        cylinder(d=(pd_mount_hole_dia*0.9), h=2*pd_pcb_thickness);
                    }
            }
    }  
    
    // for reference we can add a dummy picoducky
    if (dummy_picoducky) {
        color("yellow")
            translate([0, 0, standoffs]) // add 20 for outside box
                pdw(true, true);
    }
}


module bottom() {
    difference() 
    {
        bottom_shell();
        // holes right through instead of pins
        if (!pins) 
        {
            translate([pd_camera_protrusion+pd_camera_protrusion-pd_max_length/2,
                    pd_usb_protrusion-pd_max_width/2, 0]) 
            {
                x_pins = [pd_mount_hole_offset, (pd_length - pd_mount_hole_offset)];
                y_pins = [pd_mount_hole_offset, (pd_width - pd_mount_hole_offset)];
                for (x = x_pins, y = y_pins)
                    translate([x, y, 0])
                    {
                        $fn = 40;
                        translate([0, 0, -2*shell_thickness])
                            #cylinder(d=(pd_mount_hole_dia*1.1), h=2*case_inside_height);
                    }
            }
        }
        if(add_text) 
            {
                depth = 1;
            
            rotate([180,0,0])
            translate([0,-14,1])
            linear_extrude(5, convexity=4) 
                        text("Case by Aask", font=text_font,size=3.5, valign="top", halign="center");
            
            rotate([180,0,180])
            translate([0,-20,1])
            linear_extrude(5, convexity=4) 
                        text("4321", font=text_font,size=2.5, valign="bottom", halign="center");
            rotate([180,0,180])
            translate([0,-15,1])
            linear_extrude(5, convexity=4) 
                        text("PAYLOAD", font=text_font,size=2.5, valign="bottom", halign="center");
            
            rotate([180,0,180])
            translate([-13.5,-20,1])
            linear_extrude(5, convexity=4) 
                        text("PWN/NO", font=text_font,size=2, valign="bottom", halign="right");
            
            rotate([180,0,180])
            translate([11,-20,1])
            linear_extrude(5, convexity=4) 
                        text("PWN/MNT", font=text_font,size=2, valign="bottom", halign="left");
            }
            
   
    }
}

module top_with_rim() {
    // add an extra layer on top to cover the gpio hole
    lid_thickness = (gpio_hole)?(shell_thickness):(shell_thickness+1);
    rounded_box(case_outside_length, case_outside_width, lid_thickness, pd_rounded_edge_offset);
    
    // need to make a rim/gland
    translate([shell_thickness, shell_thickness, -2*shell_thickness]) 
    {
        // translate to make sure that rim is part of the top
        translate([0,0,0.5]) 
        difference() 
        {
            rounded_box(case_outside_length - 2*shell_thickness, 
                         case_outside_width - 2*shell_thickness, 
                         2*shell_thickness, 
                         pd_rounded_edge_offset);
            
            // make a gland type rim by extending through the inside box
            translate([shell_thickness, shell_thickness, -shell_thickness])
                rounded_box(case_inside_length - 2*shell_thickness, 
                            case_inside_width - 2*shell_thickness, 
                            3*shell_thickness, 
                            pd_rounded_edge_offset);
            
            if (selector_switch_hole) {
                offset = 8.0 + gap;
                translate([offset, -case_outside_width/4, -1.3])
                    #cube([15, case_outside_length/4, 4]);
            }
            if (selector_switch_hole) {
                offset = 49.5 + gap;
                translate([offset, -case_outside_width/4, -1.3])
                    #cube([15, case_outside_length/4, 4]);
            }
            if (usb_cable_hole) {
                offset = 12.4 + gap; // magic number for centre line
                translate([-case_outside_length/8, offset, -4.3])
                    #cube([case_outside_length/4, pd_usb_hole_width+3, 7]);
            }
        }
    }

}

module top () {
    color("orange")
    
    translate([-case_inside_length/2-shell_thickness, 
                -case_inside_width/2-shell_thickness, 
                case_outside_height+shell_thickness]) 
        difference () 
        {
            top_with_rim();
         
            // always cut out for gpio pins
            offset_x = 9.9 + gap; // magic numbers
            offset_y = 25.4 + gap;
            //translate([offset_x, offset_y, -3*shell_thickness])
            //    #cube([pd_gpio_length+2, 
             //          pd_gpio_width+2,
             //          4*shell_thickness+0.3]);
            
            // a notch to make taking top of easier
             translate([0, 10+gap, -0.1])
                cube([shell_thickness, 
                       15,
                       shell_thickness*0.6]);
            
            // text, really deep text if we have no gpio cutout
            if(add_text) 
            {
                translate([case_outside_length/2,case_outside_width*0.6,shell_thickness*0.5]) 
                    linear_extrude(5, convexity=4) 
                        text(lid_text, font=text_font,size=9, valign="center", halign="center");
                
                translate([case_outside_length/2,case_outside_width*0.15,shell_thickness*0.5]) 
                    linear_extrude(5, convexity=4) 
                        text("by Dave Bailey", font=text_font,size=4, valign="bottom", halign="center");
            }
        }
    
    if (pins)
    {
        // add locking pins to lid
        // values iteratively found 
        translate([pd_camera_protrusion+pd_camera_protrusion-pd_max_length/2, 
                    pd_usb_protrusion-pd_max_width/2,
                    case_outside_height - 4*shell_thickness]) 
        {
            x_pins = [pd_mount_hole_offset, (pd_length - pd_mount_hole_offset)];
            y_pins = [pd_mount_hole_offset, (pd_width - pd_mount_hole_offset)];
            for (x = x_pins, y = y_pins)
                translate([x, y, 0])
                {
                    //translate([0, 0, -2*shell_thickness])
                    difference ()
                    {
                        $fn = 40;
                        length = 10; //magic
                        cylinder(d=pd_mount_hole_dia_clearance*0.9, h=length);
                        cylinder(d=pd_mount_hole_dia*1.1, h=length);
                    }
                }
        }
            
    }
}
module sliders() {
    make_sliders();
}

module make_sliders () 
{
    outline = [[-1.380017,-5.500004],[-2.853311,-4.441672],[-6.557473,-4.441672],[-6.557473,-3.383340],[-1.530396,-3.383340],[-1.530396,-1.235989],[-4.403254,-1.257206],[-5.661727,-1.058864],[-5.576582,-0.456093],[-4.418588,0.735981],[-3.364831,1.427971],[-2.850527,1.946951],[-2.853306,5.500004],[-1.001230,5.499989],[-1.001222,0.585413],[1.000944,0.584990],[1.001235,5.499982],[2.702950,5.499997],[2.580926,3.051448],[2.718963,1.946949],[3.277903,1.427971],[4.418588,0.735981],[5.640832,-0.456093],[5.747394,-1.058864],[4.467504,-1.257206],[1.530396,-1.235989],[1.530396,-3.383340],[6.557473,-3.383340],[6.557473,-4.441672],[2.853311,-4.441672],[1.380017,-5.500004],[0.142369,-5.500004],[0.028164,-5.500004],[-0.028164,-5.500004],[-0.142368,-5.500004],[-1.380017,-5.500004]];
    translate([0, 0, 0])
      linear_extrude(3.5) {polygon(outline);}


        //#cube([13.5, case_outside_length/4, 3.5]);
    
}

/*
// something doesn't add up, measured prints do not equate
echo("inside length ", case_inside_length);
echo("inside width  ", case_inside_width);
echo("inside height  ", case_inside_height);

echo("outside length ", case_outside_length);
echo("outside width  ", case_outside_width);
echo("outside height ", case_outside_height);
*/

if (make_bottom) bottom();
if (make_top) top();
if (make_sliders) sliders();
