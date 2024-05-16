
const float road_falloff_threshold_m = 5.0;
const float road_falloff_rate = 0.008;

vec3 falloff(vec3 vertex, mat4 model_matrix) {
	vec4 v = model_matrix * vec4(vertex, 1.0);
	if (v.z < -road_falloff_threshold_m) {
		float x = -road_falloff_threshold_m - v.z;
		vertex.y -= road_falloff_rate * x * x;
	}
	return vertex;
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
