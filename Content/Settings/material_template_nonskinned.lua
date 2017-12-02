-- set instance mode
--instanceMode = "VBO"
instanceMode = "UBO"

--EnableOptimization "BlockRebind"
Pass "FORWARD"
	CopyPass ""
	Import "World"
	Import "Frame"
	
	if GetShader() == "" then Shader "shaders/geometry_default" end
	if GetTexture("Tangent Normal Map") ~= "" then ShaderFlag "HAS_TNORMALMAP" end
	if GetTexture("World Normal Map") ~= "" then ShaderFlag "HAS_WNORMALMAP" end
	if GetTexture("Emissive") ~= "" then ShaderFlag "HAS_EMISSIVEMAP" end
	if GetTexture("Specular") ~= "" then ShaderFlag "HAS_SPECULAR" end
Pass "FORWARD_LIT"
	CopyPass "FORWARD"
	--if not IsUniform4fSet("specularSettings") then Uniform4f { "specularSettings", 32.0, 0.7, 1.0, 0.0 } end
	Import "Lights"
	ShaderFlag "LIT"
Pass "FORWARD_INSTANCED"
	CopyPass "FORWARD"
	ShaderFlag "INSTANCED"
	if instanceMode == "VBO" then ShaderFlag "INSTANCED_VB" end
	if instanceMode == "UBO" then ShaderFlag "INSTANCED_UBO" end
Pass "FORWARD_LIT_INSTANCED"
	CopyPass "FORWARD_LIT"
	ShaderFlag "INSTANCED"
	if instanceMode == "VBO" then ShaderFlag "INSTANCED_VB" end
	if instanceMode == "UBO" then ShaderFlag "INSTANCED_UBO" end
Pass "DEFERRED"
	CopyPass "FORWARD"
	ShaderFlag "DEFERRED"
Pass "SELECTION"
	CopyPass "FORWARD"
	Import "SelectionID"
	RS_BlendMode "Replace"
	Shader "shaders/geometry_select"
	Texture {"Tangent Normal Map", "" }
	Texture {"World Normal Map", "" }
	Texture {"Emissive", "" }
	Texture {"Specular", "" }
Pass "WIREFRAME"
	CopyPass "FORWARD"
	RS_SetFlag { "Wireframe", true }
Pass "SHADOW"
	CopyPass ""
	Import "World"
	Import "Frame"
	RS_DepthBias(0.0)
	RS_DepthBiasFactor(1.0)
	Shader "shaders/geometry_shadow"
	ShaderFlag "SHADOWED"
	if IsShaderFlagSet("ALPHATEST") == false then
		Texture {"Diffuse", ""}
	end
	Texture {"Tangent Normal Map", "" }
	Texture {"World Normal Map", "" }
	Texture {"Emissive", "" }	
	Texture {"Specular", "" }
Pass "SHADOW_CUBE"
	CopyPass "SHADOW"
	Shader "shaders/geometry_shadow_cube"
	ShaderGeometryShader(true)
	Import "ShadowCube"