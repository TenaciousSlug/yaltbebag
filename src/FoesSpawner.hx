class FoesSpawner extends h2d.Object {
    static var delay = 0.5;
    static var maxFoes = 10;

    var game: Game;

    var remainingWait: Float;
    var foes: List<Foe>;

    public function new(game: Game) {
        super();

        this.game = game;
        this.remainingWait = 0.0;
        this.foes = new List();
    }

    public function spawn() {
        spawnAt(Std.random(320), Std.random(180));
    }

    public function spawnAt(x: Float, y: Float) {
        if (foes.length > maxFoes || game.level.checkCollision(x, y, true)) {
            return;
        }

        var foe = new Foe(game);
        foe.x = x;
        foe.y = y;
        foes.add(foe);
        this.addChild(foe);

        remainingWait = delay;
    }

    public function update(dt: Float) {
        if (game.fire.isDead()) {
            remainingWait -= dt;
            if (remainingWait <= 0) {
                this.spawn();
            }
        }

        for (foe in foes) {
            foe.update(dt);
        }
    }

    public function anyNearHero() {
        for (foe in foes) {
            if (foe.isNearHero()) {
                return true;
            }
        }

        return false;
    }
}
