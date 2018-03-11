#ifndef PROCEDURAL_LIBRARY_3D_INCLUDED
#define PROCEDURAL_LIBRARY_3D_INCLUDED

/* shader library for 3d textures
*/

//binary grid
void Grid3D(float3 pos, float3 size, float3 bordersize, out float intensity) {
	float3 uvw = fmod(pos, size);
	float3 evaluate = saturate(uvw - bordersize);
	intensity = float(min(min(evaluate.x, evaluate.y), evaluate.z) >0);
	//intensity = uvw.x;
}

void CheckBoard3D(float3 pos, float3 size, out float intensity) {
	float3 uvw = floor(pos * size);
	float3 evaluate = uvw * float3(0.5, 0.5, 0.5);
	intensity = frac(evaluate.x + evaluate.y + evaluate.z) * 2.0;
}

void Bricks3D(float3 pos, float3 size, float3 border, out float intensity) {
	float3 index = floor(pos * size);
	float3 uvw = frac(pos * size);
	float3 offset = fmod(index.y, 2.0) * float3(0.5, 0.0, 0.5);
	uvw = frac(uvw + offset) + float3(0.5, 0.5, 0.5);
	float3 value = abs(uvw - float3(0.5, 0.5, 0.5)) - border * 0.5;
	intensity = float(min(min(value.x, value.y), value.z) > 0.0);
}


#endif