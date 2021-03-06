import hxd.Key;

enum GameState {
    WaitingToStart;
    WaitingToStartTutorial;
    TutorialFire;
    Playing;
}

class Game extends h2d.Layers {
    static var fadeInDuration = 1.0;

    public var level: Level;
    public var fire: Fire;
    public var hero: Hero;
    public var foesSpawner: FoesSpawner;
    public var timer: Timer;
    public var lightShader: LightShader;
    public var title: h2d.Bitmap;
    public var message: h2d.Text;
    public var helpMessage: h2d.Text;
    public var spaceToStart: h2d.Text;
    public var fader: h2d.Graphics;
    public var state: GameState;

    public var blowSound: hxd.res.Sound;
    public var fireChannel: hxd.snd.Channel;

    public function new(fireChannel: hxd.snd.Channel, previousScore: String) {
        super();

        this.fireChannel = fireChannel;

        state = WaitingToStart;
        if (previousScore == "") {
            state = WaitingToStartTutorial;
        }

        level = new Level();

        fire = new Fire(this);
        hero = new Hero(this);
        foesSpawner = new FoesSpawner(this);
        timer = new Timer();

        title = new h2d.Bitmap(hxd.Res.title.toTile());

        var font : h2d.Font = hxd.res.DefaultFont.get();

        message = new h2d.Text(font);
        message.text = previousScore;
        message.textAlign = Center;
        message.textColor = 0x000000;
        message.x = 160;
        message.y = 108;

        helpMessage = new h2d.Text(font);
        helpMessage.text = "";
        helpMessage.textAlign = Center;
        helpMessage.textColor = 0x000000;
        helpMessage.x = 160;
        helpMessage.y = 26;

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
        this.add(foesSpawner, 1);
        this.add(level.foreground, 2);
        this.add(title, 3);
        this.add(spaceToStart, 3);
        this.add(message, 3);
        this.add(helpMessage, 3);
        this.add(fader, 4);

        lightShader = new LightShader();
        lightShader.strength = 1.0;
        var filter = new h2d.filter.Shader(lightShader);

        level.background.filter = filter;
        fire.wood.filter = filter;
        hero.filter = filter;
        foesSpawner.filter = filter;
        level.foreground.filter = filter;

        if(hxd.res.Sound.supportedFormat(Wav)){
            blowSound = hxd.Res.sounds.blow;
        }
    }

    public function hideTitle() {
        this.removeChild(title);
        this.removeChild(spaceToStart);
        this.removeChild(message);
        this.removeChild(fader);
    }

    public function startGame() {
        foesSpawner.spawnAt(30, 40);
        this.add(timer, 3);
        state = Playing;
    }

    public function update(dt: Float) {
        switch state {
            case WaitingToStart: updateBeforeStart(dt);
            case WaitingToStartTutorial: updateBeforeTutorialStart(dt);
            case TutorialFire: updateTutorialFire(dt);
            case Playing: updatePlaying(dt);
        }

        this.ysort(1);
        lightShader.strength = fire.strength / 100;
        if (fireChannel != null) {
            fireChannel.volume = fire.strength / 150;
        }
    }

    public function updatePlaying(dt: Float) {
        if (foesSpawner.anyNearHero()) {
            var time = timer.getText();
            end('You survived\nfor $time');
        }

        var blow = Key.isPressed(Key.SPACE) && level.isNearFire(hero.x, hero.y);

        hero.update(dt);
        foesSpawner.update(dt);
        fire.update(dt, blow);
        timer.update(dt);
    }

    public function updateBeforeStart(dt: Float) {
        fader.alpha = Math.max(0, fader.alpha - dt / fadeInDuration);

        if (Key.isPressed(Key.SPACE)) {
            hideTitle();
            startGame();
        }
    }

    public function updateBeforeTutorialStart(dt: Float) {
        fader.alpha = Math.max(0, fader.alpha - dt / fadeInDuration);

        if (Key.isPressed(Key.SPACE)) {
            hideTitle();
            state = TutorialFire;
        }
    }

    public function updateTutorialFire(dt: Float) {
        hero.update(dt);

        if (fire.strength > 60) {
            // Make the beginning of the tutorial faster, since nothing really
            // happens
            fire.update(dt * 2, false);
            return;
        }

        fire.update(0, false);

        var blow = Key.isPressed(Key.SPACE) && level.isNearFire(hero.x, hero.y);
        if (blow) {
            fire.magicBlow();
            helpMessage.text = "";

            startGame();
            return;
        }

        if (level.isNearFire(hero.x, hero.y)) {
            helpMessage.text = "Press SPACE to blow on the fire";

            if (Key.isPressed(Key.SPACE)) {
                trace("space");
            }
        } else {
            helpMessage.text = "The light is getting dimmer, I should revive the fire.";
        }
    }

    public function playBlowSound() {
        if (blowSound != null) {
            blowSound.play(0.3);
        }
    }

    public dynamic function end(message: String) {}
}
