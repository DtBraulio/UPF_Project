Shader "Unlit/Test_01"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_WaveNoiseTex("Wave Noise Texture", 2D) = "white" {}
		_WaveLightTex("Wave Light Texture", 2D) = "white" {}

		_WaveDamper01(" Wave Damper_01", float) = 10
		_WaveSpeed01(" Wave Speed_01", float) = 1
		_WaveDamper02(" Wave Damper_02", float) = 10
		_WaveSpeed02(" Wave Speed_02", float) = 1

		_WaveReflexSpeed(" Wave Reflex Speed", float) = 1

		_MainColor ("Main Color", vector) = (0,0,0,0)


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
			sampler2D _WaveNoiseTex;
			sampler2D _WaveLightTex;
			float4 _MainTex_ST;
			float _WaveDamper01;
			float _WaveSpeed01;
			float _WaveDamper02;
			float _WaveSpeed02;
			float _WaveReflexSpeed;
			fixed4 _MainColor;
			
			v2f vert (appdata v)
			{
				v2f OUT;

				float4 vertexMainWaves = float4(
					0,
					sin(v.vertex.x + _Time[1] * _WaveSpeed01) * tex2Dlod(_WaveNoiseTex, float4( 0, 0, 0, 0)).r / _WaveDamper01,
					0 ,
					0);

				float4 vertexSecondWaves = float4(
					0,
					sin(v.vertex.z + _Time[1] * _WaveSpeed02) * tex2Dlod(_WaveNoiseTex, float4(0, 0, 0, 0)).r / _WaveDamper02,
					0,
					0);
				OUT.vertex = UnityObjectToClipPos(v.vertex + vertexMainWaves + vertexSecondWaves);

				OUT.uv = TRANSFORM_TEX(v.uv, _MainTex);

				UNITY_TRANSFER_FOG(OUT, OUT.vertex);
				return OUT;
			}
			
			fixed4 frag (v2f IN) : SV_Target
			{
				// sample the texture
				//fixed4 col = tex2D(_MainTex, IN.uv);

				//sampler2D TexCrt = _MainColor;

				fixed4 color01 =_MainColor;
				float4 uvWaves = float4(
					0,
					(IN.uv.x + _Time[1] * _WaveReflexSpeed),
					0,
					0);

				fixed4 color02= tex2D(_WaveLightTex, IN.uv + uvWaves);

				fixed4 col = color01 + color02/2;

				// apply fog
				UNITY_APPLY_FOG(IN.fogCoord, col);

				return col;
			}
			ENDCG
		}
	}
}
