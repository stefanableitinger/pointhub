#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import time
import sys
import random
import math
import re
import os

from colorsys import hsv_to_rgb

from PIL import Image, ImageDraw, ImageFont
from unicornhatmini import UnicornHATMini

# The text we want to display. You should probably keep this line and replace it below
# That way you'll have a guide as to what characters are supported!
text=""
unicornhatmini = UnicornHATMini()

rotation=0
repeat=False
offset=True
speed="1"
fontname="5x7.ttf"
start_y="-1"

if len(sys.argv) > 1:
    for arg in sys.argv:
        if arg=="-r":
            repeat=True
        if arg=="-o":
            offset=False

        if arg=="-s":
            speed=""
        if arg=="-f":
            fontname=""
        if arg=="-y":
            start_y=""

        if arg!=__file__ and arg!=os.path.basename(__file__) and arg!="-r" and arg!="-o" and arg!="-s" and arg!="-f" and speed!="" and fontname!="" and start_y!="":
            text+=arg+" "
            #print("adding argument {}",str(arg))

        if speed=="" and arg!="-s":
            speed=int(arg)
        if fontname=="" and arg!="-f":
            fontname=arg
        if start_y=="" and arg!="-y":
            start_y=int(arg)

#text=text[:-1]
#print("text to display {}",text)

unicornhatmini.set_rotation(rotation)
display_width, display_height = unicornhatmini.get_shape()

#print("{}x{}".format(display_width, display_height))

# Do not look at unicornhatmini with remaining eye
unicornhatmini.set_brightness(0.1)

# Load a nice 5x7 pixel font
# Granted it's actually 5x8 for some reason :| but that doesn't matter

font = ImageFont.truetype(fontname, 8)
#font = ImageFont.truetype("/home/k/Vdj.ttf", 8)
#font = ImageFont.truetype("/home/k/5x7.ttf", 8)

# Measure the size of our text, we only really care about the width for the moment
# but we could do line-by-line scroll if we used the height
text_width, text_height = font.getsize(text)

# Create a new PIL image big enough to fit the text
image = Image.new('P', (text_width+display_width*2, display_height), 0)
draw = ImageDraw.Draw(image)

# Draw the text into the image
if offset == True:
    draw.text((display_width, int(start_y)), text, font=font, fill=255)
else:
    draw.text((1, int(start_y)), text, font=font, fill=255)

offset_x = 0

while True:

    for x in range(display_width):
        for y in range(display_height):
            hue = (time.time() / 10.0) + (x / float(display_width * 2))
            r, g, b = [int(c * 255) for c in hsv_to_rgb(hue, 1.0, 1.0)]
            if image.getpixel((x + offset_x, y)) == 255:
                unicornhatmini.set_pixel(x, y, r, g, b)
            else:
                unicornhatmini.set_pixel(x, y, 0, 0, 0)

            if offset_x==0 and offset == False and x%3==0:
                unicornhatmini.show()

    offset_x += 1

    if (offset_x + display_width * 2 >= image.size[0] and offset == False) or (offset_x + display_width >= image.size[0] and offset == True):
        offset_x = 0
        unicornhatmini.clear()
        if repeat == False:
            break;

    unicornhatmini.show()

    wt=0.25
    wt=wt/float(speed)
    
    if wt<0:
        wt=0
    
    #if wt>0.4:
    #    wt=0.4

    #print wt    
    time.sleep(wt)
