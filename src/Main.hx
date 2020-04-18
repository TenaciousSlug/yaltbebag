class Main extends hxd.App {
    var started: Bool;
    var titleScreen: TitleScreen;
    var hero: Hero;
    var fire: Fire;

    override function init() {
        started = false;

        s2d.scaleMode = h2d.ScaleMode.Fixed(320, 180, 2);
        hxd.Res.initEmbed();

        titleScreen = new TitleScreen(this.startGame);
        hero = new Hero();
        fire = new Fire();

        s2d.addChild(titleScreen);
    }

    private function startGame() {
        if (started) {
            return;
        }

        s2d.removeChild(titleScreen);

        s2d.addChild(hero);
        s2d.addChild(fire);

        started = true;
    }

    private function endGame() {
        if (!started) {
            return;
        }

        started = false;

        s2d.removeChild(hero);
        s2d.removeChild(fire);

        s2d.addChild(titleScreen);
    }

    override function update(dt: Float) {
        if (!started) {
            return;
        }

        hero.update(dt);
        fire.update(dt);
    }

    static function main() {
        new Main();
    }
}
