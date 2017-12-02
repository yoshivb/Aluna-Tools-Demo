DefinePass { "", 0 }
DefinePass { "FORWARD", 1 }
DefinePass { "FORWARD_LIT", 2 }
DefinePass { "DEFERRED", 3 }
DefinePass { "SHADOW", 4 }
DefinePass { "SELECTION", 5 }
DefinePass { "WIREFRAME", 6 }
DefinePass { "FORWARD_INSTANCED", 7 }
DefinePass { "FORWARD_LIT_INSTANCED", 8 }
DefinePass { "SHADOW_CUBE", 9 }
DefinePass { "PASS1", 1 }
DefinePass { "PASS2", 2 }
DefinePass { "PASS3", 3 }
DefinePass { "PASS4", 4 }
DefinePass { "PASS5", 5 }
DefinePass { "PASS6", 6 }
DefinePass { "PASS7", 7 }
DefinePass { "PASS8", 8 }
DefinePass { "PASS9", 9 }
DefinePass { "PASS10", 10 }
DefinePass { "GUI_COLOR", 1 }
DefinePass { "GUI_TEXTURE", 2 }
DefinePass { "PARTICLE_RENDER", 1 }
DefinePass { "PARTICLE_UPDATE", 2 }
DefinePass { "PARTICLE_UPDATE_AND_DESTROY", 3 }
DefineImport {"World", 0}
DefineImport {"Frame", 1}
DefineImport {"Skinning", 2}
DefineImport {"Framebuffer", 3}
DefineImport {"SelectionID", 4}
DefineImport {"GUI", 4 } -- gui shares index of SelectionID, making it impossible to import both SelectionID and GUI at the same time - which should never be needed anyway.
DefineImport {"Particles", 4 }
DefineImport {"ShadowCube", 7 }
DefineImport {"Lights", 5}
DefineImport {"Custom", 6}
DefineTexture {"Diffuse", 0}
DefineTexture {"Tangent Normal Map", 1}
DefineTexture {"World Normal Map", 1}
DefineTexture {"Mask", 1 }
DefineTexture {"Emissive", 2}
DefineTexture {"Specular", 3}
DefineTexture {"Lightmap", 4}
DefineTexture {"Displacement", 5}
DefineTexture {"Environmentmap", 4}
DefineTexture {"TEXTURE0", 0}
DefineTexture {"TEXTURE1", 1}
DefineTexture {"TEXTURE2", 2}
DefineTexture {"TEXTURE3", 3}
DefineTexture {"TEXTURE4", 4}
DefineTexture {"TEXTURE5", 5}
DefineTexture {"TEXTURE6", 6}
DefineTexture {"TEXTURE7", 7}
DefineTexture {"TEXTURE8", 8}
DefineTexture {"TEXTURE9", 9}
DefineTexture {"TEXTURE10", 10}
DefineTexture {"TEXTURE11", 11}
DefineTexture {"TEXTURE12", 12}
DefineTexture {"TEXTURE13", 13}
DefineTexture {"TEXTURE14", 14}
DefineTexture {"TEXTURE15", 15}
DefineLayer {"Default", 0}
DefineLayer {"NoLighting", 1}
DefineLayer {"NoLightingAlphaSorted", 2}