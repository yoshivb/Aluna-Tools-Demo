#---FRAGMENT---#
#include "shaders/template_perframe.glinc"
#include "shaders/template_matrixhelpers.glinc"
#include "shaders/template_noise.glinc"						#only:TERRAIN
#include "shaders/template_lighting_fs.glinc"				#only:LIT

uniform sampler2D tex0; // name: texDiffuse
uniform sampler2D tex1; // name: texTangentNormal			#only:HAS_TNORMALMAP
uniform sampler2D tex1; // name: texWorldNormal				#only:HAS_WNORMALMAP
uniform sampler2D tex2; // name: texEmissive				#only:HAS_EMISSIVEMAP
uniform sampler2D tex3; // name: texSpecular				#only:HAS_SPECULAR
uniform samplerCube tex8; // name: texCube0					#only:HAS_ENVIRONMENTMAP
uniform sampler2DArray tex6;								#only:TERRAIN

uniform mat4 world;											#only:HAS_WNORMALMAP

in vec4 VSOutTEXCOORD0; // name: OutTexCoord0
in vec3 VSOutTEXCOORD1; // name: OutWorldPosition
in vec3 VSOutTEXCOORD2; // name: OutNormal					#only:~HAS_WNORMALMAP
in vec3 VSOutTEXCOORD3; // name: OutTangent					#only:HAS_TNORMALMAP
in vec3 VSOutTEXCOORD4; // name: OutBitangent				#only:HAS_TNORMALMAP

out vec4 FragmentColor0; // name: FragmentColor
out vec4 FragmentColor1; // name: FragmentColor1			#only:DEFERRED
out vec4 FragmentColor2; // name: FragmentColor2			#only:DEFERRED

uniform vec4 specularSettings;								
uniform vec4 fillColor;										#only:FILLCOLOR
uniform vec4 alphaSettings;									#only:ALPHATEST
uniform vec4 environmentSettings;							#only:HAS_ENVIRONMENTMAP
uniform vec4 albedoColor;									#only:COLOR_ALBEDO

void main()
{
#ifdef TERRAIN
	float noiseval=snoise(VSOutTEXCOORD0.xy*256.0)*0.5+0.5;
	float grassIndex =(noiseval*2.0)-0.51;
	float grassIndexFrac=fract(grassIndex+0.4999);
	
	vec3 blendgrass=texture(tex6, vec3(VSOutTEXCOORD0.xy*128.0, grassIndex)).xyz*(1.0-grassIndexFrac)+texture(tex6, vec3(VSOutTEXCOORD0.xy*128.0, grassIndex+1.0)).xyz*(grassIndexFrac);
	//vec3 blendgrass=texture(tex6, vec3(VSOutTEXCOORD0.xy*128.0, 0.0)).xyz;
	//vec3 blendgrass=vec3(noiseval,noiseval,noiseval);
	
	float slope = 1.0-VSOutTEXCOORD2.z;
	slope = saturate(pow(slope, 0.3)*1.5-0.2);
	FragmentColor0.xyz =  (blendgrass * (1.0-slope)) +
						  (texture(tex6, vec3(VSOutTEXCOORD0.xy*48.0, 3.0)).xyz * slope);
	FragmentColor0.w = 1.0;
	FragmentColor1.xyz = (VSOutTEXCOORD2.xyz + 1.0) * 0.5;											#only:DEFERRED
	return;
#endif

#ifdef HAS_TNORMALMAP
	vec4 normalSample = texture(tex1, VSOutTEXCOORD0.xy);
	vec3 tangentSpaceNormal = ( normalSample.xyz - 0.5) * 2.0;

	// HLSL: mat3 tangentToWorldMatrix = {VSOutTEXCOORD3, VSOutTEXCOORD4, VSOutTEXCOORD2};
	// HLSL: vec3 normal = mul( tangentSpaceNormal, tangentToWorldMatrix);	
	mat3 tangentToWorldMatrix = mat3(VSOutTEXCOORD3, VSOutTEXCOORD4, VSOutTEXCOORD2);
	vec3 normal = ( tangentToWorldMatrix* tangentSpaceNormal);
#else 
	vec3 normal = (world * vec4(texture(tex1, VSOutTEXCOORD0.xy).xyz * 2.0 - 1.0, 0.0)).xyz;		#only:HAS_WNORMALMAP
	vec3 normal = VSOutTEXCOORD2;																	#only:~HAS_WNORMALMAP
#endif

	vec4 albedo=texture(tex0, VSOutTEXCOORD0.xy);
	albedo *= albedoColor;																			#only:COLOR_ALBEDO
	
	// specular factor
	float specular = specularSettings.z;
	specular=texture(tex3, VSOutTEXCOORD0.xy).r*specularSettings.z;								   	#only:HAS_SPECULAR
	specular=albedo.w*specularSettings.z; albedo.w = 1.0;								    		#only:HAS_SPECULAR_IN_DIFFUSE_ALPHA

#ifdef LIT
	FragmentColor0 = vec4(CalculateForwardLighting(albedo, normal, VSOutTEXCOORD1, specularSettings.x, specular), albedo.w);
#else 
	FragmentColor0 = texture(tex0, VSOutTEXCOORD0.xy);												#only:~FILLCOLOR
#endif
	FragmentColor0 = fillColor;																		#only:FILLCOLOR

	
#ifdef HAS_ENVIRONMENTMAP
	vec3 viewDir = normalize(GetTranslation(inverseView)-VSOutTEXCOORD1);
	FragmentColor0.xyz += texture(tex8, -reflect(viewDir,normal).xzy).xyz * environmentSettings.x * saturate(1.0-abs(dot(viewDir,normal))*environmentSettings.y);
#endif		

	if(FragmentColor0.a < alphaSettings.x) { discard; } else { FragmentColor0.a = 1.0; }			#only:ALPHATEST

#ifdef TEST_MIPMAP
    vec3 colors[] = vec3[](vec3(1.0, 0.0, 0.0), vec3(0.0, 1.0, 0.0), vec3(0.0, 0.0, 1.0), vec3(1.0, 0.0, 1.0), vec3(1.0, 1.0, 0.0), vec3(0.0, 1.0, 1.0), vec3(1.0, 0.5, 0.0), vec3(0.0, 0.5, 1.0) );
	vec2 lod=textureQueryLod(tex0, VSOutTEXCOORD0.xy);
	int lodlevel = int(floor(lod.x));
	FragmentColor0.xyz *= mix(colors[lodlevel], colors[lodlevel+1], fract(lod.x));
#endif
	
#ifdef DEFERRED
	FragmentColor1.xyz = (normal.xyz + 1.0) * 0.5;
	FragmentColor1.w = 0.0;
	FragmentColor2.x = specularSettings.x;
	FragmentColor2.y = specular;
	
	FragmentColor0.a = 1.0;
	return;
#endif

	FragmentColor0 += texture(tex2, VSOutTEXCOORD0.xy);												#only:HAS_EMISSIVEMAP

	// ensure no negative diffuse gets through - workaround for weird forward rendering issues!
	FragmentColor0 = max(FragmentColor0, vec4(0.0));
};

