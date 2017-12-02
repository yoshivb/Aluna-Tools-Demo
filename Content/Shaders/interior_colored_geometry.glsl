
#---FRAGMENT---#
#include "shaders/template_perframe.glinc"
#include "shaders/template_matrixhelpers.glinc"
#include "shaders/template_lighting_fs.glinc"				#only:LIT

uniform sampler2D tex0;
uniform sampler2D tex1;
uniform sampler2D tex2;
uniform sampler2D tex3;
uniform sampler2D tex4;
uniform sampler2D tex5;
uniform sampler2D tex6;
uniform sampler2D tex7;
uniform samplerCube tex8;

uniform mat4 world;

in vec4 UV0;
in vec3 fragWorldPosition;
in vec3 fragNormal; 
in vec3 fragTangent;
in vec3 fragBitangent;

out vec4 FragmentColor0; // name: FragmentColor
out vec4 FragmentColor1; // name: FragmentColor1			#only:DEFERRED
out vec4 FragmentColor2; // name: FragmentColor2			#only:DEFERRED

uniform vec4 blockColor0;
uniform vec4 blockColor1;
uniform vec4 blockColor2;
uniform vec4 blockColor3;
uniform vec4 blockColor4;
uniform vec4 blockSpecularPower;
uniform vec4 blockSpecularIntensity;

void main()
{
	vec4 n54 = UV0;

	float specularIntensity;
	float specularPower;
	
	vec4 clr0 = vec4(1.0, 0.0, 0.0, 1.0);
	vec4 albedo = texture(tex0, (vec4(n54.x, n54.y, 0.0, 0.0)).xy);
	float highlight = pow(albedo.x, 9.0) * 1.0;
	float v = floor(n54.x);
	if(v == 0.0)
	{
		albedo *= blockColor0;
		specularIntensity = blockSpecularIntensity.x;
		specularPower = blockSpecularPower.x;
	}
	else if(v == 1.0)
	{
		albedo *= blockColor1;
		specularIntensity = blockSpecularIntensity.y;
		specularPower = blockSpecularPower.y;
	}
	else if(v == 2.0)
	{
		albedo *= blockColor2;
		specularIntensity = blockSpecularIntensity.z;
		specularPower = blockSpecularPower.z;
	}
	else if(v == 3.0)
	{
		albedo *= blockColor3;
		specularIntensity = blockSpecularIntensity.w;
		specularPower = blockSpecularPower.w;
	}
	else if(v == 4.0)
	{
		albedo = blockColor4;
		specularIntensity = 0.0;
		specularPower = 1.0;
	}
		
	if(v != 4.0)
		albedo += vec4(highlight, highlight, highlight, 0.0) * saturate((1.0 - length(albedo.xyz)));
		
#ifdef HAS_TNORMALMAP
	vec4 normalSample = texture(tex1, UV0.xy);
	vec3 tangentSpaceNormal = ( normalSample.xyz - 0.5) * 2.0;
	
	mat3 tangentToWorldMatrix = mat3(fragTangent, fragBitangent, fragNormal);
	vec3 normal = ( tangentToWorldMatrix* tangentSpaceNormal);
#else 
	vec3 normal = (world * vec4(texture(tex1, UV0.xy).xyz * 2.0 - 1.0, 0.0)).xyz;		#only:HAS_WNORMALMAP
	vec3 normal = fragNormal;																		#only:~HAS_WNORMALMAP
#endif

	vec4 emissive = vec4(0.0);

	// specular factor
#ifdef LIT
	FragmentColor0 = vec4(CalculateForwardLighting(albedo, normal, fragWorldPosition, specularPower, specularIntensity) + emissive.xyz, albedo.w);
	FragmentColor0.a = 1.0;
#else
	FragmentColor0 = vec4(albedo.xyz + emissive.xyz, albedo.w);
	FragmentColor0.a = 1.0;
#endif

#ifdef DEFERRED
	FragmentColor1 = vec4((normal.xyz + 1.0) * 0.5, 0.0);
	FragmentColor2 = vec4(specularPower, specularIntensity, 0.0, 0.0 );
	FragmentColor0.a = 1.0;
#endif
}

#---VERTEX---#
#include "shaders/template_perframe.glinc"

uniform mat4 world;
uniform mat4 skinmatrix[100];								#only:SKINNING
#define worldSkin (worldSkinMat)							#only:SKINNING
#define worldSkin (world)									#only:~SKINNING
#define worldMatrix (worldSkin)								#only:~INSTANCED
#define skinMatrix skinmatrix

// in variables
in vec3 POSITION; // name: Pos
in vec4 TEXCOORD0; // name: TexCoord0
in vec3 NORMAL; // name: Normal
in vec3 TANGENT; // name: Tangent
in vec3 BITANGENT; // name: Bitangent
in vec4 BLENDINDICES; // name: BlendIndices					#only:SKINNING
in vec4 BLENDWEIGHT; // name: BlendWeight					#only:SKINNING
in mat4 INSTANCED0; // name: InstanceWorld					#only:INSTANCED

// out variables
out vec4 UV0; // name: OutTexCoord0
out vec3 fragWorldPosition; // name: OutWorldPosition
out vec3 fragNormal; // name: OutNormal
out vec3 fragTangent; // name: OutTangent
out vec3 fragBitangent; // name: OutBitangent

void main()
{
	UV0 = TEXCOORD0;
	
	mat4 skinMat =	(skinMatrix[int(BLENDINDICES.x)] * BLENDWEIGHT.x) + (skinMatrix[int(BLENDINDICES.y)] * BLENDWEIGHT.y) + #only:SKINNING
					(skinMatrix[int(BLENDINDICES.z)] * BLENDWEIGHT.z) + (skinMatrix[int(BLENDINDICES.w)] * BLENDWEIGHT.w);	#only:SKINNING
					
	mat4 worldSkinMat = world * skinMat;					#only:SKINNING
	mat4 worldMatrix = (INSTANCED0 * worldSkin); 			#only:INSTANCED
	
	fragWorldPosition = (worldMatrix * vec4(POSITION, 1.0)).xyz;
	fragNormal = normalize((worldMatrix * vec4(NORMAL, 0.0)).xyz);
	fragTangent = normalize((worldMatrix * vec4(TANGENT,0.0)).xyz);
	fragBitangent = normalize((worldMatrix * vec4(BITANGENT,0.0)).xyz);
	
	gl_Position = projectionView * (worldMatrix * vec4(POSITION, 1.0));
};

