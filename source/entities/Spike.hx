package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.masks.*;
import haxepunk.utils.*;

class Spike extends Entity
{
    public static inline var FLOOR = "floor";
    public static inline var CEILING = "ceiling";
    public static inline var LEFT_WALL = "leftwall";
    public static inline var RIGHT_WALL = "rightwall";

    public function new(x:Float, y:Float, width:Int, height:Int, orientation:String) {
        super(x, y);
        type = "hazard";
        if(orientation == FLOOR) {
            graphic = new TiledImage("graphics/spike_floor.png", width, height);
            mask = new Hitbox(width, height);
        }
        else if(orientation == CEILING) {
            graphic = new TiledImage("graphics/spike_ceiling.png", width, height);
            mask = new Hitbox(width, height);
        }
        else if(orientation == LEFT_WALL) {
            graphic = new TiledImage("graphics/spike_leftwall.png", width, height);
            mask = new Hitbox(width, height);
        }
        else {
            graphic = new TiledImage("graphics/spike_rightwall.png", width, height);
            mask = new Hitbox(width, height);
        }
    }
}
