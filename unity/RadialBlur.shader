Shader "SUN/RadialBlur" {
	//径向模糊
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlurTex ("Blur (RGB)", 2D) = "white" {}
		_BlurCenter ("Point", Vector) = (0.5, 0.5, 0, 0)
		_BlurDist ("Blur Distance", Float) = 1
		_BlurStrength("Blur Strength", Float) = 1
	}

	CGINCLUDE

	sampler2D _MainTex;
	sampler2D _BlurTex;
	fixed2 _BlurCenter;
	fixed _BlurDist;
	fixed _BlurStrength;
		
	#include "UnityCG.cginc"

	struct vertInput {
		fixed4 position : POSITION;
		fixed4 texcoord : TEXCOORD0;
	};

	struct vertOutput {
		fixed4 sv_position : SV_POSITION;
		fixed4 uv_texcoord : TEXCOORD0;
	};

	vertOutput vertBlur(vertInput i){
		vertOutput o;
		o.sv_position = mul(UNITY_MATRIX_MVP, i.position);
		o.uv_texcoord = i.texcoord;
		return o;
	}

	fixed4 fragBlur(vertOutput i) : COLOR{
		fixed2 dir = _BlurCenter - i.uv_texcoord;
		fixed dist = length(dir);
		dir /= dist;
		dir *= _BlurDist;

		fixed4 color = tex2D(_MainTex, i.uv_texcoord + dir * 0.01);
		color += tex2D(_MainTex, i.uv_texcoord + dir * 0.02);
		color += tex2D(_MainTex, i.uv_texcoord + dir * 0.03);
		color += tex2D(_MainTex, i.uv_texcoord + dir * 0.05);
		color += tex2D(_MainTex, i.uv_texcoord + dir * 0.08);
		color += tex2D(_MainTex, i.uv_texcoord - dir * 0.01);
		color += tex2D(_MainTex, i.uv_texcoord - dir * 0.02);
		color += tex2D(_MainTex, i.uv_texcoord - dir * 0.03);
		color += tex2D(_MainTex, i.uv_texcoord - dir * 0.05);
		color += tex2D(_MainTex, i.uv_texcoord - dir * 0.08);
		color *= 0.1;

		return color;
	}

	fixed4 fragLerp(vertOutput i) : COLOR {
		fixed dist = length(_BlurCenter - i.uv_texcoord);
		fixed4 color = tex2D(_MainTex, i.uv_texcoord);
		fixed4 colorBlur = tex2D(_BlurTex, i.uv_texcoord);
		color = lerp(color, colorBlur, saturate(dist * _BlurStrength)); 
		//saturate 饱和度处理[0,1]，大于1取1，小于0取0
		//lerp 线性插值 lerp(a,b,f) { return (1 – f ) * a + b * f }
		return color;
	}

	ENDCG

	SubShader {
		Cull Off AlphaTest Off ZTest Off ZWrite Off Blend Off Fog { Mode off }

		//0
		Pass {
			CGPROGRAM
		
			#pragma vertex vertBlur
			#pragma fragment fragBlur
			#pragma fragmentoption ARB_precision_hint_fastest 
		
			ENDCG
		}

		//1
		Pass {
			CGPROGRAM

			#pragma vertex vertBlur
			#pragma fragment fragLerp
			#pragma fragmentoption ARB_precision_hint_fastest 

			ENDCG
		}
	}

	FallBack Off
}
