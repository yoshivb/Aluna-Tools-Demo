Material "ConfigMatSet_01"
	Texture {"Diffuse","Textures/ShipTextures/IntTextures/int_RGBmap_01.tga"}
	Shader "Shaders/interior_colored_geometry"
	Texture {"Specular","textures/hallwayspectest.png"}
	Uniform4f { "blockColor0", 165.0/255.0, 165.0/255.0, 165.0/255.0, 1.0 };
	Uniform4f { "blockColor1", 109.0/255.0, 109.0/255.0, 109.0/255.0, 1.0 };
	Uniform4f { "blockColor2", 145.0/255.0, 62.0/255.0, 62.0/255.0, 1.0};
	Uniform4f { "blockColor3", 92.0/255.0, 135.0/255.0, 169.0/255.0, 1.0 };
	Uniform4f { "blockColor4", 2.0, 2.0, 2.5, 1.0 };
	Uniform4f { "blockSpecularPower", 256.0, 16.0, 32.0, 64.0 };
	Uniform4f { "blockSpecularIntensity", 0.4, 0.1, 0.1, 0.3 };