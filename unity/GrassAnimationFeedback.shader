Shader "Custom/GrassAnimationFeedback" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CutOff ("Alpha CutOff", Range(0, 1)) = 0.5
		_AnimationStrength ("Ani Strength", Range(0, 1)) = 0.5
		_FeedbackStrength ("Fb Strength", Range(0, 1)) = 0.5
		_FeedbackDistance ("Fb Distance", float) = 1
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	sampler2D _MainTex;
	fixed _CutOff;
	fixed _AnimationStrength;
	fixed _FeedbackStrength;
	fixed _FeedbackDistance;
	fixed4 _EntityWorldPosition;

	struct VertInput {
		fixed4 MPos : POSITION;
		fixed4 MNor : NORMAL;
		fixed4 texcoord0 : TEXCOORD0;
	};

	struct VertOutput {
		fixed4 PPos : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
	};

	VertOutput Vert(VertInput i) {
		fixed offset = i.MPos.y * sin(_Time.y) * _AnimationStrength;
		i.MPos.xz += offset;

		VertOutput o;
		o.texcoord0 = i.texcoord0;

		#if ENTITYFEEDBACK

		fixed4 WPos = mul(_Object2World, i.MPos);
		fixed3 dir = fixed3(WPos.x, 0, WPos.z) - fixed3(_EntityWorldPosition.x, 0, _EntityWorldPosition.z);
		fixed distance = length(dir);
		//在反馈距离内，离的越近反馈强度系数越大
		fixed r = (_FeedbackDistance - min(distance, _FeedbackDistance)) / _FeedbackDistance;
		fixed3 ndir = normalize(dir);
		WPos.xz += (_FeedbackStrength * ndir * r).xz;
		fixed4 MPos = mul(_World2Object, WPos);
		o.PPos = mul(UNITY_MATRIX_MVP, MPos);

		#elif GENERAL
		
		o.PPos = mul(UNITY_MATRIX_MVP, i.MPos);

		#endif

		return o;
	}

	fixed4 Frag(VertOutput i) : COLOR {
		fixed4 color = tex2D(_MainTex, i.texcoord0);
		clip(color.a - _CutOff);
		return color;
	}

	ENDCG

	SubShader {
		LOD 200
		
		Pass {
			CGPROGRAM

			#pragma multi_compile ENTITYFEEDBACK GENERAL
			#pragma vertex Vert
			#pragma fragment Frag

			ENDCG
		}
	} 

	FallBack "Diffuse"
}
