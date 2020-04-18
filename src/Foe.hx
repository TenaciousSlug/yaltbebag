import hxd.Key;

enum FoeState {
    Standing;
    Walking;
}

class Foe extends h2d.Object {
    static var speed = 30.0;
    static var animationSpeed = 5;
    static var runningSpeed = 70.0;
    static var runningAnimationSpeed = 12;

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

        anim = new h2d.Anim(animationSpeed, this);

        this.x = 30;
        this.y = 40;

        state = Standing;
        direction = Right;
        setAnim();
    }

    public function update(dt: Float) {
        var previousState = state;
        var previousDirection = direction;

        // TODO: determine these, add running state
        var dx = 1;
        var dy = 0;

        var actualDx = 0.0;
        var actualDy = 0.0;
        if (dx != 0 || dy != 0) {
            var l = speed * dt;
            var n = 1.0 / Math.sqrt(dx*dx + dy*dy);
            if (!game.level.checkCollision(this.x + l*n*dx, this.y + l*n*dy)) {
                actualDx = l*n*dx;
                actualDy = l*n*dy;
            } else if (!game.level.checkCollision(this.x + l*dx, this.y)) {
                actualDx = l*dx;
            } else if (!game.level.checkCollision(this.x, this.y + l*dy)) {
                actualDy = l*dy;
            }
        }

        this.x += actualDx;
        this.y += actualDy;

        if (actualDx > 0) {
            state = Walking;
            direction = Right;
        } else if (actualDx < 0) {
            state = Walking;
            direction = Left;
        } else if (actualDy > 0) {
            state = Walking;
            direction = Down;
        } else if (actualDy < 0) {
            state = Walking;
            direction = Up;
        } else {
            state = Standing;
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
