class Game extends h2d.Object {
    public var paused: Bool;

    public var layers: h2d.Layers;
    public var level: Level;
    public var fire: Fire;
    public var hero: Hero;
    public var foe: Foe;
    public var timer: Timer;
    public var lightShader: LightShader;

    public function new() {
        super();

        paused = false;
        level = new Level();

        fire = new Fire(this);
        hero = new Hero(this);
        foe = new Foe(this);
        timer = new Timer();

        layers = new h2d.Layers(this);

        layers.add(level.background, 0);
        layers.add(fire, 1);
        layers.add(hero, 1);
        layers.add(foe, 1);
        layers.add(level.foreground, 2);

        lightShader = new LightShader();
        lightShader.strength = 1.0;
        layers.filter = new h2d.filter.Shader(lightShader);

        this.addChild(timer);
    }

    public function update(dt: Float) {
        if (paused) {
            return;
        }

        hero.update(dt);
        fire.update(dt);
        foe.update(dt);
        timer.update(dt);

        if (foe.isNearHero() || fire.isDead()) {
            this.end();
        }

        layers.ysort(1);
        lightShader.strength = fire.strength / 100;
    }

    public dynamic function end() {}
}
