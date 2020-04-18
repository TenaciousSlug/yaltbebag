class Game extends h2d.Layers {
    public var paused: Bool;

    public var level: Level;
    public var fire: Fire;
    public var hero: Hero;
    public var foe: Foe;

    public function new() {
        super();

        paused = true;
        level = new Level();

        fire = new Fire(this);
        hero = new Hero(this);
        foe = new Foe(this);

        this.add(level.background, 0);
        this.add(fire, 1);
        this.add(hero, 1);
        this.add(foe, 1);
        this.add(level.foreground, 2);
    }

    public function update(dt: Float) {
        if (paused) {
            return;
        }

        hero.update(dt);
        fire.update(dt);
        foe.update(dt);

        this.ysort(1);
    }
}