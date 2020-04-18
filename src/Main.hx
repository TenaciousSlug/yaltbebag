class Main extends hxd.App {
    var titleScreen: TitleScreen;
    var game: Game;

    override function init() {
        s2d.scaleMode = h2d.ScaleMode.Fixed(320, 180, 2);
        hxd.Res.initEmbed();

        titleScreen = new TitleScreen(this.startGame);
        game = new Game();

        //s2d.addChild(titleScreen);
        startGame();
    }

    private function startGame() {
        game.paused = false;

        s2d.removeChild(titleScreen);
        s2d.addChild(game);
    }

    private function endGame() {
        game.paused = true;

        s2d.removeChild(game);
        s2d.addChild(titleScreen);
    }

    override function update(dt: Float) {
        game.update(dt);
    }

    static function main() {
        new Main();
    }
}
