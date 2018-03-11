#ifndef UI_PROCEDURAL_INCLUDED
#define UI_PROCEDURAL_INCLUDED

/* library to generate procedrual UI elements*/


/*
 Usage: draw radial Gradient
*/
#define UP_PI 3.1415926

void RadialGradient(in float2 uv, in float2 center, float init, out float intensity) {
	uv = (uv - float2(0.5, 0.5)) * float2(1, iResolution.y / iResolution.x) + float2(0.5, 0.5);
	float2 dir = uv - center;
	float angle = acos(dir.x / length(dir)) * dir.y / abs(dir.y) + 2.0 * PI * float(dir.y < 0.0) + mod(init, 2.0 * PI);
	intensity = angle / (2.0 * PI);
}



#endif