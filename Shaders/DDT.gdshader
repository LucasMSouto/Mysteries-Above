shader_type spatial;
render_mode cull_front, unshaded;

uniform sampler2D demTexture;
uniform vec4 outline_color : source_color;
uniform float outline_width = 1.3;

void vertex() {
	//Outlines
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

	clip_position.xy += offset;

	POSITION = clip_position;
}

void fragment() {
	//Dematrialization Effect
	float DematrializationMovement = TIME * 0.2;
	vec2 rectsPositions = vec2(0.0,DematrializationMovement);
	vec2 scrolling_uv = SCREEN_UV + rectsPositions;
	vec4 texture_color = texture(demTexture, scrolling_uv);

	ALBEDO = texture_color.rgb;
    ALPHA = texture_color.a;
}