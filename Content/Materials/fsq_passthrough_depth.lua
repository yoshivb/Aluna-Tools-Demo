Material "fsq_passthrough_depth"
	Shader "shaders/fsq_passthrough_depth"
	ShaderFlag "FSQ"
	RS_DepthFunc "Always"
	RS_BlendMode "Replace"
	RS_SetFlag { "DepthTest", true }
	RS_SetFlag { "DepthWrite", true }
	Import "Framebuffer"