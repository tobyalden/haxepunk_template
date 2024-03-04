package entities;

import haxepunk.*;
import haxepunk.graphics.*;
import haxepunk.input.*;
import haxepunk.masks.*;
import haxepunk.math.*;
import haxepunk.Tween;
import haxepunk.tweens.misc.*;
import scenes.*;

class Player extends Entity
{
    public static inline var MAX_RUN_SPEED = 100;
    public static inline var MAX_AIR_SPEED = 150;
    public static inline var RUN_ACCEL = 1300;
    public static inline var AIR_ACCEL = 800;
    public static inline var GRAVITY = 800;
    public static inline var JUMP_POWER = 300;
    public static inline var JUMP_CANCEL = 50;
    public static inline var WALL_JUMP_POWER_X = MAX_AIR_SPEED;
    public static inline var WALL_JUMP_POWER_Y = 275;
    public static inline var MAX_FALL_SPEED = 400;
    public static inline var MAX_FALL_SPEED_ON_WALL = 50;
    public static inline var COYOTE_TIME = 1 / 60 * 5;
    public static inline var JUMP_BUFFER_TIME = 1 / 60 * 5;
    public static inline var WALL_STICK_TIME = 0.2;

    private var sprite:Spritemap;
    private var velocity:Vector2;
    private var timeOffGround:Float;
    private var timeJumpHeld:Float;
    private var timeWallStuck:Float;

    public function new(x:Float, y:Float) {
        super(x, y);
        name = "player";
        mask = new Hitbox(10, 10);
        sprite = new Spritemap("graphics/player.png", 10, 10);
        sprite.add("idle", [0]);
        sprite.play("idle");
        graphic = sprite;
        velocity = new Vector2();
        timeOffGround = 0;
        timeJumpHeld = 0;
        timeWallStuck = 0;
    }

    override public function update() {
        movement();
        super.update();
        if(Input.check("jump")) {
            timeJumpHeld += HXP.elapsed;
        }
        else {
            timeJumpHeld = 0;
        }
    }

    private function movement() {
        if(isOnGround()) {
            timeOffGround = 0;
            if(Input.check("left") && !isOnLeftWall()) {
                velocity.x -= RUN_ACCEL * HXP.elapsed;
            }
            else if(Input.check("right") && !isOnRightWall()) {
                velocity.x += RUN_ACCEL * HXP.elapsed;
            }
            else {
                velocity.x = MathUtil.approach(
                    velocity.x, 0, RUN_ACCEL * HXP.elapsed
                );
            }
        }
        else {
            timeOffGround += HXP.elapsed;
            if(isOnWall()) {
                if(
                    isOnLeftWall() && Input.check("right")
                    || isOnRightWall() && Input.check("left")
                ) {
                    timeWallStuck += HXP.elapsed;
                }
                else {
                    timeWallStuck = 0;
                }
            }
            if(!isOnWall() || timeWallStuck >= WALL_STICK_TIME) {
                if(Input.check("left") && !isOnLeftWall()) {
                    velocity.x -= AIR_ACCEL * HXP.elapsed;
                }
                else if(Input.check("right") && !isOnRightWall()) {
                    velocity.x += AIR_ACCEL * HXP.elapsed;
                }
                else {
                    velocity.x = MathUtil.approach(
                        velocity.x, 0, AIR_ACCEL * HXP.elapsed
                    );
                }
            }
        }

        var maxSpeed = isOnGround() ? MAX_RUN_SPEED : MAX_AIR_SPEED;
        velocity.x = MathUtil.clamp(velocity.x, -maxSpeed, maxSpeed);

        if(isOnGround()) {
            velocity.y = 0;
        }
        else {
            if(Input.released("jump") && velocity.y < -JUMP_CANCEL) {
                velocity.y = -JUMP_CANCEL;
            }
        }

        if(isOnGround() || timeOffGround <= COYOTE_TIME) {
            if(
                Input.pressed("jump")
                || Input.check("jump") && timeJumpHeld <= JUMP_BUFFER_TIME
            ) {
                velocity.y = -JUMP_POWER;
            }
        }
        else if(isOnWall()) {
            if(
                Input.pressed("jump")
                || Input.check("jump") && timeJumpHeld <= JUMP_BUFFER_TIME
            ) {
                velocity.y = -WALL_JUMP_POWER_Y;
                if(isOnLeftWall()) {
                    velocity.x = WALL_JUMP_POWER_X;
                }
                else {
                    velocity.x = -WALL_JUMP_POWER_X;
                }
            }
        }

        var gravity:Float = GRAVITY;
        if(Math.abs(velocity.y) < JUMP_CANCEL) {
            gravity *= 0.5;
        }
        velocity.y += gravity * HXP.elapsed;

        velocity.y = Math.min(
            velocity.y,
            isOnWall() ? MAX_FALL_SPEED_ON_WALL : MAX_FALL_SPEED
        );

        moveBy(
            velocity.x * HXP.elapsed,
            velocity.y * HXP.elapsed,
            ["walls"]
        );
    }

    override public function moveCollideX(e:Entity) {
        velocity.x = 0;
        return true;
    }

    override public function moveCollideY(e:Entity) {
        velocity.y = 0;
        return true;
    }

    private function isOnGround() {
        return collide("walls", x, y + 1) != null;
    }

    private function isOnWall() {
        return isOnLeftWall() || isOnRightWall();
    }

    private function isOnLeftWall() {
        return collide("walls", x - 1, y) != null;
    }

    private function isOnRightWall() {
        return collide("walls", x + 1, y) != null;
    }
}


