// Shader created with Shader Forge v1.38 
// Shader Forge (c) Freya Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.38;sub:START;pass:START;ps:flbk:,iptp:0,cusa:False,bamd:0,cgin:,lico:1,lgpr:1,limd:0,spmd:1,trmd:0,grmd:0,uamb:True,mssp:True,bkdf:False,hqlp:False,rprd:False,enco:False,rmgx:True,imps:True,rpth:0,vtps:0,hqsc:True,nrmq:1,nrsp:0,vomd:0,spxs:False,tesm:0,olmd:1,culm:2,bsrc:3,bdst:7,dpts:2,wrdp:False,dith:0,atcv:False,rfrpo:True,rfrpn:Refraction,coma:15,ufog:False,aust:True,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,stcl:False,atwp:False,stva:128,stmr:255,stmw:255,stcp:6,stps:0,stfa:0,stfz:0,ofsf:0,ofsu:0,f2p0:False,fnsp:False,fnfb:False,fsmp:False;n:type:ShaderForge.SFN_Final,id:3138,x:32929,y:32965,varname:node_3138,prsc:2|emission-5147-RGB,alpha-5147-A;n:type:ShaderForge.SFN_Tex2d,id:5147,x:32588,y:33198,ptovrint:False,ptlb:Main,ptin:_Main,varname:node_5147,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:f719a4955a819994e8890713daef1419,ntxv:0,isnm:False|UVIN-6802-OUT;n:type:ShaderForge.SFN_TexCoord,id:3133,x:31977,y:32904,varname:node_3133,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_ComponentMask,id:9755,x:31883,y:33259,varname:node_9755,prsc:2,cc1:0,cc2:1,cc3:-1,cc4:-1|IN-6677-RGB;n:type:ShaderForge.SFN_Tex2d,id:6677,x:31663,y:33259,ptovrint:False,ptlb:FlowMap,ptin:_FlowMap,varname:node_6677,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:ddea8e8c950db3a4d847f9bfd6b239bb,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Lerp,id:6802,x:32344,y:33215,varname:node_6802,prsc:2|A-9555-OUT,B-9755-OUT,T-3757-OUT;n:type:ShaderForge.SFN_Tex2d,id:2909,x:31801,y:32790,ptovrint:False,ptlb:DisturbanceTex,ptin:_DisturbanceTex,varname:node_2909,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:cd237e5a231360641af6cc23cb18683d,ntxv:0,isnm:False|UVIN-321-OUT;n:type:ShaderForge.SFN_TexCoord,id:5639,x:31216,y:32778,varname:node_5639,prsc:2,uv:0,uaff:False;n:type:ShaderForge.SFN_Add,id:321,x:31628,y:32790,varname:node_321,prsc:2|A-5639-UVOUT,B-8908-OUT;n:type:ShaderForge.SFN_Time,id:8084,x:31010,y:32919,varname:node_8084,prsc:2;n:type:ShaderForge.SFN_Multiply,id:5576,x:31273,y:32935,varname:node_5576,prsc:2|A-8084-T,B-1439-OUT;n:type:ShaderForge.SFN_Multiply,id:6418,x:31273,y:33070,varname:node_6418,prsc:2|A-8084-T,B-4649-OUT;n:type:ShaderForge.SFN_ValueProperty,id:1439,x:31010,y:33075,ptovrint:False,ptlb:X_Speed,ptin:_X_Speed,varname:node_1439,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.3;n:type:ShaderForge.SFN_ValueProperty,id:4649,x:31010,y:33151,ptovrint:False,ptlb:Y_Speed,ptin:_Y_Speed,varname:node_4649,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.3;n:type:ShaderForge.SFN_Append,id:8908,x:31459,y:32907,varname:node_8908,prsc:2|A-5576-OUT,B-6418-OUT;n:type:ShaderForge.SFN_Add,id:9555,x:32188,y:33057,varname:node_9555,prsc:2|A-3133-UVOUT,B-2595-OUT;n:type:ShaderForge.SFN_Multiply,id:2595,x:31977,y:33057,varname:node_2595,prsc:2|A-2909-RGB,B-1520-OUT,C-4905-R;n:type:ShaderForge.SFN_ValueProperty,id:1520,x:31721,y:32967,ptovrint:False,ptlb:DisturbanceIntensity,ptin:_DisturbanceIntensity,varname:node_1520,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,v1:0.1;n:type:ShaderForge.SFN_Tex2d,id:4905,x:31735,y:33040,ptovrint:False,ptlb:DisturbanceMask,ptin:_DisturbanceMask,varname:node_4905,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,tex:bee0870f0a0699f429a597ce4c008fd5,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Slider,id:3757,x:32024,y:33427,ptovrint:False,ptlb:wMapPowerwer,ptin:_wMapPowerwer,varname:node_3757,prsc:2,glob:False,taghide:False,taghdr:False,tagprd:False,tagnsco:False,tagnrm:False,min:0,cur:0,max:1;proporder:5147-3757-6677-2909-1439-4649-1520-4905;pass:END;sub:END;*/

