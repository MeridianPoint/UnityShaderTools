Shader "Procedural2D/UnlitBricksBW"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Division ("Brick Division", Vector) = (3.0, 6.0, 0.0, 0.0)
		_Border ("Border width", float) = 0.02
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
			#include "ProceduralLibrary2D.cginc"

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
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Division;
			float _Border;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture

				float intensity = 0.0;
				float2 ddUVX = ddx(i.uv);
				float2 ddUVY = ddy(i.uv);
				BricksAA(i.uv, ddUVX, ddUVY, _Division.xy, _Border, intensity);
				fixed4 col = float4(intensity, intensity, intensity, 1.0);
				//fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
