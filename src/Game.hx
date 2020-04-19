import hxd.Key;

class Game extends h2d.Layers {
    static var fadeInDuration = 1.0;

    public var paused: Bool;

    public var level: Level;
    public var fire: Fire;
    public var hero: Hero;
    public var foe: Foe;
    public var timer: Timer;
    public var lightShader: LightShader;
    public var title: h2d.Bitmap;
    public var message: h2d.Text;
    public var spaceToStart: h2d.Text;
    public var fader: h2d.Graphics;

    public function new(previousScore: String) {
        super();

        paused = true;
        level = new Level();

        fire = new Fire(this);
        hero = new Hero(this);
        foe = new Foe(this);
        timer = new Timer();

        title = new h2d.Bitmap(hxd.Res.title.toTile());

        var font : h2d.Font = hxd.res.DefaultFont.get();

        message = new h2d.Text(font);
        message.text = previousScore;
        message.textAlign = Center;
        message.textColor = 0x000000;
        message.x = 160;
        message.y = 96;

        spaceToStart = new h2d.Text(font);
        spaceToStart.text = "Press SPACE to start";
        spaceToStart.textAlign = Center;
        spaceToStart.textColor = 0x000000;
        spaceToStart.x = 160;
        spaceToStart.y = 156;

        fader = new h2d.Graphics();
        fader.beginFill(0x000000);
        fader.drawRect(0, 0, 320, 180);
        fader.endFill();

        this.add(level.background, 0);
        this.add(fire.wood, 0);
        this.add(fire.anim, 1);
        this.add(hero, 1);
        this.add(level.foreground, 2);
        this.add(title, 3);
        this.add(spaceToStart, 3);
        this.add(message, 3);
        this.add(fader, 4);

        lightShader = new LightShader();
        lightShader.strength = 1.0;
        var filter = new h2d.filter.Shader(lightShader);

        level.background.filter = filter;
        fire.wood.filter = filter;
        hero.filter = filter;
        foe.filter = filter;
        level.foreground.filter = filter;
    }

    public function start() {
        this.add(foe, 1);
        this.add(timer, 3);
        this.removeChild(title);
        this.removeChild(spaceToStart);
        this.removeChild(message);
        this.removeChild(fader);
        paused = false;
    }

    public function update(dt: Float) {
        if (paused) {
            fader.alpha = Math.max(0, fader.alpha - dt / fadeInDuration);
            if (Key.isPressed(Key.SPACE)) {
                this.start();
            }
            return;
        }

        hero.update(dt);
        fire.update(dt);
        foe.update(dt);
        timer.update(dt);

        if (foe.isNearHero() || fire.isDead()) {
            var time = timer.getText();
            this.end('You kept\nthe fire alive\nfor $time');
        }

        this.ysort(1);
        lightShader.strength = fire.strength / 100;
    }

    public dynamic function end(message: String) {}
}
