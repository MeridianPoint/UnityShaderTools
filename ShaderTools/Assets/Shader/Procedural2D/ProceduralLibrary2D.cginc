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
void CheckerBoardAA(in float2 uv, in float widthDiv, out float intensity) {
#if AA == 1
	CheckerBoard(uv, widthDiv, intensity);
#else
	float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset *= subPix;
		CheckerBoard(uv + offset, widthDiv, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

//draw 2D grid
void Grid2D(in float2 uv, in float widthDiv, in float edgeWidth, out float intensity){
    uv = fmod(uv * float2(widthDiv, widthDiv * _ScreenParams.y /_ScreenParams.x), float2(1.0, 1.0));
    float2 value = abs(uv - float2(0.5, 0.5)) - float2(edgeWidth * 0.5, edgeWidth * 0.5);
    intensity = float(min(value.x, value.y) < 0.0);
}

//draw grid of spheres
void SphereGrid(in float2 uv, in float widthDiv, in float radiusPre, out float intensity){
    uv = fmod(uv * float2(widthDiv, widthDiv * _ScreenParams.y / _ScreenParams.x), float2(1.0, 1.0));
    float2 value = uv - float2(0.5, 0.5);
    intensity = float(length(value) > radiusPre);
}

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

void BricksAA(in float2 uv, in float2 div, in float edgeWidth, out float intensity) {
#if AA == 1
	Bricks(uv, div, edgeWidth, intensity);
#else
	float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		offset *= subPix;
		Bricks(uv + offset, div, edgeWidth, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}


#endif