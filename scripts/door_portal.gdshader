shader_type canvas_item;

uniform vec4 cor : source_color = vec4(0.5, 0.0, 1.0, 1.0);
uniform float opacidade : hint_range(0.0, 1.0) = 0.55;

void fragment() {
	vec2 uv = UV;

	// Distorção ondulante em duas frequências
	float d1 = sin(uv.y * 8.0 + TIME * 2.5) * 0.04;
	float d2 = sin(uv.y * 22.0 - TIME * 1.8) * 0.012;
	vec2 uv_d = vec2(uv.x + d1 + d2, uv.y);

	// Padrão de brilho animado
	float b1 = sin(uv_d.x * 5.0 + TIME * 1.2) * 0.5 + 0.5;
	float b2 = sin(uv_d.y * 3.5 - TIME * 0.9) * 0.5 + 0.5;
	float brilho = b1 * b2;

	// Scanlines sutis para feel pixelado
	float scan = step(0.5, fract(UV.y * 28.0));
	brilho *= mix(1.0, 0.82, scan * 0.25);

	// Vinheta nas bordas para fundir com a moldura
	float vx = smoothstep(0.0, 0.12, uv.x) * smoothstep(1.0, 0.88, uv.x);
	float vy = smoothstep(0.0, 0.07, uv.y) * smoothstep(1.0, 0.93, uv.y);
	float vignette = vx * vy;

	// Fundo quase invisível, brilhos mais opacos — igual ao portal do Nether
	vec4 escuro = cor * 0.08;
	vec4 claro  = cor * (0.7 + brilho * 0.5);
	vec4 color  = mix(escuro, claro, pow(brilho, 0.7));

	// Alpha: fundo bem transparente, partes brilhantes mais visíveis
	float alpha_base = mix(0.1, opacidade, pow(brilho, 0.5));
	color.a = alpha_base * vignette;

	COLOR = color;
}
