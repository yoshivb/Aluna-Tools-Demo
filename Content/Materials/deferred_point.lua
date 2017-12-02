Material "deferred_point"
Pass "PASS1"
	Shader "shaders/deferred_point"
	ShaderFlag "GEOMETRY" 
	RS_BlendMode "Additive"
	RS_Culling "CCW"
	RS_SetFlag { "DepthTest", true }
	RS_SetFlag { "DepthWrite", false }
	Import "World"
	Import "Frame"
	Import "Custom"
Pass "PASS2"
	CopyPass "PASS1"
	ShaderFlag "SHADOWED"
Pass "PASS3"
	CopyPass "PASS1"
	RS_Culling "CW"
	RS_SetFlag { "DepthTest", false }
Pass "PASS4"
	CopyPass "PASS2"
	RS_Culling "CW"
	RS_SetFlag { "DepthTest", false }