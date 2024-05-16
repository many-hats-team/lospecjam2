shader_type spatial;
render_mode unshaded;

const float total_width_m = 200.0;
const float center_m = 0.5 * total_width_m;
const float road_width_m = 4.0;
const float road_section_length_m = 4.0;
const float centerline_width_m = 0.1;
const float centerline_length_m = 3.0;
const float centerline_gap_length_m = 7.0;
const float road_falloff_threshold_m = 5.0;
const float road_falloff_rate = 0.001;

const float speed_mps = 30.0;

uniform vec3 color_offroad : source_color;
uniform vec3 color_road : source_color;
uniform vec3 color_road2 : source_color;
uniform vec3 color_centerline : source_color;

float half_unit(float x) {
	return 0.5 * road_width_m / total_width_m;
}

float to_unit(float m) {
	return m / total_width_m;
}

bool is_unit_within(float x, float lo, float hi) {
	return x >= lo / total_width_m && x < hi / total_width_m;
}

bool is_unit_within_centered(float x, float center, float width) {
	float center_unit = center / total_width_m;
	float half_w_unit = 0.5 * width / total_width_m;
	return x >= center_unit - half_w_unit && x < center_unit + half_w_unit;
}

float road_offset() {
	return - TIME * (speed_mps / total_width_m);
}

void vertex() {
	if (VERTEX.z < -road_falloff_threshold_m) {
		float x = -road_falloff_threshold_m - VERTEX.z;
		VERTEX.y -= road_falloff_rate*x*x;
	}
}

vec3 dither(vec4 fragcoord, vec3 a, vec3 b, int weight) {
	//switch (int(weight * 5.0)) {
	switch (weight) {
		case 0:
			return a;
		case 1:
			return mod(fragcoord.x, 2.0) + mod(fragcoord.y, 2.0) < 3.0 ? a : b;
		case 2:
			return mod(fragcoord.x + fragcoord.y, 2.0) < 1.0 ? a : b;
		case 3:
			return mod(fragcoord.x, 2.0) + mod(fragcoord.y, 2.0) >= 3.0 ? a : b;
		default:
			return b;
	}
}

void fragment() {
	if (is_unit_within_centered(UV.x, center_m, road_width_m)) {
		if (
			is_unit_within_centered(UV.x, center_m, centerline_width_m)
			&& is_unit_within(
				mod(UV.y + road_offset(), to_unit(centerline_length_m + centerline_gap_length_m)),
				0.0,
				centerline_length_m
			)
		) {
			ALBEDO = color_centerline;
		} else if (
			is_unit_within(
				mod(UV.y + road_offset(), to_unit(road_section_length_m * 2.0)),
				0.0,
				road_section_length_m
			)
		) {
			ALBEDO = dither(FRAGCOORD, color_road, color_road2, 3);
		} else {
			//ALBEDO = dither(FRAGCOORD, color_road, color_road2, 3);
			ALBEDO = color_road2;
		}
	} else {
		ALBEDO = color_offroad;
	}

}
