﻿Shader "Custome/PostEffectShader"
{
	Properties
	{
		_MainTex ("Main Texture", 2D) = "white" {}
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
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;

			fixed4 frag (v2f IN) : SV_Target
			{
				//float a = new float Random.Range(-0.2f, 0.2f);

				fixed4 col = tex2D( _MainTex, IN.uv + float2(0, sin( IN.vertex.x/50 ) /10 ) );
				// just invert the colors

				//col.r = 1;
				return col;
			}
			ENDCG
			

		}
	}
}
