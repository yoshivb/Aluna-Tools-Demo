#---FRAGMENT---#
#define LIGHTING_POINT
#define SHADOW_FAST
//#define SHADOW_FIXED_SAMPLES
//#define SHADOW_RANDOM_STRATIFIED
#define SHADOW_RANDOM_SAMPLES 4
uniform vec4 positionRange;
uniform vec4 color;
uniform sampler2D tex0; // name: texDiffuse
uniform sampler2D tex1; // name: texNormal
uniform sampler2D tex2; // name: texDepth
uniform sampler2D tex3; // name: texSettings
uniform samplerCubeShadow tex4; // name: texCubeShadow				#only: SHADOWED
uniform samplerCubeShadow tex5; // name: texCubeShadowDynamic		#only: SHADOWED

float rand(vec2 co) { return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453); }

#include "shaders/template_noise.glinc"
#include "shaders/template_perframe.glinc"
#include "shaders/template_deferred.glinc"
#include "shaders/template_lighting_fs.glinc"

out vec4 FragmentColor0; // name: FragmentColor

void main()
{
	vec2 OutUv = 		gl_FragCoord.xy / screenSize;
	vec3 PixelPos = 	VSPositionFromDepth(OutUv.xy);
	vec4 Albedo = 		texture(tex0, OutUv.xy);
	vec3 Normal = 		normalize(texture(tex1, OutUv.xy).xyz * 2.0 - 1.0); 
	vec4 Settings =		texture(tex3, OutUv.xy);
	
#ifdef SHADOWED
#ifdef SHADOW_FAST
	vec3 vLight  			= (PixelPos - positionRange.xyz);	
	vec4 shadowUv 	 		= vec4(vLight.xzy * vec3(1.0,-1.0,1.0), VectorToDepthValue(vLight * 0.97));
	float depth 			= texture(tex4, shadowUv);
	float depthDynamic 		= texture(tex5, shadowUv);
	float finalDepth  		= depth * depthDynamic ; // 
#endif
#ifdef SHADOW_RANDOM_STRATIFIED
	vec3 vLight  			= (PixelPos - positionRange.xyz);	
	float vLightLen 		= length(vLight);
	vLight /= vLightLen;
	float olat = atan(vLight.z, length(vLight.xy));
	float olon = atan(vLight.y, vLight.x);
	
	float finalDepth = 0.0f;
	for(int i=0; i<SHADOW_RANDOM_SAMPLES; i++)
	{
		float sampWidth = mix(0.01, 0.15,vLightLen/10.0);
		float offx=(rand(PixelPos.xy*1000.0 + vec2(0.0+ i*1000.0, i*1000.0))-0.5) *sampWidth;
		float offy=(rand(PixelPos.xy*1000.0 + vec2(1000.0 + i*1000.0, i*1000.0))-0.5) * sampWidth;
		//float offx=0.0;
		//float offy=0.0;
		float lat = olat + offx;
		float lon = olon + offy;
		vLight = vec3(cos(lat) * cos(lon), cos(lat)*sin(lon), sin(lat));
		vec4 shadowUv 	 		= vec4(vLight.xzy * vec3(1.0,-1.0,1.0), VectorToDepthValue(vLight*vLightLen * 0.950));
		
		float depth 			= texture(tex4, shadowUv);
		float depthDynamic 		= texture(tex5, shadowUv);
		float finalDepthCurrent = depth * depthDynamic ;
		finalDepth += finalDepthCurrent;
	}
	finalDepth /=  SHADOW_RANDOM_SAMPLES;
#endif
#ifdef SHADOW_FIXED_SAMPLES
	vec3 vLight  			= (PixelPos - positionRange.xyz);	
	float vLightLen 		= length(vLight);
	vLight /= vLightLen;
	float olat = atan(vLight.z, length(vLight.xy));
	float olon = atan(vLight.y, vLight.x);
	
	float finalDepth = 0.0f;
	vec2 offsets[3];
	offsets[0] = vec2(0.00, 0.00);
	offsets[1] = vec2(0.01, -0.01);
	offsets[2] = vec2(-0.01, 0.01);
	for(int i=0; i<3; i++)
	{
		float sampWidth = 0.4;
		float lat = olat + offsets[i].x * sampWidth;
		float lon = olon + offsets[i].y * sampWidth;
		vLight = vec3(cos(lat) * cos(lon), cos(lat)*sin(lon), sin(lat));
		vec4 shadowUv 	 		= vec4(vLight.xzy * vec3(1.0,-1.0,1.0), VectorToDepthValue(vLight*vLightLen * 0.990));
		
		float depth 			= texture(tex4, shadowUv);
		float depthDynamic 		= texture(tex5, shadowUv);
		float finalDepthCurrent = depth *depthDynamic ;
		finalDepth += finalDepthCurrent;
	}
	finalDepth /= 3.0f;
#endif

	
	vec3 normalizedViewVec = CalculateNormalizedViewVec(PixelPos);
	FragmentColor0.xyz = CalculateDiffuseSpecLight(positionRange, color.xyz, Normal, PixelPos, vec4(Albedo.xyz, 1.0), normalizedViewVec, max(1.0,Settings.x), Settings.y) * saturate(finalDepth + 0.1);
	FragmentColor0.w = Albedo.w;
#else

	vec3 normalizedViewVec = CalculateNormalizedViewVec(PixelPos);
	FragmentColor0.xyz = CalculateDiffuseSpecLight(positionRange, color.xyz, Normal, PixelPos, vec4(Albedo.xyz, 1.0), normalizedViewVec, max(1.0,Settings.x), Settings.y);
	FragmentColor0.w = Albedo.w;
#endif
}

#---VERTEX---#
#include "shaders/template_perframe.glinc"

in vec3 POSITION;
uniform mat4 world;															#only:GEOMETRY

void main()
{
	gl_Position = (projectionView*world)* vec4(POSITION, 1.0);				#only:GEOMETRY
	gl_Position = vec4(POSITION, 1.0);										#only:FSQ
}

