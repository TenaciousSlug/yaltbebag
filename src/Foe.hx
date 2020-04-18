import hxd.Key;

enum FoeAnimState {
    Standing;
    Walking;
}

enum FoeState {
    Patroling;
    Following(destX: Float, destY: Float);
    Looking(delay: Float);
}

class Foe extends h2d.Object {
    static var walkingSpeed = 30.0;
    static var walkingAnimationSpeed = 5;
    static var runningSpeed = 70.0;
    static var runningAnimationSpeed = 12;
    static var lookingDelay = 2.0;

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

    var state: FoeState;
    var animState: FoeAnimState;
    var direction: Direction;

    public function new(game: Game) {
        super();
        this.game = game;

        var tiles = hxd.Res.atlas.toTile();

        standingRight = [
            tiles.sub(0, 128, 32, 32, -16, -27)
        ];
        walkingRight = [
            for (i in 1...7) {
                tiles.sub(i * 32, 128, 32, 32, -16, -27);
            }
        ];

        standingLeft = [
            tiles.sub(0, 160, 32, 32, -16, -27)
        ];
        walkingLeft = [
            for (i in 1...7) {
                tiles.sub(i * 32, 160, 32, 32, -16, -27);
            }
        ];

        standingDown = [
            tiles.sub(0, 192, 32, 32, -16, -27)
        ];
        walkingDown = [
            for (i in 0...4) {
                tiles.sub(i * 32, 192, 32, 32, -16, -27);
            }
        ];

        standingUp = [
            tiles.sub(0, 224, 32, 32, -16, -27)
        ];
        walkingUp = [
            for (i in 0...4) {
                tiles.sub(i * 32, 224, 32, 32, -16, -27);
            }
        ];

        anim = new h2d.Anim(walkingAnimationSpeed, this);

        this.x = 30;
        this.y = 40;

        state = Patroling;
        animState = Standing;
        direction = Right;
        setAnim();
    }

    public function update(dt: Float) {
        var previousAnimState = animState;
        var previousDirection = direction;

        // TODO: check if the hero is too close

        // Look for the hero
        var ray = new h2d.col.Ray(
            new h2d.col.Point(this.x, this.y),
            new h2d.col.Point(game.hero.x, game.hero.y));
        if (!game.level.obstructed(ray)) {
            state = Following(game.hero.x, game.hero.y);
        }

        var dx = 0.0;
        var dy = 0.0;
        var speed = walkingSpeed;
        switch state {
        case Following(destX, destY):
            if (Math.abs(this.x - destX) < 1 && Math.abs(this.y - destY) < 1) {
                state = Looking(lookingDelay);
            } else {
                speed = runningSpeed;
                anim.speed = runningAnimationSpeed;
                dx = destX - this.x;
                dy = destY - this.y;
            }
        case Patroling:
            speed = walkingSpeed;
            anim.speed = walkingAnimationSpeed;
            // TODO:
            dx = 1.0;
            dy = 0.0;
        case Looking(delay):
            if (delay > lookingDelay / 2) {
                direction = Right;
            } else {
                direction = Left;
            }
            if (delay < 0) {
                state = Patroling;
            } else {
                state = Looking(delay - dt);
            }
        }

        var actualDx = 0.0;
        var actualDy = 0.0;
        if (dx != 0 || dy != 0) {
            var l = speed * dt;
            var d = Math.sqrt(dx*dx + dy*dy);
            if (!game.level.checkCollision(this.x + l*dx/d, this.y + l*dy/d)) {
                actualDx = l*dx/d;
                actualDy = l*dy/d;
            } else if (dx != 0 && !game.level.checkCollision(this.x + l*dx/Math.abs(dx), this.y)) {
                actualDx = l*dx/Math.abs(dx);
            } else if (dy != 0 && !game.level.checkCollision(this.x, this.y + l*dy/Math.abs(dy))) {
                actualDy = l*dy/Math.abs(dy);
            }
        }

        this.x += actualDx;
        this.y += actualDy;

        if (actualDx > 0) {
            animState = Walking;
            direction = Right;
        } else if (actualDx < 0) {
            animState = Walking;
            direction = Left;
        } else if (actualDy > 0) {
            animState = Walking;
            direction = Down;
        } else if (actualDy < 0) {
            animState = Walking;
            direction = Up;
        } else {
            animState = Standing;
        }

        if (animState != previousAnimState || direction != previousDirection) {
            setAnim();
        }
    }

    private function setAnim() {
        switch [animState, direction] {
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