Material "fsq_deferred_copydepth"
	Shader "shaders/deferred_final"
	ShaderFlag "FSQ"
	RS_DepthFunc "Always"
	RS_BlendMode "AlphaBlend"
	RS_Culling "CCW"
	RS_SetFlag { "DepthTest", true }
	RS_SetFlag { "DepthWrite", true }
	Import "Custom"
	Import "Frame"
	Import "Framebuffer"