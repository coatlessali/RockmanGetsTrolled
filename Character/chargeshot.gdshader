shader_type canvas_item;

render_mode unshaded;

uniform vec4 target_colors[3] : source_color;
uniform vec4 replace_colors[3] : source_color;
uniform int color_count : hint_range(0, 3); // number of active color swaps
uniform float tolerance : hint_range(0, 1);
uniform bool shader_active = true; // you’ll change this from your script
uniform float speed = 1.0;
uniform float intensity : hint_range(0.0, 1.0) = 1.0;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment()
{
	// palette swap
	vec4 tex_color = texture(TEXTURE, UV);

	if (shader_active) {
		for (int i = 0; i < color_count; i++) {
			if (distance(tex_color.rgb, target_colors[i].rgb) < tolerance) {
				tex_color.rgb = replace_colors[i].rgb;
				break;
			}
		}
	}
	COLOR = tex_color;
	// charge shot
    //COLOR = texture(TEXTURE, UV);

    float hue = UV.y * 0.25 + mod(TIME * speed, 1.0);
    vec3 rainbow = hsv2rgb(vec3(hue, 0.6, 1.0));

    COLOR.rgb = mix(COLOR.rgb, COLOR.rgb * rainbow, intensity);
	COLOR.a *= alpha;
}