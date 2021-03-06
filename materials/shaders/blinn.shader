shader_type spatial;
render_mode blend_mix, depth_draw_opaque;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform float specular_power = 200.0;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;


void vertex() {
	UV = UV * uv1_scale.xy + uv1_offset.xy;
}

void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
}

void light() {
	vec3 color = mix(ALBEDO, LIGHT_COLOR, 0.2);
	
	DIFFUSE_LIGHT = max(dot(NORMAL, LIGHT), 0.0) * ATTENUATION * color;
	
	lowp vec3 h = normalize(LIGHT + VIEW);
	lowp float specular = pow(max(0.0, dot(NORMAL, h)), specular_power);
	
	SPECULAR_LIGHT += min(LIGHT_COLOR * specular, 1.0) * ATTENUATION;
}