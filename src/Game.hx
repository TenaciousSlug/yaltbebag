class Game extends h2d.Object {
    public var paused: Bool;

    public var level: Level;
    public var fire: Fire;
    public var hero: Hero;

    public function new() {
        super();

        paused = true;
        level = new Level(this);
        fire = new Fire(this);
        hero = new Hero(this);
        this.addChild(level.foreground);
    }

    public function update(dt: Float) {
        if (paused) {
            return;
        }

        hero.update(dt);
        fire.update(dt);
    }
}
