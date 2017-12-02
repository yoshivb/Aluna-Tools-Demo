#---FRAGMENT---#
#define LIGHTING_SPOT

uniform vec4 position;   				// .w = range
uniform vec4 direction;  				// .w = spotFalloff
uniform vec4 color;	   					// .w = spotCosConeAngle
uniform vec4 shadowInfo; 				// .x = width, .y = height, .z = bias
uniform mat4 shadowMatrix;
uniform sampler2D tex0; 				// name: texDiffuse
uniform sampler2D tex1; 				// name: texNormal
uniform sampler2D tex2; 				// name: texDepth
uniform sampler2DShadow tex3; 			// name: texShadow						#only:SHADOWED	

#include "shaders/template_perframe.glinc"
#include "shaders/template_deferred.glinc"
#include "shaders/template_lighting_fs.glinc"

out vec4 FragmentColor0; 				// name: FragmentColor

void main()
{ 
	vec2 OutUv = gl_FragCoord.xy / screenSize;
	vec3 PixelPos = VSPositionFromDepth(OutUv.xy);
	vec4 Albedo = texture(tex0, OutUv.xy);
	vec3 Normal = texture(tex1, OutUv.xy).xyz * 2.0 - 1.0;

	vec3 normalizedViewVec = CalculateNormalizedViewVec(PixelPos);
	
	// (const vec4 position, const vec3 direction, const vec3 color, const vec3 normal, const vec3 worldPosition, const vec4 albedo, const vec3 normalizedViewVec, float specPower, float specIntensity, float coneCosAngle, float coneFalloff)
	FragmentColor0.xyz = CalculateDiffuseSpecLightSpot(position, -direction.xyz, color.xyz, Normal, PixelPos, Albedo, normalizedViewVec, 7.0, 0.15, color.w, direction.w);
	
	FragmentColor0.w = 1.0;
	
#ifdef SHADOWED	
	vec4 projectedShadowCoord = (shadowMatrix * vec4(PixelPos, 1.0));
	projectedShadowCoord /= projectedShadowCoord.w; // perspective divide
	
	if(projectedShadowCoord.x > 0 && projectedShadowCoord.x < 1 && projectedShadowCoord.y > 0 && projectedShadowCoord.y < 1 && projectedShadowCoord.z > 0.0 && projectedShadowCoord.z < 1.0)
	{
		float vx = projectedShadowCoord.y;
		projectedShadowCoord.y = 1.0-projectedShadowCoord.x; 
		projectedShadowCoord.x = vx;
		float z = (texture(tex3, projectedShadowCoord.xyz) >= projectedShadowCoord.z)?1.0:0.0;
		//float z = PCF(projectedShadowCoord, shadowInfo.x, shadowInfo.z);
		FragmentColor0.xyz *= z ;
	}
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

