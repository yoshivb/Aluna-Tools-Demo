#---FRAGMENT---#
#ifdef ALPHATEST
in vec4 VSOutTEXCOORD0; // name: OutTexCoord0
uniform sampler2D tex0; // name: tex0
uniform float materialProperties[32];
#endif
	
uniform int SelectionID;
out vec4 FragmentColor0; // name: FragmentColor

void main()
{
	if(texture(tex0, VSOutTEXCOORD0.xy).a < 0.3) discard;			#only:ALPHATEST

#if GLSL_VERSION >= 400
	FragmentColor0 = unpackUnorm4x8(SelectionID);	
#else
	// manual unpackUnorm4x8
	uint selectionUint = uint(SelectionID);
	FragmentColor0.r = float(selectionUint & uint(255)) / 255.0 ;	
	FragmentColor0.g = float((selectionUint >> uint(8) ) & uint(255)) / 255.0;
	FragmentColor0.b = float((selectionUint >> uint(16) ) & uint(255)) / 255.0;
	FragmentColor0.a = float((selectionUint >> uint(24) ) & uint(255)) / 255.0;
#endif
};

#---VERTEX---#
#include "shaders/template_perframe.glinc"

uniform mat4 world;
uniform mat4 skinmatrix[100];																		#only:SKINNING
#define worldSkin (worldSkinMat)																	#only:SKINNING
#define worldSkin (world)																			#only:~SKINNING
#define worldMatrix (worldSkin)																		#only:~INSTANCED
#define skinMatrix skinmatrix

in vec3 POSITION; // name: Pos
in vec4 TEXCOORD0; // name: TexCoord0				
in vec4 BLENDINDICES; // name: BlendIndices															#only:SKINNING
in vec4 BLENDWEIGHT; // name: BlendWeight															#only:SKINNING
in mat4 INSTANCED0; // name: InstanceWorld															#only:INSTANCED
out vec4 VSOutTEXCOORD0; // name: OutTexCoord0				
out vec3 VSOutTEXCOORD1; // name: OutWorldPosition				

void main()
{
	VSOutTEXCOORD0 = TEXCOORD0;

	mat4 skinMat =	(skinMatrix[int(BLENDINDICES.x)] * BLENDWEIGHT.x) + (skinMatrix[int(BLENDINDICES.y)] * BLENDWEIGHT.y) + #only:SKINNING
					(skinMatrix[int(BLENDINDICES.z)] * BLENDWEIGHT.z) + (skinMatrix[int(BLENDINDICES.w)] * BLENDWEIGHT.w);	#only:SKINNING
	mat4 worldSkinMat = world * skinMat;																					#only:SKINNING

	mat4 worldMatrix = (INSTANCED0 * worldSkin); 													#only:INSTANCED
	
	gl_Position = projectionView * (worldMatrix * vec4(POSITION, 1.0));								#only:~SKYBOX
#ifdef SKYBOX
	mat4 viewNoTranslation = view; viewNoTranslation[3] = vec4(0.0, 0.0, 0.0, 1.0);
	gl_Position = projection * viewNoTranslation * worldMatrix * vec4(POSITION, 1.0);	
#endif

	VSOutTEXCOORD1 = (worldMatrix * vec4(POSITION, 1.0)).xyz;
};
