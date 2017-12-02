#---FRAGMENT---#
uniform vec4 clearColor;
uniform vec4 ambientColor;

uniform sampler2D tex0; // name: tex0
uniform sampler2D tex2; // name: texShadow

in vec3 VSOutTEXCOORD0; // name: OutUv
out vec4 FragmentColor0; // name: FragmentColor

float depthVal;

void main()
{
	depthVal = texture(tex2, VSOutTEXCOORD0.xy).r;
	vec3 v = texture(tex0, VSOutTEXCOORD0.xy).xyz;
	v = pow(max(v, vec3(0.01)), vec3(1.0/2.5));
	FragmentColor0.xyz = v * 0.05;
	FragmentColor0.a = texture(tex0,  VSOutTEXCOORD0.xy).a;
	gl_FragDepth = depthVal;
}

#---VERTEX---#
#include "shaders/template_perframe.glinc"

in vec3 POSITION; 			// name: Pos
in vec3 TEXCOORD0; 			// name: Uv
out vec3 VSOutTEXCOORD0; 	// name: OutUv

void main()
{
	VSOutTEXCOORD0 = TEXCOORD0;
	gl_Position = vec4(POSITION, 1.0);
}

