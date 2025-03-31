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
    private var curtain:Curtain;

    override public function begin() {
        curtain = new Curtain();
        add(curtain);
        curtain.fadeOut(0.25);

        var level = new Level("level");
        add(level);
        for(entity in level.entities) {
            add(entity);
        }
    }

    override public function update() {
        super.update();
    }

    public function onDeath() {
        HXP.alarm(0.25, function() {
            curtain.fadeIn(0.25);
        });
        HXP.alarm(0.5, function() {
            HXP.scene = new GameScene();
        });
    }
}
