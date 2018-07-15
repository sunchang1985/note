Shader "Custom/Ambient" {

	//环境光测试

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//物体表面材质对光的反射系数
		_Kd ("coefficient", Range(0, 1)) = 0.5
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	sampler2D _MainTex;
	fixed _Kd;

	struct vertInput {
		fixed4 objectPosition : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
	};

	struct vertOutput {
		fixed4 position : POSITION;
		fixed4 texcoord0 : TEXCOORD0;
		fixed4 vertColor : COLOR;
	};

	vertOutput vert(vertInput i){
		vertOutput o;
		//通过MVP矩阵变换得到顶点的投影空间坐标
		o.position = mul(UNITY_MATRIX_MVP, i.objectPosition);
		o.texcoord0 = i.texcoord0;
		//UNITY_LIGHTMODEL_AMBIENT 内置全局变量，环境光
		o.vertColor = _Kd * UNITY_LIGHTMODEL_AMBIENT;
		return o;
	}

	fixed4 frag(vertOutput i) : COLOR{
		fixed4 texColor = tex2D(_MainTex, i.texcoord0.xy);
		fixed4 color = texColor + i.vertColor;
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

	FallBack Off
}
