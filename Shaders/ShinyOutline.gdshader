shader_type spatial;
render_mode cull_front, unshaded, blend_add;

uniform vec4 ShineColor: source_color;
uniform float outline_width : hint_range(0.0,3) = 1.3;
uniform float Emission_Energy : hint_range(0.0, 16.0) = 6;
uniform bool showOutline;

void vertex() {
	//Outlines
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL) ;

	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

	clip_position.xy += offset;

	POSITION = clip_position;
}

void fragment() {
	//Shiny Outline Effect
	ALBEDO = ShineColor.rgb * Emission_Energy;
	EMISSION = ShineColor.rgb * Emission_Energy;
	if(showOutline){
		ALPHA = ShineColor.a;
	}else{
		ALPHA = 0.0;
	}
	
}