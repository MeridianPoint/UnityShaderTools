#ifndef PROCEDURAL_LIBRARY_3D_INCLUDED
#define PROCEDURAL_LIBRARY_3D_INCLUDED

/* shader library for 3d textures
*/

//#ifndef AA
#define AA 8
//#endif

//binary grid
void Grid3D(float3 pos, float3 size, float3 bordersize, out float intensity) {
	float3 uvw = frac(pos * size);
	float3 evaluate = saturate(uvw - bordersize);
	intensity = float(min(min(evaluate.x, evaluate.y), evaluate.z) >0);
	//intensity = uvw.x;
}

void Grid3DAA(float3 pos, float3 ddPosx, float3 ddPosy, float3 size, float3 bordersize, out float intensity){
#if AA == 1
	Grid3D(pos, size, bordersize, intensity);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		//offset *= subPix;
		float3 posOffset = offset.x * ddPosx + offset.y * ddPosy;
		Grid3D(pos + posOffset, size, bordersize, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

void CheckBoard3D(float3 pos, float3 size, out float intensity) {
	float3 uvw = floor(pos * size);
	float3 evaluate = uvw * float3(0.5, 0.5, 0.5);
	intensity = frac(evaluate.x + evaluate.y + evaluate.z) * 2.0;
}

void CheckBoard3DAA(float3 pos, float3 ddPosx, float3 ddPosy, float3 size, out float intensity) {
#if AA == 1
	CheckBoard3D(pos, size, intensity);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		//offset *= subPix;
		float3 posOffset = offset.x * ddPosx + offset.y * ddPosy;
		CheckBoard3D(pos + posOffset, size, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}

void Bricks3D(float3 pos, float3 size, float3 border, out float intensity) {
	float3 index = floor(pos * size);
	float3 uvw = frac(pos * size);
	float3 offset = fmod(index.y, 2.0) * float3(0.5, 0.0, 0.5);
	uvw = frac(uvw + offset) + float3(0.5, 0.5, 0.5);
	float3 value = abs(uvw - float3(0.5, 0.5, 0.5)) - border * 0.5;
	intensity = float(min(min(value.x, value.y), value.z) > 0.0);
}

void Bricks3DAA(float3 pos, float3 ddPosx, float3 ddPosy, float3 size, float3 border, out float intensity) {
#if AA == 1
	Bricks3D(pos, size, border, intensity);
#else
	//float2 subPix = float2(1.0, 1.0) / _ScreenParams.xy;
	float subIntensity = 0.0;
	for (int i = 0; i < AA * AA; i++) {
		float2 offset = float2(i % AA, i / AA) - float2(0.5, 0.5);
		offset /= float2(AA, AA);
		//offset *= subPix;
		float3 posOffset = offset.x * ddPosx + offset.y * ddPosy;
		Bricks3D(pos + posOffset, size, border, subIntensity);
		intensity += subIntensity;
	}
	intensity /= float(AA * AA);
#endif
}


#endif