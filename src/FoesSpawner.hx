class FoesSpawner extends h2d.Object {
    static var delay = 0.05;
    static var maxFoes = 30;

    var game: Game;

    var remainingWait: Float;
    var foes: Int;
    var rightTile: h2d.Tile;
    var leftTile: h2d.Tile;
    var downTile: h2d.Tile;

    public function new(game: Game) {
        super();

        this.game = game;
        this.remainingWait = 0.0;
        this.foes = 0;

        var tiles = hxd.Res.atlas.toTile();
        rightTile = tiles.sub(0, 128, 32, 32, -16, -27);
        leftTile = tiles.sub(0, 160, 32, 32, -16, -27);
        downTile = tiles.sub(0, 192, 32, 32, -16, -27);
    }

    public function spawn() {
        var x = Std.random(320);
        var y = Std.random(180);

        if (foes > maxFoes || game.level.checkCollision(x, y, true)) {
            return;
        }

        var downLeft = y - x < game.hero.y - game.hero.x;
        var downRight = y + x <= game.hero.y + game.hero.x;
        var tile = downTile;
        if (downLeft && !downRight) {
            tile = leftTile;
        } else if (!downLeft && downRight) {
            tile = rightTile;
        }

        var foe = new h2d.Bitmap(tile, this);
        foe.x = x;
        foe.y = y;
        foes++;

        remainingWait = delay;
    }

    public function isDone() {
        return foes >= maxFoes;
    }

    public function update(dt: Float) {
        remainingWait -= dt;
        if (remainingWait <= 0) {
            this.spawn();
        }
    }
}
