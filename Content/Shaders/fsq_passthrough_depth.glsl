#---FRAGMENT---#
uniform sampler2D tex0; // name: tex0
in vec3 VSOutTEXCOORD0; // name: OutU
out vec4 FragmentColor0; // name: FragmentColor

void main()
{
	gl_FragDepth = texture(tex0, VSOutTEXCOORD0.xy).r;
	FragmentColor0 = vec4(0.0, 0.0, 0.0, 0.0);
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