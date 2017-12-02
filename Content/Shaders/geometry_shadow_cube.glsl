#---GEOMETRY---#
layout (triangles) in;
layout (triangle_strip, max_vertices=18) out;

uniform mat4 shadowMatrices[6];

in vec4 GSOutTEXCOORD0[]; // name: OutTexCoord0				
out vec4 VSOutTEXCOORD0;
out vec4 VSOutTEXCOORD1;

void main()
{
    for(int face = 0; face < 6; ++face)
    {
        gl_Layer = face;
        for(int i = 0; i < 3; ++i) // for each triangle's vertices
        {
			VSOutTEXCOORD0 = GSOutTEXCOORD0[i];
            VSOutTEXCOORD1 = gl_in[i].gl_Position;
            gl_Position = shadowMatrices[face] * gl_in[i].gl_Position;
            EmitVertex();
        }    
        EndPrimitive();
    }
}  

#---FRAGMENT---#
#ifdef ALPHATEST
in vec4 VSOutTEXCOORD0; // name: OutTexCoord0
uniform sampler2D tex0; // name: tex0
uniform float materialProperties[32];
#endif
out vec4 FragmentColor0; 

void main()
{
#ifdef ALPHATEST
	if(texture(tex0, VSOutTEXCOORD0.xy).a < 0.3)
		discard;
#endif

	FragmentColor0 = vec4(1.0,1.0,1.0,1.0);
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
out vec4 GSOutTEXCOORD0; // name: OutTexCoord0				

void main()
{
	GSOutTEXCOORD0 = TEXCOORD0;

	mat4 skinMat =	(skinMatrix[int(BLENDINDICES.x)] * BLENDWEIGHT.x) + (skinMatrix[int(BLENDINDICES.y)] * BLENDWEIGHT.y) + #only:SKINNING
					(skinMatrix[int(BLENDINDICES.z)] * BLENDWEIGHT.z) + (skinMatrix[int(BLENDINDICES.w)] * BLENDWEIGHT.w);	#only:SKINNING
	mat4 worldSkinMat = world * skinMat;																					#only:SKINNING
	mat4 worldMatrix = (INSTANCED0 * worldSkin); 																			#only:INSTANCED
	
	gl_Position = (worldMatrix * vec4(POSITION, 1.0));																		#only:~SKYBOX
};
