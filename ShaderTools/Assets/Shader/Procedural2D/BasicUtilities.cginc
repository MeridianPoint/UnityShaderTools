#ifndef BASIC_UTILITEIS_INCLUDED
#define BASIC_UTILITEIS_INCLUDED

//---------------
//uv helpers
//-----------------

//uv transformation
float2 uvTransform(float2 uv, float3x3 transform){
	float3 hg_uv = float3(uv.xy, 1.0);
	hg_uv = mul(transform, hg_uv);
	return hg_uv.xy;
}

//use world space xz
float2 WSPlane(float4 WSPos, float4x4 transform){
	float2 uv = float3(WSPos.xz, 1.0);
	uv = uvTransform(uv, transform);
	return uv;
}

float2 WSVerticle(float4 WSPos, float4x4 transform){
	float2 uv = float3(distance(WSPos.xz, 0), WSPos.y, 1.0);
}

#endif