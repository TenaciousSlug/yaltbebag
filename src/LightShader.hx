class LightShader extends h3d.shader.ScreenShader {
    static var SRC = {
        @param var texture : Sampler2D;
        @param var strength : Float;

        function fragment() {
            pixelColor = texture.get(input.uv);

            // Dim everything, except the eyes' colors
            if (pixelColor.r < 0.9 || (pixelColor.b > 0.5 && pixelColor.b < 0.95)) {
                pixelColor *= max(0, min(strength, 1));
            }
        }
    }
}
