import hxd.Key;

enum HeroState {
    Standing;
    Walking;
}

class Hero extends h2d.Object {
    static var speed = 60.0;
    static var animationSpeed = 10;

    var game: Game;

    var anim: h2d.Anim;
    var standingLeft: Array<h2d.Tile>;
    var walkingLeft: Array<h2d.Tile>;
    var standingRight: Array<h2d.Tile>;
    var walkingRight: Array<h2d.Tile>;
    var standingUp: Array<h2d.Tile>;
    var walkingUp: Array<h2d.Tile>;
    var standingDown: Array<h2d.Tile>;
    var walkingDown: Array<h2d.Tile>;

    var state: HeroState;
    var direction: Direction;

    public function new(game: Game) {
        super();
        this.game = game;

        var tiles = hxd.Res.atlas.toTile();

        standingRight = [
            tiles.sub(0, 0, 32, 32, -16, -27)
        ];
        walkingRight = [
            for (i in 1...7) {
                tiles.sub(i * 32, 0, 32, 32, -16, -27);
            }
        ];

        standingLeft = [
            tiles.sub(0, 32, 32, 32, -16, -27)
        ];
        walkingLeft = [
            for (i in 1...7) {
                tiles.sub(i * 32, 32, 32, 32, -16, -27);
            }
        ];

        standingDown = [
            tiles.sub(0, 64, 32, 32, -16, -27)
        ];
        walkingDown = [
            for (i in 0...4) {
                tiles.sub(i * 32, 64, 32, 32, -16, -27);
            }
        ];

        standingUp = [
            tiles.sub(0, 96, 32, 32, -16, -27)
        ];
        walkingUp = [
            for (i in 0...4) {
                tiles.sub(i * 32, 96, 32, 32, -16, -27);
            }
        ];

        anim = new h2d.Anim(animationSpeed, this);

        this.x = 180;
        this.y = 92;

        state = Standing;
        direction = Left;
        setAnim();
    }

    public function update(dt: Float) {
        var previousState = state;
        var previousDirection = direction;

        var dx = 0;
        var dy = 0;
        if(Key.isDown(Key.LEFT) || Key.isDown("Q".code) || Key.isDown("A".code)) {
            dx--;
        }
        if(Key.isDown(Key.RIGHT) || Key.isDown("D".code)) {
            dx++;
        }
        if(Key.isDown(Key.UP) || Key.isDown("Z".code) || Key.isDown("W".code)) {
            dy--;
        }
        if(Key.isDown(Key.DOWN) || Key.isDown("S".code)) {
            dy++;
        }

        var actualDx = 0.0;
        var actualDy = 0.0;
        if (dx != 0 || dy != 0) {
            var l = speed * dt;
            var d = Math.sqrt(dx*dx + dy*dy);
            if (!game.level.checkCollision(this.x + l*dx/d, this.y + l*dy/d, false)) {
                actualDx = l*dx/d;
                actualDy = l*dy/d;
            } else if (dx != 0 && !game.level.checkCollision(this.x + l*dx/Math.abs(dx), this.y, false)) {
                actualDx = l*dx/Math.abs(dx);
            } else if (dy != 0 && !game.level.checkCollision(this.x, this.y + l*dy/Math.abs(dy), false)) {
                actualDy = l*dy/Math.abs(dy);
            }
        }

        this.x += actualDx;
        this.y += actualDy;

        state = Standing;
        if (actualDx*actualDx + actualDy*actualDy > 0.01) {
            state = Walking;
        }

        if (actualDx > 0.1) {
            direction = Right;
        } else if (actualDx < -0.1) {
            direction = Left;
        } else if (actualDy > 0.1) {
            direction = Down;
        } else if (actualDy < -0.1) {
            direction = Up;
        }

        if (Key.isPressed(Key.SPACE) && game.level.isNearFire(this.x, this.y)) {
            game.fire.blow();
        }

        if (state != previousState || direction != previousDirection) {
            setAnim();
        }
    }

    private function setAnim() {
        switch [state, direction] {
            case [Standing, Right]: anim.play(standingRight, 0);
            case [Standing, Left]: anim.play(standingLeft, 0);
            case [Standing, Up]: anim.play(standingUp, 0);
            case [Standing, Down]: anim.play(standingDown, 0);
            case [Walking, Right]: anim.play(walkingRight, 0);
            case [Walking, Left]: anim.play(walkingLeft, 0);
            case [Walking, Up]: anim.play(walkingUp, 0);
            case [Walking, Down]: anim.play(walkingDown, 0);
        }
    }
}
