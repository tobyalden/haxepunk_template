package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.*;
import haxepunk.tweens.misc.*;
import haxepunk.utils.*;
import scenes.*;

class Player extends Entity
{
    public static inline var ACCEL = 400 * 2;
    public static inline var DECEL = 100;
    public static inline var MAX_SPEED = 200;
    public static inline var JUMP_HEIGHT = 50;
    public static inline var JUMP_TIME = 0.25;

    private var sprites:Graphiclist;
    private var ballSprite:Image;
    private var shadowSprite:Image;
    private var velocity:Vector2;
    private var jump:VarTween;
    private var z:Int;

    public function new(x:Float, y:Float) {
        super(x, y);
        mask = new Hitbox(10, 10);
        ballSprite = new Image("graphics/player.png");
        shadowSprite = new Image("graphics/shadow.png");
        graphic = new Graphiclist([shadowSprite, ballSprite]);
        velocity = new Vector2();
        z = 0;
        jump = new VarTween(TweenType.PingPong);
        jump.onComplete.bind(function() {
            if(jump.forward) {
                jump.active = false;
            }
        });
        addTween(jump);
    }

    override public function update() {
        movement();
        collisions();
        animation();
        super.update();
    }

    private function movement() {
        var heading = new Vector2();
        if(Input.check("left")) {
            heading.x = -1;
        }
        else if(Input.check("right")) {
            heading.x = 1;
        }
        else {
            heading.x = 0;
        }
        if(Input.check("up")) {
            heading.y = -1;
        }
        else if(Input.check("down")) {
            heading.y = 1;
        }
        else {
            heading.y = 0;
        }

        if(heading.length == 0) {
            velocity.normalize(MathUtil.approach(velocity.length, 0, HXP.elapsed * DECEL));
        }
        else {
            var accel = heading;
            accel.normalize(ACCEL * HXP.elapsed);
            velocity.add(accel);
        }

        var drains = [];
        HXP.scene.getType("drain", drains);
        for(drain in drains) {
            var towardsDrain = new Vector2(
                drain.centerX - centerX,
                drain.centerY - centerY
            );
            var drainDistance = distanceFrom(drain, true);
            var distanceMultiplier = MathUtil.clamp(200 / drainDistance, 1, 2);
            towardsDrain.normalize(
                Drain.PULL_STRENGTH * distanceMultiplier * HXP.elapsed
            );
            velocity.add(towardsDrain);
        }

        if(velocity.length > MAX_SPEED) {
            velocity.normalize(MAX_SPEED);
        }

        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, ["walls"]);

        if(Input.pressed("jump") && !jump.active) {
            jump.tween(this, "z", JUMP_HEIGHT, JUMP_TIME, Ease.expoInOut);
            HXP.scene.camera.shake(0.1, 2);
        }
    }

    private function collisions() {
        if(collide("pit", x, y) != null) {
            getScene().onDeath();
        }
    }

    private function animation() {
        if(jump.active) {
            ballSprite.y = -z;
        }
        else {
            ballSprite.y = 0;
        }
    }

    private function getScene() {
        return cast(HXP.scene, GameScene);
    }
}
