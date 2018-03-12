Shader "Procedural2D/SampledBricksSurf" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		//parameters for bricks
		_TileDiv("brick tile division", Vector) = (3.0, 6.0, 0.0, 0.0)
		_EdgeWidth("brick edge width", Float) = 0.02

		//color for gradient
		_MidColor("color middle of gradient", Color) = (1,1,1,1)
		_SideColor("color side of gradient", Color) = (0,0,0,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

#include "ProceduralLibrary2D.cginc"

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		//
		float4 _TileDiv;
		float _EdgeWidth;

			//color for gradient
		float4 _MidColor;
		float4 _SideColor;


		//create basic gradient
		float3 gradient(float2 uv, float3 colorMid, float3 colorSide) {
			float intensity = abs(uv.y - 0.5);
			return colorMid * intensity + colorSide * (1.0 - intensity);
		}

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			float2 uv = IN.uv_MainTex;
			
			float2 sampleuv = float2(0.0, 0.0);
			float intensity = 0.0;
			float2 ddUVX = ddx(IN.uv_MainTex);
			float2 ddUVY = ddy(IN.uv_MainTex);
			BricksSamplerJitteredAA(uv, ddUVX, ddUVY, _TileDiv, _EdgeWidth, intensity, sampleuv);
			float3 grad = gradient(sampleuv, _MidColor, _SideColor);
			fixed4 c = float4(intensity * grad, 1.0);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
