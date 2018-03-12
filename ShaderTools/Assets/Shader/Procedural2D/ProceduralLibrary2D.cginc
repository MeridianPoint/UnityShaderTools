#ifndef PROCEDURALLABRARY2D_INCLUDED
#define PROCEDURALLABRARY2D_INCLUDED

/*
shader library for basic 2D procedural textures
*/

#ifndef AA  
#define AA 8  //anti-aliasing level
#endif

//draw 2D checker board
void CheckerBoard(in float2 uv, in float widthDiv, out float intensity){
    //uv = fmod(uv * float2(widthDiv, widthDiv * iResolution.y /iResolution.x), float2(1.0));
	uv = fmod(uv * float2(widthDiv, widthDiv), float2(1.0, 1.0));
    float2 value = uv - float2(0.5, 0.5);
    intensity = float(value.x * value.y > 0.0);
}


//draw 2D checker board anti-aliasing
void CheckerBoardAA(in float2 uv, float2 ddUVx, float2 ddUVy, in float widthDiv, out float intensity) {
#if AA == 1
	CheckerBoard(uv, widthDiv, intensity);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset = offset.x * ddUVx + offset.y * ddUVy;
		CheckerBoard(uv + offset, widthDiv, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

//draw grid of spheres
void SphereGrid(in float2 uv, in float widthDiv, in float radiusPre, out float intensity){
    uv = fmod(uv * float2(widthDiv, widthDiv * _ScreenParams.y / _ScreenParams.x), float2(1.0, 1.0));
    float2 value = uv - float2(0.5, 0.5);
    intensity = float(length(value) > radiusPre);
}

void SphereGridAA(in float2 uv, float2 ddUVx, float2 ddUVy, in float widthDiv, in float radiusPre, out float intensity) {
#if AA == 1
	SphereGrid(uv, widthDiv, radiusPre, intensity);
#else
#endif
	float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset = offset.x * ddUVx + offset.y * ddUVy;
		SphereGrid(uv + offset, widthDiv, radiusPre, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
}


//-------------------------------------

//draw bricks 
void Bricks(in float2 uv, in float2 div, in float edgeWidth, out float intensity){
    float2 orinal_uv = uv;
    uv = fmod(uv * div, float2(1.0, 1.0));
    float shift = fmod(floor(orinal_uv.y * div.y), 2.0);
    //uv *= shift;
    uv = fmod(uv + float2(0.5 * shift, 0.0), float2(1.0, 1.0)) + float2(0.5, 0.5);
    float2 value = abs(uv - float2(0.5, 0.5)) - float2(edgeWidth * 0.5, edgeWidth * 0.5);
    intensity = float(min(value.x, value.y) > 0.0);
}

void BricksAA(in float2 uv, float2 ddUVx, float2 ddUVy, in float2 div, in float edgeWidth, out float intensity) {
#if AA == 1
	Bricks(uv, div, edgeWidth, intensity);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset = offset.x * ddUVx + offset.y * ddUVy;
		Bricks(uv + offset, div, edgeWidth, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

//---------------------

//draw 2D grid
void Grid2D(in float2 uv, in float widthDiv, in float edgeWidth, out float intensity) {
	uv = fmod(uv * float2(widthDiv, widthDiv * _ScreenParams.y / _ScreenParams.x), float2(1.0, 1.0));
	float2 value = abs(uv - float2(0.5, 0.5)) - float2(edgeWidth * 0.5, edgeWidth * 0.5);
	intensity = float(min(value.x, value.y) < 0.0);
}

void Grid2DAA(in float2 uv, float2 ddUVx, float2 ddUVy, in float widthDiv, in float edgeWidth, out float intensity) {
#if AA == 1
	Grid2D(uv, widthDiv, edgeWidth, intensity)
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset = offset.x * ddUVx + offset.y * ddUVy;
		Grid2D(uv + offset, widthDiv, edgeWidth, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

//brick 2D sampler
void BricksSamplerPlain(in float2 uv, in float2 div, in float edgeWidth, out float intensity, out float2 sampleUV) {
	float2 orinal_uv = uv;
	uv = frac(uv * div);

	float shift = fmod(floor(orinal_uv.y * div.y), 2.0);

	orinal_uv += frac(float2(shift / div.x * 0.5, 0.0));
	float2 index = floor(orinal_uv * div);

	sampleUV = index / div;
	//uv *= shift;
	uv = frac(uv + float2(0.5 * shift, 0.0)) + float2(0.5, 0.5);
	float2 value = abs(uv - float2(0.5, 0.5)) - float2(edgeWidth * 0.5, edgeWidth * 0.5);
	intensity = float(min(value.x, value.y) > 0.0);
}

void BricksSamplerPlainAA(in float2 uv, float2 ddUVx, float2 ddUVy, in float2 div, in float edgeWidth, out float intensity, out float2 sampleUV) {
#if AA == 1
	BricksSamplerPlain(uv, div, edgeWidth, intensity, sampleUV);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset = offset.x * ddUVx + offset.y * ddUVy;
		BricksSamplerPlain(uv + offset, div, edgeWidth, subIntensity, sampleUV);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

float PHI = 1.61803398874989484820459 * 00000.1; // Golden Ratio   
float PI = 3.14159265358979323846264 * 00000.1; // PI
float SRT = 1.41421356237309504880169 * 10000.0; // Square Root of Two

float seed = 198.34;

// Gold Noise function
//
float gold_noise(in float2 coordinate, in float seed)
{
	return frac(sin(dot(coordinate*seed, float2(PHI, PI)))*SRT);
}

void BricksSamplerJittered(in float2 uv, in float2 div, in float edgeWidth, out float intensity, out float2 sampleUV) {
	float2 orinal_uv = uv;
	uv = frac(uv * div);

	float shift = fmod(floor(orinal_uv.y * div.y), 2.0);

	orinal_uv += frac(float2(shift / div.x * 0.5, 0.0));
	float2 index = floor(orinal_uv * div);

	float jitter = gold_noise(index / div, 278.30);

	jitter = saturate(jitter);

	sampleUV = index / div + float2(0.0, jitter);
	//uv *= shift;
	uv = frac(uv + float2(0.5 * shift, 0.0)) + float2(0.5, 0.5);
	float2 value = abs(uv - float2(0.5, 0.5)) - float2(edgeWidth * 0.5, edgeWidth * 0.5);
	intensity = float(min(value.x, value.y) > 0.0);
}

void BricksSamplerJitteredAA(in float2 uv, float2 ddUVx, float2 ddUVy, in float2 div, in float edgeWidth, out float intensity, out float2 sampleUV) {
#if AA == 1
	BricksSamplerJittered(uv, div, edgeWidth, intensity, sampleUV);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset = offset.x * ddUVx + offset.y * ddUVy;
		BricksSamplerJittered(uv + offset, div, edgeWidth, subIntensity, sampleUV);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

//


#endif