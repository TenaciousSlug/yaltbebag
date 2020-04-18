class Level {
    var walls: h2d.col.Polygons;
    public var fire: h2d.col.Circle;

    public var background: h2d.Bitmap;
    public var foreground: h2d.Bitmap;

    public function new() {
        background = new h2d.Bitmap(hxd.Res.level.background.toTile());
        foreground = new h2d.Bitmap(hxd.Res.level.foreground.toTile());

        fire = new h2d.col.Circle(160, 90, 12);

        walls = new h2d.col.Polygons([
            new h2d.col.Polygon([
                new h2d.col.Point(0, 0),
                new h2d.col.Point(0, 24 + 2),
                new h2d.col.Point(320, 24 + 2),
                new h2d.col.Point(320, 0),
            ]),
            new h2d.col.Polygon([
                new h2d.col.Point(40 - 5, 56),
                new h2d.col.Point(40 - 5, 152 + 2),
                new h2d.col.Point(48 + 5, 152 + 2),
                new h2d.col.Point(48 + 5, 80 + 2),
                new h2d.col.Point(120 + 5, 80 + 2),
                new h2d.col.Point(120 + 5, 56),
            ]),
            new h2d.col.Polygon([
                new h2d.col.Point(112 - 5, 96),
                new h2d.col.Point(112 - 5, 152 + 2),
                new h2d.col.Point(120 + 5, 152 + 2),
                new h2d.col.Point(120 + 5, 96),
            ]),
            new h2d.col.Polygon([
                new h2d.col.Point(224 - 5, 56),
                new h2d.col.Point(224 - 5, 152 + 2),
                new h2d.col.Point(280 + 5, 152 + 2),
                new h2d.col.Point(280 + 5, 128),
                new h2d.col.Point(232 + 5, 128),
                new h2d.col.Point(232 + 5, 56),
            ]),
            new h2d.col.Polygon([
                new h2d.col.Point(156 - 5, 84),
                new h2d.col.Point(156 - 5, 93 + 2),
                new h2d.col.Point(162 + 5, 93 + 2),
                new h2d.col.Point(162 + 5, 84),
            ]),
        ]);
    }

    public function checkCollision(x: Float, y: Float): Bool {
        if (x <= 5 || x >= 320 - 5 || y <= 0 || y >= 180) {
            return true;
        }

        return walls.contains(new h2d.col.Point(x, y));
    }

    public function isNearFire(x: Float, y: Float): Bool {
        return fire.contains(new h2d.col.Point(x, y));
    }

    public function obstructed(ray: h2d.col.Ray): Bool {
        for (wall in walls.polygons) {
            var intersection = wall.rayIntersection(ray);
            if (intersection != null) {
                var d = ray.getDir().dot(intersection.sub(ray.getPos()));
                if (d >= 0 && d <= ray.getDir().lengthSq()) {
                    return true;
                }
            }
        }

        return false;
    }
}