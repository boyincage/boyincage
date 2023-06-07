// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Lolmingmmmm/Dissolve_m01"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Enum(OFF,0,ON,1)]_Zwrite("Zwrite", Float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)]_Ztest("Ztest", Float) = 4
		[Enum(UnityEngine.Rendering.BlendMode)]_BlendScr("BlendScr", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)]_BlendDst("BlendDst", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 0
		_Main_Tex("Main_Tex", 2D) = "white" {}
		[HDR]_Mani_Color("Mani_Color", Color) = (1,1,1,1)
		_MainTilingOffset("MainTilingOffset", Vector) = (1,1,0,0)
		_Dissolve_Tex("Dissolve_Tex", 2D) = "white" {}
		_DissTilingOffset("DissTilingOffset", Vector) = (1,1,0,0)
		_Diss_Uspeed("Diss_Uspeed", Float) = 0
		_Diss_Vspeed("Diss_Vspeed", Float) = 0
		[HDR]_Eded_Color("Eded_Color", Color) = (1,1,1,1)
		_Edeg("Edeg", Float) = 0.15
		_soft("soft", Range( 0.5 , 1)) = 1
		[Toggle(_SOFTORHARD_ON)] _SoftorHard("Soft or Hard", Float) = 0
		_Noise_Tex("Noise_Tex", 2D) = "white" {}
		_NoiseTilingOffset("NoiseTilingOffset", Vector) = (1,1,0,0)
		_Noise_Uspeed("Noise_Uspeed", Float) = 0
		_Nosie_Vspeed("Nosie_Vspeed", Float) = 0
		_Noise_Power("Noise_Power", Float) = 0
		_Vertex("Vertex", 2D) = "white" {}
		_VertexScale("VertexScale", Float) = 0
		_VexUspeed("VexUspeed", Float) = 0
		_VexVspeed("VexVspeed", Float) = 0
		[Enum(RGB,0,R,1)]_RGBorR("RGB or R", Float) = 0
		[Enum(Polar,0,Normal,1)]_NormalorPolar("Normal or Polar", Float) = 1
		_MaskTex("MaskTex", 2D) = "white" {}
		_Vertex_XYZ("Vertex_XYZ", Vector) = (0,0,0,0)
		_VertexShapen("Vertex Shapen", Float) = 0
		_SoftParticeMult("SoftParticeMult", Float) = 0
		[ASEEnd][Enum(OFF,0,ON,1)]_Float1("软粒子开关", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25
	}

	SubShader
	{
		LOD 0

		
		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }
		
		Cull [_CullMode]
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 2.0

		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}
		
		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
						  (( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }
			
			Blend [_BlendScr] [_BlendDst]
			ZWrite [_Zwrite]
			ZTest [_Ztest]
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_SRP_VERSION 70502
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _SOFTORHARD_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef ASE_FOG
				float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_color : COLOR;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _MainTilingOffset;
			float4 _Eded_Color;
			float4 _DissTilingOffset;
			float4 _Mani_Color;
			float4 _Vertex_ST;
			float4 _MaskTex_ST;
			float4 _Main_Tex_ST;
			float4 _NoiseTilingOffset;
			float3 _Vertex_XYZ;
			float _Edeg;
			float _Diss_Vspeed;
			float _Diss_Uspeed;
			float _soft;
			float _RGBorR;
			float _Noise_Power;
			float _Nosie_Vspeed;
			float _Ztest;
			float _SoftParticeMult;
			float _NormalorPolar;
			float _VertexShapen;
			float _VexVspeed;
			float _VexUspeed;
			float _VertexScale;
			float _Zwrite;
			float _CullMode;
			float _BlendDst;
			float _BlendScr;
			float _Noise_Uspeed;
			float _Float1;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Vertex;
			sampler2D _MaskTex;
			sampler2D _Main_Tex;
			sampler2D _Noise_Tex;
			sampler2D _Dissolve_Tex;
			uniform float4 _CameraDepthTexture_TexelSize;


						
			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 appendResult125 = (float2(_VexUspeed , _VexVspeed));
				float2 uv_Vertex = v.ase_texcoord * _Vertex_ST.xy + _Vertex_ST.zw;
				float4 texCoord145 = v.ase_texcoord2;
				texCoord145.xy = v.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult146 = (float2(texCoord145.x , texCoord145.y));
				float2 panner126 = ( 1.0 * _Time.y * appendResult125 + (uv_Vertex*1.0 + appendResult146));
				float2 uv_MaskTex = v.ase_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 tex2DNode115 = tex2Dlod( _MaskTex, float4( uv_MaskTex, 0, 0.0) );
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				
				o.ase_texcoord3 = v.ase_texcoord;
				o.ase_texcoord4 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( _VertexScale * pow( tex2Dlod( _Vertex, float4( panner126, 0, 0.0) ).r , _VertexShapen ) * v.ase_normal * _Vertex_XYZ * tex2DNode115.r * texCoord145.z );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				VertexPositionInputs vertexInput = (VertexPositionInputs)0;
				vertexInput.positionWS = positionWS;
				vertexInput.positionCS = positionCS;
				o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				#ifdef ASE_FOG
				o.fogFactor = ComputeFogFactor( positionCS.z );
				#endif
				o.clipPos = positionCS;
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord2 = v.ase_texcoord2;
				o.ase_texcoord1 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_texcoord2 = patch[0].ase_texcoord2 * bary.x + patch[1].ase_texcoord2 * bary.y + patch[2].ase_texcoord2 * bary.z;
				o.ase_texcoord1 = patch[0].ase_texcoord1 * bary.x + patch[1].ase_texcoord1 * bary.y + patch[2].ase_texcoord1 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif
				float4 texCoord78 = IN.ase_texcoord3;
				texCoord78.xy = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult79 = (float2(texCoord78.x , texCoord78.y));
				float2 temp_output_80_0 = (appendResult79*2.0 + -1.0);
				float2 break84 = temp_output_80_0;
				float2 appendResult88 = (float2(length( temp_output_80_0 ) , (0.0 + (atan2( break84.y , break84.x ) - 0.0) * (1.0 - 0.0) / (3.141593 - 0.0))));
				float2 Polar135 = appendResult88;
				float2 uv_Main_Tex = IN.ase_texcoord3.xy * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
				float2 lerpResult108 = lerp( Polar135 , uv_Main_Tex , _NormalorPolar);
				float2 appendResult111 = (float2(_MainTilingOffset.x , _MainTilingOffset.y));
				float4 texCoord116 = IN.ase_texcoord4;
				texCoord116.xy = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult110 = (float2(texCoord116.x , texCoord116.y));
				float2 appendResult53 = (float2(_Noise_Uspeed , _Nosie_Vspeed));
				float2 texCoord50 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult102 = lerp( Polar135 , texCoord50 , _NormalorPolar);
				float2 appendResult98 = (float2(_NoiseTilingOffset.x , _NoiseTilingOffset.y));
				float2 appendResult99 = (float2(_NoiseTilingOffset.z , _NoiseTilingOffset.w));
				float2 panner49 = ( 1.0 * _Time.y * appendResult53 + (lerpResult102*appendResult98 + appendResult99));
				float4 temp_output_54_0 = ( tex2D( _Noise_Tex, panner49 ) * texCoord116.z * _Noise_Power );
				float4 Noise132 = temp_output_54_0;
				float4 tex2DNode35 = tex2D( _Main_Tex, ( float4( (lerpResult108*appendResult111 + appendResult110), 0.0 , 0.0 ) + Noise132 ).rg );
				float4 temp_cast_2 = (tex2DNode35.r).xxxx;
				float4 lerpResult69 = lerp( tex2DNode35 , temp_cast_2 , _RGBorR);
				float2 appendResult59 = (float2(_Diss_Uspeed , _Diss_Vspeed));
				float2 texCoord93 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult94 = lerp( Polar135 , texCoord93 , _NormalorPolar);
				float2 appendResult91 = (float2(_DissTilingOffset.x , _DissTilingOffset.y));
				float2 appendResult92 = (float2(_DissTilingOffset.z , _DissTilingOffset.w));
				float2 panner60 = ( 1.0 * _Time.y * appendResult59 + (lerpResult94*appendResult91 + appendResult92));
				float4 tex2DNode5 = tex2D( _Dissolve_Tex, ( float4( panner60, 0.0 , 0.0 ) + temp_output_54_0 ).rg );
				float smoothstepResult13 = smoothstep( ( 1.0 - _soft ) , _soft , saturate( ( ( tex2DNode5.r + 1.0 ) - ( texCoord116.w * 2.0 ) ) ));
				float temp_output_27_0 = step( texCoord116.w , tex2DNode5.r );
				float temp_output_30_0 = ( temp_output_27_0 - step( ( texCoord116.w + _Edeg ) , tex2DNode5.r ) );
				#ifdef _SOFTORHARD_ON
				float staticSwitch34 = ( temp_output_27_0 + temp_output_30_0 );
				#else
				float staticSwitch34 = smoothstepResult13;
				#endif
				float4 temp_output_38_0 = ( lerpResult69 * _Mani_Color * IN.ase_color * staticSwitch34 );
				float4 lerpResult72 = lerp( temp_output_38_0 , _Eded_Color , temp_output_30_0);
				#ifdef _SOFTORHARD_ON
				float4 staticSwitch76 = lerpResult72;
				#else
				float4 staticSwitch76 = temp_output_38_0;
				#endif
				float4 screenPos = IN.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth149 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth149 = abs( ( screenDepth149 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftParticeMult ) );
				float temp_output_152_0 = saturate( distanceDepth149 );
				float4 lerpResult153 = lerp( staticSwitch76 , ( temp_output_152_0 * staticSwitch76 ) , _Float1);
				
				#ifdef _SOFTORHARD_ON
				float staticSwitch66 = temp_output_27_0;
				#else
				float staticSwitch66 = smoothstepResult13;
				#endif
				float2 uv_MaskTex = IN.ase_texcoord3.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 tex2DNode115 = tex2D( _MaskTex, uv_MaskTex );
				float temp_output_107_0 = ( staticSwitch66 * tex2DNode35.a * tex2DNode115.r * IN.ase_color.a );
				float lerpResult155 = lerp( temp_output_107_0 , ( temp_output_152_0 * temp_output_107_0 ) , _Float1);
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = lerpResult153.rgb;
				float Alpha = lerpResult155;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM
			#define _RECEIVE_SHADOWS_OFF 1
			#define ASE_SRP_VERSION 70502
			#define REQUIRE_DEPTH_TEXTURE 1

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_COLOR
			#pragma shader_feature_local _SOFTORHARD_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_color : COLOR;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _MainTilingOffset;
			float4 _Eded_Color;
			float4 _DissTilingOffset;
			float4 _Mani_Color;
			float4 _Vertex_ST;
			float4 _MaskTex_ST;
			float4 _Main_Tex_ST;
			float4 _NoiseTilingOffset;
			float3 _Vertex_XYZ;
			float _Edeg;
			float _Diss_Vspeed;
			float _Diss_Uspeed;
			float _soft;
			float _RGBorR;
			float _Noise_Power;
			float _Nosie_Vspeed;
			float _Ztest;
			float _SoftParticeMult;
			float _NormalorPolar;
			float _VertexShapen;
			float _VexVspeed;
			float _VexUspeed;
			float _VertexScale;
			float _Zwrite;
			float _CullMode;
			float _BlendDst;
			float _BlendScr;
			float _Noise_Uspeed;
			float _Float1;
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Vertex;
			sampler2D _MaskTex;
			sampler2D _Dissolve_Tex;
			sampler2D _Noise_Tex;
			sampler2D _Main_Tex;
			uniform float4 _CameraDepthTexture_TexelSize;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 appendResult125 = (float2(_VexUspeed , _VexVspeed));
				float2 uv_Vertex = v.ase_texcoord * _Vertex_ST.xy + _Vertex_ST.zw;
				float4 texCoord145 = v.ase_texcoord2;
				texCoord145.xy = v.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult146 = (float2(texCoord145.x , texCoord145.y));
				float2 panner126 = ( 1.0 * _Time.y * appendResult125 + (uv_Vertex*1.0 + appendResult146));
				float2 uv_MaskTex = v.ase_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 tex2DNode115 = tex2Dlod( _MaskTex, float4( uv_MaskTex, 0, 0.0) );
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.ase_texcoord2 = v.ase_texcoord;
				o.ase_texcoord3 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = ( _VertexScale * pow( tex2Dlod( _Vertex, float4( panner126, 0, 0.0) ).r , _VertexShapen ) * v.ase_normal * _Vertex_XYZ * tex2DNode115.r * texCoord145.z );
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = TransformWorldToHClip( positionWS );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_color : COLOR;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				o.ase_texcoord2 = v.ase_texcoord2;
				o.ase_texcoord1 = v.ase_texcoord1;
				o.ase_color = v.ase_color;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
			   return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				o.ase_texcoord2 = patch[0].ase_texcoord2 * bary.x + patch[1].ase_texcoord2 * bary.y + patch[2].ase_texcoord2 * bary.z;
				o.ase_texcoord1 = patch[0].ase_texcoord1 * bary.x + patch[1].ase_texcoord1 * bary.y + patch[2].ase_texcoord1 * bary.z;
				o.ase_color = patch[0].ase_color * bary.x + patch[1].ase_color * bary.y + patch[2].ase_color * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float2 appendResult59 = (float2(_Diss_Uspeed , _Diss_Vspeed));
				float4 texCoord78 = IN.ase_texcoord2;
				texCoord78.xy = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 appendResult79 = (float2(texCoord78.x , texCoord78.y));
				float2 temp_output_80_0 = (appendResult79*2.0 + -1.0);
				float2 break84 = temp_output_80_0;
				float2 appendResult88 = (float2(length( temp_output_80_0 ) , (0.0 + (atan2( break84.y , break84.x ) - 0.0) * (1.0 - 0.0) / (3.141593 - 0.0))));
				float2 Polar135 = appendResult88;
				float2 texCoord93 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult94 = lerp( Polar135 , texCoord93 , _NormalorPolar);
				float2 appendResult91 = (float2(_DissTilingOffset.x , _DissTilingOffset.y));
				float2 appendResult92 = (float2(_DissTilingOffset.z , _DissTilingOffset.w));
				float2 panner60 = ( 1.0 * _Time.y * appendResult59 + (lerpResult94*appendResult91 + appendResult92));
				float2 appendResult53 = (float2(_Noise_Uspeed , _Nosie_Vspeed));
				float2 texCoord50 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float2 lerpResult102 = lerp( Polar135 , texCoord50 , _NormalorPolar);
				float2 appendResult98 = (float2(_NoiseTilingOffset.x , _NoiseTilingOffset.y));
				float2 appendResult99 = (float2(_NoiseTilingOffset.z , _NoiseTilingOffset.w));
				float2 panner49 = ( 1.0 * _Time.y * appendResult53 + (lerpResult102*appendResult98 + appendResult99));
				float4 texCoord116 = IN.ase_texcoord3;
				texCoord116.xy = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float4 temp_output_54_0 = ( tex2D( _Noise_Tex, panner49 ) * texCoord116.z * _Noise_Power );
				float4 tex2DNode5 = tex2D( _Dissolve_Tex, ( float4( panner60, 0.0 , 0.0 ) + temp_output_54_0 ).rg );
				float smoothstepResult13 = smoothstep( ( 1.0 - _soft ) , _soft , saturate( ( ( tex2DNode5.r + 1.0 ) - ( texCoord116.w * 2.0 ) ) ));
				float temp_output_27_0 = step( texCoord116.w , tex2DNode5.r );
				#ifdef _SOFTORHARD_ON
				float staticSwitch66 = temp_output_27_0;
				#else
				float staticSwitch66 = smoothstepResult13;
				#endif
				float2 uv_Main_Tex = IN.ase_texcoord2.xy * _Main_Tex_ST.xy + _Main_Tex_ST.zw;
				float2 lerpResult108 = lerp( Polar135 , uv_Main_Tex , _NormalorPolar);
				float2 appendResult111 = (float2(_MainTilingOffset.x , _MainTilingOffset.y));
				float2 appendResult110 = (float2(texCoord116.x , texCoord116.y));
				float4 Noise132 = temp_output_54_0;
				float4 tex2DNode35 = tex2D( _Main_Tex, ( float4( (lerpResult108*appendResult111 + appendResult110), 0.0 , 0.0 ) + Noise132 ).rg );
				float2 uv_MaskTex = IN.ase_texcoord2.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float4 tex2DNode115 = tex2D( _MaskTex, uv_MaskTex );
				float temp_output_107_0 = ( staticSwitch66 * tex2DNode35.a * tex2DNode115.r * IN.ase_color.a );
				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth149 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth149 = abs( ( screenDepth149 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _SoftParticeMult ) );
				float temp_output_152_0 = saturate( distanceDepth149 );
				float lerpResult155 = lerp( temp_output_107_0 , ( temp_output_152_0 * temp_output_107_0 ) , _Float1);
				
				float Alpha = lerpResult155;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

	
	}
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=18800
354;147;1920;896;1346.531;725.4681;1.879487;True;True
Node;AmplifyShaderEditor.CommentaryNode;134;-5706.502,-1213.92;Inherit;False;1605.175;655.3245;Polar;8;78;79;80;84;85;86;81;88;;0.8537736,1,0.8583387,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;78;-5656.502,-1163.92;Inherit;False;0;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;79;-5360.114,-1139.185;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;80;-5188.429,-1124.821;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT;2;False;2;FLOAT;-1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;84;-5065.344,-821.2344;Inherit;True;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ATan2OpNode;85;-4821.349,-815.9841;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LengthOpNode;81;-4650.858,-1116.447;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;86;-4579.779,-812.5953;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;3.141593;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-4336.327,-993.096;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;135;-4000.907,-1133.983;Inherit;False;Polar;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;-3649.618,-532.868;Inherit;False;135;Polar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;97;-3634.157,118.2596;Inherit;False;Property;_NoiseTilingOffset;NoiseTilingOffset;17;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;50;-3781.784,-254.2665;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;95;-3863.444,-409.419;Inherit;False;Property;_NormalorPolar;Normal or Polar;26;1;[Enum];Create;True;0;2;Polar;0;Normal;1;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-3172.887,384.0402;Inherit;False;Property;_Nosie_Vspeed;Nosie_Vspeed;19;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;99;-3335.011,239.7108;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;98;-3330.763,134.1231;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-3149.108,298.4554;Inherit;False;Property;_Noise_Uspeed;Noise_Uspeed;18;0;Create;True;0;0;0;False;0;False;0;0.28;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;102;-3323.49,-230.4087;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector4Node;90;-3269.125,-489.6071;Inherit;False;Property;_DissTilingOffset;DissTilingOffset;9;0;Create;True;0;0;0;False;0;False;1,1,0,0;2,2,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScaleAndOffsetNode;100;-3070.271,53.79584;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;2,0;False;2;FLOAT2;-1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;93;-3365.808,-700.9686;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;138;-3613.64,-798.8012;Inherit;False;135;Polar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;53;-2929.067,316.2605;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;91;-3022.402,-513.9924;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;94;-2978.383,-732.3922;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;49;-2800.287,244.379;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-2744.961,-348.98;Inherit;False;Property;_Diss_Uspeed;Diss_Uspeed;10;0;Create;True;0;0;0;False;0;False;0;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-2740.001,-255.9398;Inherit;False;Property;_Diss_Vspeed;Diss_Vspeed;11;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;92;-3010.402,-382.9924;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;59;-2501.675,-322.2005;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;89;-2541.282,-586.2231;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;2,0;False;2;FLOAT2;-1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;48;-2592.581,-55.88287;Inherit;True;Property;_Noise_Tex;Noise_Tex;16;0;Create;True;0;0;0;False;0;False;-1;None;cb03664a3c287784aac8804b5ded0e32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;116;-2179.449,-775.8719;Inherit;False;1;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;55;-2473.757,278.5641;Inherit;False;Property;_Noise_Power;Noise_Power;20;0;Create;True;0;0;0;False;0;False;0;-0.45;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;54;-2276.234,-90.58321;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;60;-2264.772,-412.8535;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-2084.186,-379.8214;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1680.994,-41.33835;Inherit;False;Constant;_Float2;Float 2;1;0;Create;True;0;0;0;False;0;False;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1579.812,-364.9998;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1874.066,-416.2919;Inherit;True;Property;_Dissolve_Tex;Dissolve_Tex;8;0;Create;True;0;0;0;False;0;False;-1;None;cb03664a3c287784aac8804b5ded0e32;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1401.222,-119.3047;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;109;-1765.28,-956.6002;Inherit;False;Property;_MainTilingOffset;MainTilingOffset;7;0;Create;True;0;0;0;False;0;False;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;6;-1426.498,-494.6206;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;136;-2733.581,-1255.194;Inherit;False;135;Polar;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;62;-2727.252,-1111.715;Inherit;False;0;35;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;132;-1985.91,51.79565;Inherit;False;Noise;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-934.6855,-376.7404;Inherit;False;Property;_soft;soft;14;0;Create;True;0;0;0;False;0;False;1;0.5;0.5;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;11;-1215.95,-466.0393;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;-1506.882,-866.5898;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;108;-2347.096,-1171.832;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;110;-1500.149,-750.4539;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;145;-145.2242,181.8274;Inherit;False;2;-1;4;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;12;-874.4232,-500.4802;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;129;288.6016,305.616;Inherit;False;Property;_VexUspeed;VexUspeed;23;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;146;122.7759,168.8274;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;124;63.84935,17.99113;Inherit;False;0;128;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;123;294.6016,401.616;Inherit;False;Property;_VexVspeed;VexVspeed;24;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;112;-1270.368,-883.2206;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;2,0;False;2;FLOAT2;-1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;15;-646.3661,-442.3613;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-1353.23,-1098.98;Inherit;False;132;Noise;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;142;341.6944,61.47465;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;150;889.2963,-890.1119;Inherit;False;Property;_SoftParticeMult;SoftParticeMult;30;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;117;-1109.885,-1121.31;Inherit;True;2;2;0;FLOAT2;0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;27;-955.092,-257.941;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;125;491.6016,331.616;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;13;-449.354,-485.3231;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-797.9921,-1125.666;Inherit;True;Property;_Main_Tex;Main_Tex;5;0;Create;True;0;0;0;False;0;False;-1;None;40c95d644c62a24428aafd341b608925;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StaticSwitch;66;-73.94846,-486.6599;Inherit;False;Property;_Keyword0;Keyword 0;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;34;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;41;-413.7712,-685.2293;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;126;587.0134,107.9392;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DepthFade;149;1062.843,-989.124;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;719.0071,-213.8664;Inherit;True;Property;_MaskTex;MaskTex;27;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;148;970.2277,315.6127;Inherit;False;Property;_VertexShapen;Vertex Shapen;29;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;152;1341.134,-910.7682;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;128;810.888,69.13229;Inherit;True;Property;_Vertex;Vertex;21;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;107;1081.02,-431.6762;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;140;1459.161,524.564;Inherit;False;Property;_Vertex_XYZ;Vertex_XYZ;28;0;Create;True;0;0;0;False;0;False;0,0,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;154;1425.645,-646.8827;Inherit;False;Property;_Float1;软粒子开关;31;1;[Enum];Create;False;0;2;OFF;0;ON;1;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;156;1486.615,-300.1134;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;141;1453.539,315.1519;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;127;1135.948,-270.1238;Inherit;False;Property;_VertexScale;VertexScale;22;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;147;1217.228,124.6127;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;33;152.6435,-673.4343;Inherit;False;Property;_Eded_Color;Eded_Color;12;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0.03293999,0.6104217,1.396656,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;69;-378.5058,-1003.163;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;34;-63.87638,-370.9522;Inherit;False;Property;_SoftorHard;Soft or Hard;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;30;-589.6464,-61.40568;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-360.9924,-259.5306;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-2757.031,-1518.395;Inherit;False;Property;_CullMode;CullMode;4;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.CullMode;True;0;False;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;68;-582.8216,-926.2468;Inherit;False;Property;_RGBorR;RGB or R;25;1;[Enum];Create;True;0;2;RGB;0;R;1;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;29;-1222.396,52.8699;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;121;-2634.696,-1650.282;Inherit;False;Property;_Zwrite;Zwrite;0;1;[Enum];Create;True;0;2;OFF;0;ON;1;0;True;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;76;774.7145,-749.2601;Inherit;False;Property;_Keyword0;Keyword 0;15;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;34;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1441.12,113.9519;Inherit;False;Property;_Edeg;Edeg;13;0;Create;True;0;0;0;False;0;False;0.15;0.15;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;120;-2418.283,-1633.293;Inherit;False;Property;_Ztest;Ztest;1;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.CompareFunction;True;0;False;4;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;1740.914,-39.44867;Inherit;True;6;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;1518.432,-782.8336;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;153;1670.48,-688.2062;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;478.217,-607.0963;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-2305.663,-1430.805;Inherit;False;Property;_BlendDst;BlendDst;3;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;119;-2519.243,-1446.068;Inherit;False;Property;_BlendScr;BlendScr;2;1;[Enum];Create;True;0;1;Option1;0;1;UnityEngine.Rendering.BlendMode;True;0;False;5;5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;147.2087,-891.9501;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;28;-892.0321,-8.997456;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;155;1708.615,-399.1134;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-406.4088,-877.7344;Inherit;False;Property;_Mani_Color;Mani_Color;6;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;1.135301,1.135301,1.135301,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-161.2,-74.10001;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;2;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;4;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;1;2119.078,-596.2148;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;Lolmingmmmm/Dissolve_m01;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;True;118;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;0;0;True;1;5;True;119;10;True;122;0;1;False;119;10;False;120;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;True;121;True;3;True;120;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;Hidden/InternalErrorShader;0;0;Standard;22;Surface;1;  Blend;0;Two Sided;1;Cast Shadows;0;  Use Shadow Threshold;0;Receive Shadows;0;GPU Instancing;0;LOD CrossFade;0;Built-in Fog;0;DOTS Instancing;0;Meta Pass;0;Extra Pre Pass;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;5;False;True;False;True;False;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;3;0,0;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;3;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;79;0;78;1
WireConnection;79;1;78;2
WireConnection;80;0;79;0
WireConnection;84;0;80;0
WireConnection;85;0;84;1
WireConnection;85;1;84;0
WireConnection;81;0;80;0
WireConnection;86;0;85;0
WireConnection;88;0;81;0
WireConnection;88;1;86;0
WireConnection;135;0;88;0
WireConnection;99;0;97;3
WireConnection;99;1;97;4
WireConnection;98;0;97;1
WireConnection;98;1;97;2
WireConnection;102;0;139;0
WireConnection;102;1;50;0
WireConnection;102;2;95;0
WireConnection;100;0;102;0
WireConnection;100;1;98;0
WireConnection;100;2;99;0
WireConnection;53;0;51;0
WireConnection;53;1;52;0
WireConnection;91;0;90;1
WireConnection;91;1;90;2
WireConnection;94;0;138;0
WireConnection;94;1;93;0
WireConnection;94;2;95;0
WireConnection;49;0;100;0
WireConnection;49;2;53;0
WireConnection;92;0;90;3
WireConnection;92;1;90;4
WireConnection;59;0;58;0
WireConnection;59;1;56;0
WireConnection;89;0;94;0
WireConnection;89;1;91;0
WireConnection;89;2;92;0
WireConnection;48;1;49;0
WireConnection;54;0;48;0
WireConnection;54;1;116;3
WireConnection;54;2;55;0
WireConnection;60;0;89;0
WireConnection;60;2;59;0
WireConnection;61;0;60;0
WireConnection;61;1;54;0
WireConnection;5;1;61;0
WireConnection;9;0;116;4
WireConnection;9;1;10;0
WireConnection;6;0;5;1
WireConnection;6;1;7;0
WireConnection;132;0;54;0
WireConnection;11;0;6;0
WireConnection;11;1;9;0
WireConnection;111;0;109;1
WireConnection;111;1;109;2
WireConnection;108;0;136;0
WireConnection;108;1;62;0
WireConnection;108;2;95;0
WireConnection;110;0;116;1
WireConnection;110;1;116;2
WireConnection;12;0;11;0
WireConnection;146;0;145;1
WireConnection;146;1;145;2
WireConnection;112;0;108;0
WireConnection;112;1;111;0
WireConnection;112;2;110;0
WireConnection;15;0;14;0
WireConnection;142;0;124;0
WireConnection;142;2;146;0
WireConnection;117;0;112;0
WireConnection;117;1;133;0
WireConnection;27;0;116;4
WireConnection;27;1;5;1
WireConnection;125;0;129;0
WireConnection;125;1;123;0
WireConnection;13;0;12;0
WireConnection;13;1;15;0
WireConnection;13;2;14;0
WireConnection;35;1;117;0
WireConnection;66;1;13;0
WireConnection;66;0;27;0
WireConnection;126;0;142;0
WireConnection;126;2;125;0
WireConnection;149;0;150;0
WireConnection;152;0;149;0
WireConnection;128;1;126;0
WireConnection;107;0;66;0
WireConnection;107;1;35;4
WireConnection;107;2;115;1
WireConnection;107;3;41;4
WireConnection;156;0;152;0
WireConnection;156;1;107;0
WireConnection;147;0;128;1
WireConnection;147;1;148;0
WireConnection;69;0;35;0
WireConnection;69;1;35;1
WireConnection;69;2;68;0
WireConnection;34;1;13;0
WireConnection;34;0;31;0
WireConnection;30;0;27;0
WireConnection;30;1;28;0
WireConnection;31;0;27;0
WireConnection;31;1;30;0
WireConnection;29;0;116;4
WireConnection;29;1;19;0
WireConnection;76;1;38;0
WireConnection;76;0;72;0
WireConnection;130;0;127;0
WireConnection;130;1;147;0
WireConnection;130;2;141;0
WireConnection;130;3;140;0
WireConnection;130;4;115;1
WireConnection;130;5;145;3
WireConnection;151;0;152;0
WireConnection;151;1;76;0
WireConnection;153;0;76;0
WireConnection;153;1;151;0
WireConnection;153;2;154;0
WireConnection;72;0;38;0
WireConnection;72;1;33;0
WireConnection;72;2;30;0
WireConnection;38;0;69;0
WireConnection;38;1;39;0
WireConnection;38;2;41;0
WireConnection;38;3;34;0
WireConnection;28;0;29;0
WireConnection;28;1;5;1
WireConnection;155;0;107;0
WireConnection;155;1;156;0
WireConnection;155;2;154;0
WireConnection;1;2;153;0
WireConnection;1;3;155;0
WireConnection;1;5;130;0
ASEEND*/
//CHKSM=09BE4D1A5C9952B0B5EFC4E8005E376BD860245B