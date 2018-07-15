Shader "Custom/VertexSin" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_EffectTex ("RGB", 2D) = "white" {}
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	sampler2D _MainTex;
	sampler2D _EffectTex;

	struct vertInput {
		fixed4 objectPosition : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
		fixed4 objectNormal : NORMAL;
	};

	struct vertOutput {
		fixed4 position : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
		fixed4 vertColor : COLOR;
		fixed4 objectNormal : NORMAL;
	};

	vertOutput vert(vertInput i){
		vertOutput o;
		o.position = mul(UNITY_MATRIX_MVP, i.objectPosition) + sin(_Time.x * 10);
		o.texcoord0 = i.texcoord0;
		o.vertColor = UNITY_LIGHTMODEL_AMBIENT;
		o.objectNormal = i.objectNormal;
		return o;
	}

	fixed4 frag(vertOutput i) : COLOR {
		fixed3 worldNormal = normalize(mul(transpose(_World2Object), i.objectNormal).xyz);
		fixed2 normalUV = worldNormal.xy + _Time.x * 20;
		fixed4 effectColor = tex2D(_EffectTex, normalUV); //流光
		fixed4 texColor = tex2D(_MainTex, i.texcoord0);
		fixed4 color = texColor + effectColor + i.vertColor;
		return color;
	}

	ENDCG

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass {
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}

	} 
	FallBack "Diffuse"
}
