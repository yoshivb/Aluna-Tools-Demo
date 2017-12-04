#---FRAGMENT---#
uniform sampler2D tex0; // name: texDiffuse									#only:TEXTURE
uniform sampler2D tex0; // name: texDiffuse									#only:TEXTURE_RED_ONLY
uniform sampler2D tex1; // name: texMask									#only:TEXTURE_MASK
uniform vec4 oColor; 	// name: overrideColor								#only:COLORED
in vec4 VSOutCOLOR0; 	// name: VSColor									#only:HAS_COLOR
in vec3 VSOutTEXCOORD0; // name: VSUv
out vec4 FragmentColor0; // name: FragmentColor

void main()
{
	FragmentColor0 = vec4(1.0, 1.0, 1.0, 1.0);								#only:~TEXTURE
	FragmentColor0 = texture(tex0, VSOutTEXCOORD0.xy);						#only:TEXTURE
	FragmentColor0 = vec4(1.0,1.0,1.0,texture(tex0, VSOutTEXCOORD0.xy).x);	#only:TEXTURE_RED_ONLY
	
	FragmentColor0 *= oColor;												#only:COLORED
	FragmentColor0 *= VSOutCOLOR0;											#only:HAS_COLOR
	FragmentColor0.a *= texture(tex1, VSOutTEXCOORD0.xy);					#only:TEXTURE_MASK

	if(FragmentColor0.a < 1.0/255.0)
		discard;
}

#---VERTEX---#
#include "shaders/template_perframe.glinc"

uniform vec4 scrollUV;														#only:SCROLLUV
uniform vec4 wobbleUV; 														#only:WOBBLEUV
uniform mat4 world; 														#only:WORLD
in vec3 POSITION; // name: Pos
in vec3 TEXCOORD0; // name: Uv
in vec4 COLOR0; 															#only:HAS_COLOR
out vec3 VSOutTEXCOORD0; // name: VSUv
out vec4 VSOutCOLOR0; // name: VSColor										#only:HAS_COLOR

void main()									
{
	VSOutCOLOR0 = COLOR0;													#only:HAS_COLOR
	VSOutCOLOR0 /= vec4(255.0,255.0,255.0,255.0);							#only:COLOR_DIV_255

	VSOutTEXCOORD0 = TEXCOORD0;
	VSOutTEXCOORD0 = VSOutTEXCOORD0 + scrollUV.xyz * time;					#only:SCROLLUV
	VSOutTEXCOORD0 = VSOutTEXCOORD0 + wobbleUV.xyz * time;					#only:WOBBLEUV

#ifdef WORLD		
	gl_Position = (projectionView* (world*vec4(POSITION, 1.0))); 			#only:PROJECTION
	gl_Position = (world*vec4(POSITION, 1.0)); 								#only:~PROJECTION
#else		
	gl_Position = (projectionView* vec4(POSITION, 1.0)); 					#only:PROJECTION
	gl_Position = vec4(POSITION, 1.0);										#only:~PROJECTION
#endif
}

