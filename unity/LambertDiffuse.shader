Shader "Custom/LambertDiffuse" {

	//Lambert 漫反射模型测试

	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//物体表面材质对光的反射系数
		_Kd ("coefficient", Range(0, 1)) = 0.5
	}

	CGINCLUDE

	#include "UnityCG.cginc"
	#include "Lighting.cginc"

	sampler2D _MainTex;
	fixed _Kd;

	struct vertInput {
		fixed4 objectPosition : POSITION; //顶点模型空间坐标
		fixed4 objectNormal : NORMAL;	//顶点模型空间法线
		fixed4 texcoord0 : TEXCOORD0;	//纹理采样坐标
	};

	struct vertOutput {
		fixed4 position : POSITION;	//顶点投影空间坐标
		fixed4 texcoord0 : TEXCOORD0;
		fixed4 vertColor : COLOR;
	};

	vertOutput vert(vertInput i){
		vertOutput o;
		o.position = mul(UNITY_MATRIX_MVP, i.objectPosition);
		o.texcoord0 = i.texcoord0;

		fixed4 ambientColor = _Kd * UNITY_LIGHTMODEL_AMBIENT;
		//_Object2World 矩阵乘以顶点的模型空间坐标得到顶点的世界坐标
		fixed3 worldPosition = mul(_Object2World, i.objectPosition).xyz;
		//_Object2World_IT 为_Object2World矩阵的逆矩阵的转置矩阵
		float4x4 _Object2World_IT = transpose(_World2Object);
		//将顶点法线从模型空间变换到世界空间
		fixed3 worldNormal = mul(_Object2World_IT, i.objectNormal).xyz;
		//归一化
		fixed3 N = normalize(worldNormal);

		//_WorldSpaceLightPos0 内置全局变量，世界空间中的光源位置或方向（w = 0为平行光方向，否则为点光源坐标）
		//fixed3 worldLightPosition = _WorldSpaceLightPos0.xyz;
		//从顶点指向点光源的归一化向量
		//fixed3 L = normalize(worldLightPosition - worldPosition);
		//平行光方向归一化
		fixed3 L = normalize(_WorldSpaceLightPos0.xyz);

		// 点积 [-1, 1]，漫反射光强系数
		fixed dotValue = dot(N, L);
		//_LightColor0 光源颜色
		fixed4 diffuseColor = _Kd * _LightColor0 * max(dotValue, 0);

		o.vertColor = ambientColor + diffuseColor;
		return o;
	}

	fixed4 frag(vertOutput i) : COLOR {
		fixed4 texColor = tex2D(_MainTex, i.texcoord0.xy);
		fixed4 color;
		color.rgb = texColor + i.vertColor;
		color.a = 1;
		return color;
	}

	ENDCG

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		Pass {
			Tags {"LightMode" = "ForwardBase"} //平行光
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}
	} 
	FallBack Off
}
