#---FRAGMENT---#
uniform sampler2D tex0; // name: texImage
uniform sampler2D tex1; // name: texDepth
in vec3 VSOutTEXCOORD0; // name: OutU
out vec4 FragmentColor0; // name: FragmentColor

void main()
{
	FragmentColor0 = texture(tex0, VSOutTEXCOORD0.xy);
	gl_FragDepth = texture(tex1, VSOutTEXCOORD0.xy).r;
}

#---VERTEX---#
in vec3 POSITION; // name: Pos
in vec3 TEXCOORD0; // name: Uv
out vec3 VSOutTEXCOORD0; // name: OutUv

void main()
{
	VSOutTEXCOORD0 = TEXCOORD0;
	gl_Position = vec4(POSITION, 1.0);
}