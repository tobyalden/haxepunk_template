package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.motion.*;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import scenes.*;

class Peg extends Entity
{
    public static inline var BOUNCE_STRENGTH = 200;

    public function new(startX:Float, startY) {
        super(startX, startY);
        type = "peg";
        mask = new Hitbox(10, 10);
        graphic = new Image("graphics/peg.png");
    }
}
