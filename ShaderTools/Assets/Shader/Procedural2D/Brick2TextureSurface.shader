Shader "Procedural2D/Brick2TextureSurface" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SecondTex ("Albedo (RGB)", 2D) = "black" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_Division("Brick Division", Vector) = (3.0, 6.0, 0.0, 0.0)
		_Border("Border width", float) = 0.02
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#include "ProceduralLibrary2D.cginc"

		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _SecondTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecondTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		//brick
		float4 _Division;
		float _Border;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			float intensity = 0.0;
			float2 ddxUV = ddx(IN.uv_MainTex);
			float2 ddyUV = ddy(IN.uv_MainTex);
			BricksAA(IN.uv_MainTex, ddxUV, ddyUV, _Division.xy, _Border, intensity);
			fixed4 cMain = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			fixed4 cSecond = tex2D(_SecondTex, IN.uv_SecondTex) * _Color;
			fixed4 c = cMain * intensity + (1.0 - intensity) * cSecond;
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
