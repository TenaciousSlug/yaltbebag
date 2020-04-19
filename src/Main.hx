class Main extends hxd.App {
    var game: Game;

    var fireChannel: hxd.snd.Channel;

    override function init() {
        s2d.scaleMode = h2d.ScaleMode.Fixed(320, 180, 2);
        hxd.Res.initEmbed();

        if(hxd.res.Sound.supportedFormat(Wav)){
            var backgroundSound = hxd.Res.sounds.background;
            backgroundSound.play(true, 0.3);

            var fireSound = hxd.Res.sounds.fire;
            fireChannel = fireSound.play(true);
        }

        newGame("");
    }

    private function newGame(previousScore: String) {
        if (game != null) {
            s2d.removeChild(game);
        }

        game = new Game(fireChannel, previousScore);
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
