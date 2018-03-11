﻿Shader "Procedural3D/UnlitBricksBW3D"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_TileSize("tilesize", Vector) = (0.2, 0.2, 0.2, 0.0)
		_EdgeWidth("EdgeWidth", Float) = 0.2
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"
			#include "ProceduralLibrary3D.cginc"

				struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float3 WSPos: TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TileSize;
			float _EdgeWidth;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.WSPos = mul(unity_ObjectToWorld, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float intensity = 1.0;
				//Grid3D(abs(i.WSPos.xyz), float3 (0.2, 0.2, 0.2), float3(0.3, 0.3, 0.3), intensity);
				//CheckBoard3D(i.WSPos.xyz, _TileSize.xyz, intensity);
				float3 edge = float3(_EdgeWidth, _EdgeWidth, _EdgeWidth);
				Bricks3D(i.WSPos.xyz, _TileSize.xyz, edge, intensity);
				fixed4 col = float4(intensity, intensity, intensity, 1.0);
				//fixed4 col = float4(i.WSPos.xyz, 1.0);
				// sample the texture
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
