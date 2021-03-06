enum FireState {
    Strong;
    Medium;
    Weak;
    Dead;
}

class Fire {
    static var speed = 100.0 / 20.0;
    static var blowStrength = 3.0;
    static var animationSpeed = 6;
    static var blowAnimationSpeed = 20;

    var game: Game;

    public var anim: h2d.Anim;
    var strong: Array<h2d.Tile>;
    var medium: Array<h2d.Tile>;
    var weak: Array<h2d.Tile>;
    var dead: Array<h2d.Tile>;

    public var wood: h2d.Bitmap;

    public var strength: Float;
    var state: FireState;

    public function new(game: Game) {
        this.game = game;

        var tiles = hxd.Res.atlas.toTile();

        strong = [
            for (i in 0...4) {
                tiles.sub(i * 32, 192, 32, 32, -16, -27);
            }
        ];
        medium = [
            for (i in 0...4) {
                tiles.sub(i * 32, 224, 32, 32, -16, -27);
            }
        ];
        weak = [
            for (i in 0...4) {
                tiles.sub(128 + i * 32, 192, 32, 32, -16, -27);
            }
        ];
        dead = [
            tiles.sub(160, 224, 32, 32, -16, -27)
        ];

        anim = new h2d.Anim(animationSpeed);
        anim.x = game.level.nearFire.x;
        anim.y = game.level.nearFire.y;
        anim.onAnimEnd = function() {
            anim.speed = Math.ffloor(animationSpeed + (anim.speed - animationSpeed) / 2);
        }

        wood = new h2d.Bitmap(tiles.sub(128, 224, 32, 32, -16, -27));
        wood.x = game.level.nearFire.x;
        wood.y = game.level.nearFire.y;

        strength = 100;
        state = Strong;
        setAnim();
    }

    public function update(dt: Float, blow: Bool) {
        var previousState = state;

        if (state != Dead) {
            if (blow) {
                strength += blowStrength;
                anim.speed = blowAnimationSpeed;
                game.playBlowSound();
            } else {
                strength -= speed * dt;
            }
        }

        if (strength <= 0) {
            strength = 0;
            state = Dead;
        } else if (strength < 30) {
            state = Weak;
        } else if (strength < 60) {
            state = Medium;
        } else {
            state = Strong;
            if (strength > 100) {
                strength = 100;
            }
        }

        if (state != previousState) {
            setAnim();
        }
    }

    public function magicBlow() {
        strength = 100;
        anim.speed = blowAnimationSpeed;
        state = Strong;
        setAnim();

        game.playBlowSound();
    }

    private function setAnim() {
        switch state {
            case Strong: anim.play(strong);
            case Medium: anim.play(medium);
            case Weak: anim.play(weak);
            case Dead: anim.play(dead);
        }
    }

    public function isDead() {
        return (state == Dead);
    }
}
