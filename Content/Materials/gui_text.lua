Pass "GUI_COLOR"
	Shader "shaders/gui_shader"
	ShaderFlag "PROJECTION"
	ShaderFlag "HAS_COLOR"
	ShaderFlag "COLOR_DIV_255"
	Import "GUI"
	RS_BlendMode "AlphaBlend"
	RS_Culling "CW"
	RS_SetFlag { "DepthTest", false }
	RS_SetFlag { "DepthWrite", false }
	
Pass "GUI_TEXTURE"
	CopyPass "GUI_COLOR"
	ShaderFlag "TEXTURE"