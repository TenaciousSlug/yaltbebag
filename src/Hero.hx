import hxd.Key;

enum Direction {
    Left;
    Right;
    Up;
    Down;
}

enum HeroState {
    Standing;
    Walking;
}

class Hero extends h2d.Object {
    static var speed = 60.0;
    static var animationSpeed = 10;

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

    public function new() {
        super();

        var characterTiles = hxd.Res.character.toTile();

        standingRight = [
            characterTiles.sub(0, 0, 32, 32, -16, -27)
        ];
        walkingRight = [
            for (i in 1...7) {
                characterTiles.sub(i * 32, 0, 32, 32, -16, -27);
            }
        ];

        standingLeft = [
            characterTiles.sub(0, 32, 32, 32, -16, -27)
        ];
        walkingLeft = [
            for (i in 1...7) {
                characterTiles.sub(i * 32, 32, 32, 32, -16, -27);
            }
        ];

        standingDown = [
            characterTiles.sub(0, 64, 32, 32, -16, -27)
        ];
        walkingDown = [
            for (i in 0...4) {
                characterTiles.sub(i * 32, 64, 32, 32, -16, -27);
            }
        ];

        standingUp = [
            characterTiles.sub(0, 96, 32, 32, -16, -27)
        ];
        walkingUp = [
            for (i in 0...4) {
                characterTiles.sub(i * 32, 96, 32, 32, -16, -27);
            }
        ];

        anim = new h2d.Anim(animationSpeed, this);

        this.x = 160;
        this.y = 180;

        state = Standing;
        direction = Right;
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

        this.x += speed * dx * dt;
        this.y += speed * dy * dt;

        if (this.x < 0) {
            this.x = 0;
        }
        if (this.x > 320) {
            this.x = 320;
        }
        if (this.y < 0) {
            this.y = 0;
        }
        if (this.y > 180) {
            this.y = 180;
        }

        if (dx > 0) {
            state = Walking;
            direction = Right;
        } else if (dx < 0) {
            state = Walking;
            direction = Left;
        } else if (dy > 0) {
            state = Walking;
            direction = Down;
        } else if (dy < 0) {
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


