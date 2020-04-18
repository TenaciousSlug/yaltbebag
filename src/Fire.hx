enum FireState {
    Strong;
    Medium;
    Weak;
    Dead;
}

class Fire extends h2d.Object {
    static var speed = 10.0;
    static var animationSpeed = 10;

    var anim: h2d.Anim;
    var strong: Array<h2d.Tile>;
    var medium: Array<h2d.Tile>;
    var weak: Array<h2d.Tile>;

    var strength: Float;
    var state: FireState;

    public function new() {
        super();

        var tiles = hxd.Res.character.toTile();

        strong = [
            tiles.sub(0, 256, 32, 32, -16, -27),
        ];
        medium = [
            tiles.sub(0, 288, 32, 32, -16, -27),
        ];
        weak = [
            tiles.sub(0, 320, 32, 32, -16, -27),
        ];

        anim = new h2d.Anim(animationSpeed);

        this.x = 160;
        this.y = 90;

        strength = 100;
        state = Strong;
        setAnim();
    }

    public function update(dt: Float) {
        var previousState = state;

        strength -= speed * dt;

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

    private function setAnim() {
        if (state != Dead && anim.parent == null) {
            this.addChild(anim);
        }

        switch state {
            case Strong: anim.play(strong, 0);
            case Medium: anim.play(medium, 0);
            case Weak: anim.play(weak, 0);
            case Dead: anim.remove();
        }
    }
}
