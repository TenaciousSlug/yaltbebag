class TitleScreen extends h2d.Object {
    public function new() {
        super();

        var title = new h2d.Bitmap(hxd.Res.title_screen.background.toTile(), this);

        var startButtonTile = hxd.Res.title_screen.start_button.toTile();
        var startButtonOverTile = hxd.Res.title_screen.start_button_over.toTile();
        var startButton = new h2d.Bitmap(startButtonTile, this);
        startButton.x = (320 - startButton.tile.width) / 2;
        startButton.y = 120;

        var startButtonInteractive = new h2d.Interactive(
            startButtonTile.width,
            startButtonTile.height,
            startButton);
        startButtonInteractive.onOver = function (event: hxd.Event) {
            startButton.tile = startButtonOverTile;
        }
        startButtonInteractive.onOut = function (event: hxd.Event) {
            startButton.tile = startButtonTile;
        }
        startButtonInteractive.onClick = function (event: hxd.Event) {
            this.start();
        }
    }

    public dynamic function start() {}
}
