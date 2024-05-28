shader_type canvas_item;

void fragment() {
	if (UV.x < 0.5 && UV.y < 0.5) COLOR.rg = UV * 2.0;
	if (UV.x >= 0.5 && UV.y < 0.5) COLOR.gb = UV * 2.0 - vec2(1.0, 0.0);
	if (UV.x < 0.5 && UV.y >= 0.5) COLOR.rb = UV * 2.0 - vec2(0.0, 1.0);
	if (UV.x >= 0.5 && UV.y >= 0.5) COLOR.rgb = vec3(UV.x * 2.0 - 1.0);
}