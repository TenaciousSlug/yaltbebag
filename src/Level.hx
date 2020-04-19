class Level {
    var walls: h2d.col.Polygons;
    var fire: h2d.col.Polygon;
    public var nearFire: h2d.col.Circle;

    public var background: h2d.Bitmap;
    public var foreground: h2d.Bitmap;

    public var patrolPoints: Array<h2d.col.Point>;
    public var patrolNeighbours: Array<Array<Int>>;

    public function new() {
        background = new h2d.Bitmap(hxd.Res.level.background.toTile());
        foreground = new h2d.Bitmap(hxd.Res.level.foreground.toTile());

        nearFire = new h2d.col.Circle(160, 90, 12);

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
        ]);

        fire = new h2d.col.Polygon([
            new h2d.col.Point(156 - 5, 84),
            new h2d.col.Point(156 - 5, 93 + 2),
            new h2d.col.Point(162 + 5, 93 + 2),
            new h2d.col.Point(162 + 5, 84),
        ]);

        patrolPoints = [
            new h2d.col.Point(20, 40),
            new h2d.col.Point(136, 40),
            new h2d.col.Point(208, 40),
            new h2d.col.Point(300, 40),

            new h2d.col.Point(80, 88),
            new h2d.col.Point(136, 88),
            new h2d.col.Point(208, 88),

            new h2d.col.Point(20, 168),
            new h2d.col.Point(80, 168),
            new h2d.col.Point(136, 168),
            new h2d.col.Point(208, 168),
            new h2d.col.Point(300, 168),
        ];
        patrolNeighbours = [
            [1, 7],
            [0, 2, 5],
            [1, 3, 6],
            [2, 11],

            [5, 8],
            [1, 4, 9],
            [2, 10],

            [0, 8],
            [4, 7, 9],
            [5, 8, 10],
            [6, 9, 11],
            [3, 10],
        ];
    }

    public function checkCollision(x: Float, y: Float, canWalkThroughFire: Bool): Bool {
        if (x <= 5 || x >= 320 - 5 || y <= 0 || y >= 180) {
            return true;
        }

        var p = new h2d.col.Point(x, y);
        return (!canWalkThroughFire && fire.contains(p)) || walls.contains(p);
    }

    public function isNearFire(x: Float, y: Float): Bool {
        return nearFire.contains(new h2d.col.Point(x, y));
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

    public function closestPatrolPoint(x: Float, y: Float): Int {
        var point = new h2d.col.Point(x, y);

        var closestIndex = 0;
        var closestDistance = patrolPoints[0].distanceSq(point);
        for (i in 1...patrolPoints.length) {
            var distance = patrolPoints[i].distanceSq(point);
            if (distance < closestDistance) {
                closestDistance = distance;
                closestIndex = i;
            }
        }

        return closestIndex;
    }

    public function neighbourPatrolPoint(patrolPoint: Int): Int {
        var index = Std.random(patrolNeighbours[patrolPoint].length);
        return patrolNeighbours[patrolPoint][index];
    }
}
