Material "fsq_passthrough_with_depth"
	Shader "shaders/fsq_passthrough_with_depth"
	ShaderFlag "FSQ"
	RS_DepthFunc "Always"
	RS_BlendMode "AlphaBlend"
	RS_SetFlag { "DepthTest", true }
	RS_SetFlag { "DepthWrite", true }
	Import "Framebuffer"