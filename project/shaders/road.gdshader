shader_type spatial;
render_mode unshaded;

#include "common.gdshaderinc"

const float total_width_m = 200.0;
const float center_m = 0.5 * total_width_m;
const float road_width_m = 4.0;
const float road_section_length_m = 4.0;
const float centerline_width_m = 0.1;
const float centerline_length_m = 3.0;
const float centerline_gap_length_m = 7.0;
const float shoulderline_width_m = 0.1;
const float shoulderline_gap_m = 0.1;
const float speed = 0.15;

uniform bool is_flashing = false;
uniform bool is_paused = false;

uniform vec3 color_offroad : source_color;
uniform vec3 color_road : source_color;
uniform vec3 color_road2 : source_color;
uniform vec3 color_whiteline : source_color;
uniform vec3 color_yellowline : source_color;

float half_unit(float x) {
	return 0.5 * road_width_m / total_width_m;
}

float to_unit(float m) {
	return m / total_width_m;
}

bool is_unit_within(float x, float start, float width) {
	return x >= start / total_width_m && x < (start + width) / total_width_m;
}

bool is_unit_within_centered(float x, float center, float width) {
	float center_unit = center / total_width_m;
	float half_w_unit = 0.5 * width / total_width_m;
	return x >= center_unit - half_w_unit && x < center_unit + half_w_unit;
}

float road_offset() {
	return - TIME * speed;
}

void vertex() {
	VERTEX = falloff(VERTEX, MODEL_MATRIX);
}

void fragment() {
	if (is_flashing) {
		ALBEDO = vec3(0.5);
	} else if (is_unit_within(UV.x, center_m + road_width_m * 0.5 - shoulderline_gap_m - shoulderline_width_m, shoulderline_width_m)) {
		ALBEDO = color_whiteline;
	} else if (is_unit_within(UV.x, center_m - road_width_m * 0.5 + shoulderline_gap_m, shoulderline_width_m)) {
		ALBEDO = color_yellowline;
	} else if (is_unit_within_centered(UV.x, center_m, road_width_m)) {
		if (is_paused) {
			// Don't show any animated sections
			ALBEDO = color_road2;
		} else if (
			is_unit_within_centered(UV.x, center_m, centerline_width_m)
			&& is_unit_within(
				mod(UV.y + road_offset(), to_unit(centerline_length_m + centerline_gap_length_m)),
				0.0,
				centerline_length_m
			)
		) {
			ALBEDO = color_whiteline;
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

  RIM = 0.0;
  METALLIC = 0.0;
  ROUGHNESS = 0.0;
}
