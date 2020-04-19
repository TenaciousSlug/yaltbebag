class Main extends hxd.App {
    var game: Game;

    override function init() {
        s2d.scaleMode = h2d.ScaleMode.Fixed(320, 180, 2);
        hxd.Res.initEmbed();

        newGame();
    }

    private function newGame() {
        if (game != null) {
            s2d.removeChild(game);
        }

        game = new Game();
        game.end = this.newGame;

        s2d.addChild(game);
    }

    override function update(dt: Float) {
        if (game != null) {
            game.update(dt);
        }
    }

    static function main() {
        new Main();
    }
}
