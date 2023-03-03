shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform vec2 scroll = vec2(0.05f, 0.05f);
uniform float distortion_strength : hint_range(-1.0, 1) = 0.15;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform vec4 tone_color : source_color;
uniform float light_start : hint_range(0.0, 1.0, 0.1) = 0.3f;
uniform float light_end : hint_range(0.0, 1.0, 0.1) = 0.4f;
uniform vec4 top_color : source_color;


void fragment() {
	vec4 bg_col = texture(TEXTURE, UV + scroll *  -2.0 * TIME);
	vec4 noise_col = texture(noise, UV + scroll * TIME) * bg_col;
	vec4 screen_col = texture(screen_texture, SCREEN_UV + distortion_strength * noise_col.rr);
	vec4 top_light = smoothstep(light_start, light_end, noise_col.r) * top_color;
	COLOR = screen_col * tone_color + top_light;
}
