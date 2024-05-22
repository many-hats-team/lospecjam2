shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

#define DEBUG_SHOW_BAD_COLORS false

const vec3 palette[] = {
        vec3(255.0/255.0, 3.0/255.0, 43.0/255.0),
        vec3(128.0/255.0, 0.0/255.0, 52.0/255.0),
        vec3(255.0/255.0, 255.0/255.0, 13.0/255.0),
        vec3(255.0/255.0, 143.0/255.0, 0.0/255.0),
        vec3(10.0/255.0, 255.0/255.0, 10.0/255.0),
        vec3(0.0/255.0, 112.0/255.0, 98.0/255.0),
        vec3(13.0/255.0, 255.0/255.0, 255.0/255.0),
        vec3(60.0/255.0, 128.0/255.0, 219.0/255.0),
        vec3(41.0/255.0, 41.0/255.0, 255.0/255.0),
        vec3(45.0/255.0, 0.0/255.0, 110.0/255.0),
        vec3(255.0/255.0, 8.0/255.0, 255.0/255.0),
        vec3(110.0/255.0, 0.0/255.0, 133.0/255.0),
        vec3(38.0/255.0, 10.0/255.0, 52.0/255.0),
        vec3(0.0/255.0, 0.0/255.0, 0.0/255.0),
        vec3(255.0/255.0, 255.0/255.0, 255.0/255.0),
        vec3(125.0/255.0, 125.0/255.0, 163.0/255.0)
};
const int palette_size = 16;

vec3 get_closest_palette(vec3 color) {
	vec3 closest_color = color;
	float closest_dist = 9999.0;
	for (int i = 0; i < palette_size; ++i) {
		float d = distance(color, palette[i]);
		if (d < closest_dist) {
			closest_dist = d;
			closest_color = palette[i];
		}
	}
	return closest_color;
}

#if DEBUG_SHOW_BAD_COLORS
int color_vec2int(vec3 color) {
	return (int(round(color.r * 255.0)) << 16)
		| (int(round(color.g * 255.0)) << 8)
		| int(round(color.b * 255.0));
}

bool is_valid_color(vec3 color) {
	int c = color_vec2int(color);
	switch (c) {
		case 0xff032b:
		case 0x800034:
		case 0xffff0d:
		case 0xff8f00:
		case 0x0aff0a:
		case 0x007062:
		case 0x0dffff:
		case 0x3c80db:
		case 0x2929ff:
		case 0x2d006e:
		case 0xff08ff:
		case 0x6e0085:
		case 0x260a34:
		case 0x000000:
		case 0xffffff:
		case 0x7d7da3:
			return true;
		default:
			return false;
	}
}
#endif

void fragment() {
    COLOR = textureLod(screen_texture, SCREEN_UV, 0.0);

#if DEBUG_SHOW_BAD_COLORS
	if (is_valid_color(COLOR.rgb)) {
		float avg = (COLOR.r + COLOR.g + COLOR.b) / 5.0;
		COLOR.rgb = vec3(avg);
	} else {
		COLOR.rgb = vec3(1.0, 0.0, 1.0);
	}
#else
	COLOR.rgb = get_closest_palette(COLOR.rgb);
#endif

}