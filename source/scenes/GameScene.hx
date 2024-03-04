package scenes;

import entities.*;
import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.graphics.tile.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import openfl.Assets;

class GameScene extends Scene
{
    public static inline var GAME_WIDTH = 270;
    public static inline var GAME_HEIGHT = 360;

    private var player:Player;
    private var chunks:Array<Level>;
    private var totalHeight:Int;

    override public function begin() {
        var start = new Level("start");
        for(entity in start.entities) {
            if(entity.name == "player") {
                player = cast(entity, Player);
            }
            add(entity);
        }
        add(start);
        chunks = [start];
        totalHeight = 0;
    }

    private function addChunk() {
        var chunk = new Level("0");
        totalHeight += chunk.height;
        chunk.y = -totalHeight;
        add(chunk);
    }

    override public function update() {
        //trace('player.y: ${player.y}, -totalHeight: ${-totalHeight}');
        if(player.y < -totalHeight + GAME_HEIGHT * 0.75) {
            addChunk();
        }
        super.update();
        camera.y = player.centerY - GAME_HEIGHT / 2;
    }
}