Shader "Shader Forge/FlowMap" {
    Properties {
        _Main ("Main", 2D) = "white" {}
        _wMapPowerwer ("wMapPowerwer", Range(0, 1)) = 0
        _FlowMap ("FlowMap", 2D) = "white" {}
        _DisturbanceTex ("DisturbanceTex", 2D) = "white" {}
        _X_Speed ("X_Speed", Float ) = 0.3
        _Y_Speed ("Y_Speed", Float ) = 0.3
        _DisturbanceIntensity ("DisturbanceIntensity", Float ) = 0.1
        _DisturbanceMask ("DisturbanceMask", 2D) = "white" {}
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "FORWARD"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            #pragma multi_compile_fwdbase
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            uniform sampler2D _Main; uniform float4 _Main_ST;
            uniform sampler2D _FlowMap; uniform float4 _FlowMap_ST;
            uniform sampler2D _DisturbanceTex; uniform float4 _DisturbanceTex_ST;
            uniform float _X_Speed;
            uniform float _Y_Speed;
            uniform float _DisturbanceIntensity;
            uniform sampler2D _DisturbanceMask; uniform float4 _DisturbanceMask_ST;
            uniform float _wMapPowerwer;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.pos = UnityObjectToClipPos( v.vertex );
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
////// Lighting:
////// Emissive:
                float4 node_8084 = _Time;
                float2 node_321 = (i.uv0+float2((node_8084.g*_X_Speed),(node_8084.g*_Y_Speed)));
                float4 _DisturbanceTex_var = tex2D(_DisturbanceTex,TRANSFORM_TEX(node_321, _DisturbanceTex));
                float4 _DisturbanceMask_var = tex2D(_DisturbanceMask,TRANSFORM_TEX(i.uv0, _DisturbanceMask));
                float4 _FlowMap_var = tex2D(_FlowMap,TRANSFORM_TEX(i.uv0, _FlowMap));
                float3 node_6802 = lerp((float3(i.uv0,0.0)+(_DisturbanceTex_var.rgb*_DisturbanceIntensity*_DisturbanceMask_var.r)),float3(_FlowMap_var.rgb.rg,0.0),_wMapPowerwer);
                float4 _Main_var = tex2D(_Main,TRANSFORM_TEX(node_6802, _Main));
                float3 emissive = _Main_var.rgb;
                float3 finalColor = emissive;
                return fixed4(finalColor,_Main_var.a);
            }
            ENDCG
        }
        Pass {
            Name "ShadowCaster"
            Tags {
                "LightMode"="ShadowCaster"
            }
            Offset 1, 1
            Cull Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_SHADOWCASTER
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #pragma fragmentoption ARB_precision_hint_fastest
            #pragma multi_compile_shadowcaster
            #pragma only_renderers d3d9 d3d11 glcore gles 
            #pragma target 3.0
            struct VertexInput {
                float4 vertex : POSITION;
            };
            struct VertexOutput {
                V2F_SHADOW_CASTER;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.pos = UnityObjectToClipPos( v.vertex );
                TRANSFER_SHADOW_CASTER(o)
                return o;
            }
            float4 frag(VertexOutput i, float facing : VFACE) : COLOR {
                float isFrontFace = ( facing >= 0 ? 1 : 0 );
                float faceSign = ( facing >= 0 ? 1 : -1 );
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
    CustomEditor "ShaderForgeMaterialInspector"
}
