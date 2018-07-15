Shader "Custom/FragmentClip" {

	//片段裁剪

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NoiseTex ("Noise (RGB)", 2D) = "white" {}
		_EdgeColor ("Edge Color", Color) = (1, 1, 1, 1)
		_EdgeWidth ("Edge Width", float) = 0.1
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	sampler2D _MainTex;
	sampler2D _NoiseTex;
	fixed4 _EdgeColor;
	fixed _EdgeWidth;

	struct vertInput{
		fixed4 objectPosition : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
	};

	struct vertOutput{
		fixed4 position : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
		fixed4 vertColor : COLOR;
	};

	vertOutput vert(vertInput i){
		vertOutput o;
		o.position = mul(UNITY_MATRIX_MVP, i.objectPosition);
		o.texcoord0 = i.texcoord0;
		o.vertColor = UNITY_LIGHTMODEL_AMBIENT;
		return o;
	}

	fixed4 frag(vertOutput i) : COLOR {
		fixed4 texColor = tex2D(_MainTex, i.texcoord0);
		fixed4 noiseColor = tex2D(_NoiseTex, i.texcoord0);
		fixed4 color = texColor + i.vertColor;

		fixed factor = (sin(_Time.y) + 1) / 2;
		fixed dValue = (noiseColor - factor).r;
		if(dValue <= 0){
			clip(-1);
		}else{
			//边缘片段处理，离边缘越远，颜色越正常
			fixed4 blendColor = color * _EdgeColor;
			fixed edgeFactor = saturate(dValue / _EdgeWidth);
			color = lerp(color, blendColor, 1 - edgeFactor);
		}
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
