shader_type canvas_item;

uniform float red_amount : hint_range(0.0, 1.0) = 0.0;
uniform float green_amount : hint_range(0.0, 1.0) = 0.0;
uniform float blue_amount : hint_range(0.0, 1.0) = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
	vec4 color = texture(screen_texture, SCREEN_UV);
	float lum = dot(color.rgb, vec3(0.299, 0.587, 0.114));
	float any_unlocked = clamp(red_amount + green_amount + blue_amount, 0.0, 1.0);

	float r = mix(lum, color.r * red_amount, any_unlocked);
	float g = mix(lum, color.g * green_amount, any_unlocked);
	float b = mix(lum, color.b * blue_amount, any_unlocked);

	COLOR = vec4(r, g, b, color.a);
}
