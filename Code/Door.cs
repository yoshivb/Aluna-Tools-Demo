using Game.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AlunaToolsDemo
{
    public class Door: IDisposable
    {
        private const ushort m_toggleKey = (ushort)Aluna.WM_KeyCode.WMKEY_E;

        private Helpers_SceneLoadedSubset m_loadedScene;
        private Helpers.SceneAnimations m_animationHelper;
        private Engine m_engine;
        
        private bool m_isOpen = false;
        public bool IsOpen
        {
            get { return m_isOpen; }
            set
            {
                if (!m_isOpen && value)
                    Open();
                else if (m_isOpen && !value)
                    Close();
                m_isOpen = value;
            }
        }

        public Door(Engine engine, Scene scene)
        {
            m_engine = engine;
            m_loadedScene = scene.LoadScene("Scenes/HallwayDoor_01.mfs");
            m_animationHelper = new Helpers.SceneAnimations(m_loadedScene);
        }

        public void Update()
        {
            if (m_engine.window.IsKeyDownThisFrame(m_toggleKey))
            {
                IsOpen = !m_isOpen;
            }
        }

        public void Dispose()
        {
            m_loadedScene.Unload();
        }

        private void Open()
        {
            m_animationHelper.PlayAnimation("Open");
        }
                
        private void Close()
        {
            m_animationHelper.PlayAnimation("Close");
        }
    }
}
