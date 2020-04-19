class Main extends hxd.App {
    var titleScreen: TitleScreen;
    var game: Game;

    override function init() {
        s2d.scaleMode = h2d.ScaleMode.Fixed(320, 180, 2);
        hxd.Res.initEmbed();

        titleScreen = new TitleScreen();
        titleScreen.start = this.startGame;

        //s2d.addChild(titleScreen);
        startGame();
    }

    private function startGame() {
        game = new Game();
        game.end = this.endGame;

        s2d.removeChild(titleScreen);
        s2d.addChild(game);
    }

    private function endGame() {
        s2d.removeChild(game);
        s2d.addChild(titleScreen);

        game = null;
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
