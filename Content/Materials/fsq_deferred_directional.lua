Material "fsq_deferred_directional"
	Shader "shaders/deferred_directional"
	ShaderFlag "FSQ"
	RS_BlendMode "Additive"
	RS_Culling "CCW"
	RS_SetFlag {"DepthTest", false}
	RS_SetFlag {"DepthWrite", false}
	Import "Custom"
	Import "Frame"
	Import "Framebuffer"