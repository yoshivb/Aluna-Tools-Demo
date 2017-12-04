using Game.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AlunaToolsDemo
{
    public class InstructionsGUI
    {
        private TextRenderer_Standalone m_renderer;

        public InstructionsGUI(TextRenderer_Standalone renderer)
        {
            m_renderer = renderer;
            m_renderer.DrawText(0, 16, 5, 5, "Hold Right Mouse Button - Unlock Movement");
            m_renderer.DrawText(0, 16, 5, 26, "WASD - Movement");
            m_renderer.DrawText(0, 16, 5, 47, "Q - Set Inspected Object");
            m_renderer.DrawText(0, 16, 5, 68, "Z - Add Inspected Object");
            m_renderer.DrawText(0, 16, 5, 89, "E - Interact with Object");
        }
    }
}
