Shader "Hidden/TestProcedural"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
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
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f i) : SV_Target
			{
				float intensity = 0.0;
			    CheckerBoard(i.uv, 4.0, intensity);
				fixed4 col = float4(intensity, intensity, intensity, 1.0);
				//fixed4 col = tex2D(_MainTex, i.uv);
				// just invert the colors
				col.rgb = 1 - col.rgb;
				return col;
			}
			ENDCG
		}
	}
}
