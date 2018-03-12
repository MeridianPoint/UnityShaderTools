Shader "Procedural3D/UnlitCheckerBoardBW3D"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	_TileSize("tilesize", Vector) = (0.2, 0.2, 0.2, 0.0)
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

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.WSPos = mul(unity_ObjectToWorld, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o, o.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float intensity = 1.0;
			//Grid3D(abs(i.WSPos.xyz), float3 (0.2, 0.2, 0.2), float3(0.3, 0.3, 0.3), intensity);
			float3 ddposX = ddx(i.WSPos).xyz;
			float3 ddposY = ddy(i.WSPos).xyz;
			CheckBoard3DAA(i.WSPos.xyz, ddposX, ddposY, _TileSize.xyz, intensity);
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
