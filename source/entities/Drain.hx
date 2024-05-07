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

class Drain extends Entity
{
    public static inline var PULL_STRENGTH = 150;

    public function new(startX:Float, startY:Float, startWidth:Int, startHeight:Int) {
        super(startX, startY);
        type = "drain";
        mask = new Hitbox(startWidth, startHeight);
        graphic = new ColoredRect(width, height, 0x808080);
    }
}