#---VERTEX---#
#include "shaders/template_perframe.glinc"

uniform mat4 world;
uniform mat4 skinmatrix[100];																		#only:SKINNING
uniform mat4 instworld[32];																			#only:INSTANCED_UBO
#define worldSkin (worldSkinMat)																	#only:SKINNING
#define worldSkin (world)																			#only:~SKINNING
#define worldMatrix (worldSkin)																		#only:~INSTANCED
#define skinMatrix skinmatrix

// in variables
in vec3 POSITION; // name: Pos
in vec4 TEXCOORD0; // name: TexCoord0
in vec3 NORMAL; // name: Normal																		#only:~HAS_WNORMALMAP
in vec3 TANGENT; // name: Tangent																	#only:HAS_TNORMALMAP
in vec3 BITANGENT; // name: Bitangent																#only:HAS_TNORMALMAP
in vec4 BLENDINDICES; // name: BlendIndices															#only:SKINNING
in vec4 BLENDWEIGHT; // name: BlendWeight															#only:SKINNING
in mat4 RESERVED1; // name: InstanceWorld															#only:INSTANCED_VB
				
// out variables				
out vec4 VSOutTEXCOORD0; // name: OutTexCoord0				
out vec3 VSOutTEXCOORD1; // name: OutWorldPosition				
out vec3 VSOutTEXCOORD2; // name: OutNormal															#only:~HAS_WNORMALMAP
out vec3 VSOutTEXCOORD3; // name: OutTangent														#only:HAS_TNORMALMAP
out vec3 VSOutTEXCOORD4; // name: OutBitangent														#only:HAS_TNORMALMAP

void main()
{
	VSOutTEXCOORD0 = TEXCOORD0;

	mat4 skinMat =	(skinMatrix[int(BLENDINDICES.x)] * BLENDWEIGHT.x) + (skinMatrix[int(BLENDINDICES.y)] * BLENDWEIGHT.y) + #only:SKINNING
					(skinMatrix[int(BLENDINDICES.z)] * BLENDWEIGHT.z) + (skinMatrix[int(BLENDINDICES.w)] * BLENDWEIGHT.w);	#only:SKINNING
	mat4 worldSkinMat = world * skinMat;																					#only:SKINNING

	mat4 worldMatrix = (RESERVED1 * worldSkin); 													#only:INSTANCED_VB
	mat4 worldMatrix = (instworld[gl_InstanceID] * worldSkin); 										#only:INSTANCED_UBO
	
	gl_Position = projectionView * (worldMatrix * vec4(POSITION, 1.0));								#only:~SKYBOX
#ifdef SKYBOX
	mat4 viewNoTranslation = view; viewNoTranslation[3] = vec4(0.0, 0.0, 0.0, 1.0);
	gl_Position = projection * viewNoTranslation * worldMatrix * vec4(POSITION, 1.0);	
#endif

	VSOutTEXCOORD1 = (worldMatrix * vec4(POSITION, 1.0)).xyz;
	VSOutTEXCOORD2 = normalize((worldMatrix * vec4(NORMAL, 0.0)).xyz);								#only:~HAS_WNORMALMAP
	VSOutTEXCOORD3 = normalize((worldMatrix * vec4(TANGENT,0.0)).xyz);								#only:HAS_TNORMALMAP
	VSOutTEXCOORD4 = normalize((worldMatrix * vec4(BITANGENT,0.0)).xyz);							#only:HAS_TNORMALMAP
};
