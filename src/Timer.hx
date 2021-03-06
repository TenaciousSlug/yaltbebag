class Timer extends h2d.Text {
    var time: Float;

    public function new() {
        var font : h2d.Font = hxd.res.DefaultFont.get();
        super(font);
        this.textAlign = Right;
        this.x = 316;
        time = 0;

        this.text = "0:00";
    }

    public function getText(): String {
        var seconds = Std.int(time) % 60;
        var minutes = Std.int(time / 60);

        if (seconds < 10) {
            return '$minutes:0$seconds';
        } else {
            return '$minutes:$seconds';
        }
    }

    public function update(dt: Float) {
        time += dt;

        this.text = this.getText();
    }
}
