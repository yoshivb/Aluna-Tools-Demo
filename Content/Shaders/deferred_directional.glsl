#---FRAGMENT---#
uniform vec4 direction;
uniform vec4 color;
uniform sampler2D tex0; 		// name: texDiffuse
uniform sampler2D tex1; 		// name: texNormal
uniform sampler2D tex2; 		// name: texDepth

#include "shaders/template_perframe.glinc"
#include "shaders/template_deferred.glinc"
#include "shaders/template_lighting_fs.glinc"

out vec4 FragmentColor0; 		// name: FragmentColor

void main()
{
	vec2 OutUv = gl_FragCoord.xy / screenSize;
	
	vec3 PixelPos = VSPositionFromDepth(OutUv.xy);
	vec3 Albedo = texture(tex0, OutUv.xy).xyz;
	vec3 Normal = texture(tex1, OutUv.xy).xyz * 2.0 - 1.0;

	vec3 normalizedViewVec = CalculateNormalizedViewVec(PixelPos);
	// (const vec3 direction, const vec3 color, const vec3 normal, const vec4 albedo, const vec3 normalizedViewVec, float specPower, float specIntensity)
	FragmentColor0.xyz = CalculateDiffuseSpecLightDirectional(-direction.xyz, color.xyz, Normal, vec4(Albedo, 1.0), normalizedViewVec, 7.0, 0.15);
	FragmentColor0.w = 1.0;
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
