using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Game.Framework;
using System.Diagnostics;

namespace AlunaToolsDemo
{
    class Program
    {
        public static Game.Framework.Invoker Invoker;

        private static Engine m_engine;

        private static Game.Framework.SceneRenderer m_renderer;

        private static Game.Framework.Scene m_scene;

        private static Helpers_SceneLoadedSubset m_loadedScene;

        private static Game.Framework.CameraFPS m_camera;

        private static string m_exePath = System.IO.Path.GetDirectoryName(System.Reflection.Assembly.GetEntryAssembly().Location);

        private static void InitSettingsDirectory()
        {
            string settingsFolderPath = System.IO.Path.Combine(m_exePath, "../Settings");

            try { System.IO.Directory.CreateDirectory(settingsFolderPath); }
            catch (Exception ex) { Console.WriteLine(ex.ToString()); }

            Environment.CurrentDirectory = settingsFolderPath;
        }

        private static void InitFileSystem()
        {
            string contentFolderPath = System.IO.Path.Combine(m_exePath, "../Content");
            var fileSystem = Aluna.AlunaNETBridge.GetFileSystem();
            fileSystem.AddFileSystem(new Aluna.CFileSystem_DirectoryFopen(contentFolderPath));
        }

        private static void Init()
        {
            Thread currentThread = Thread.CurrentThread;
            currentThread.Priority = ThreadPriority.Highest;
            currentThread.CurrentCulture = CultureInfo.InvariantCulture;
            CultureInfo.DefaultThreadCurrentCulture = CultureInfo.InvariantCulture;

            Aluna.CRenderer_GL.SetMinimumVersion(3, 2);
            Aluna.CRenderer_GL.SetMaximumVersion(3, 2);

            InitSettingsDirectory();
            InitFileSystem();

            SystemIdentifier.Start();
            Serialization.Initialize();
            Engine.InitPhysics();

            Invoker = new Game.Framework.Invoker();

            m_engine = new Engine();

            Engine.InitializeFlags flags = Engine.InitializeFlags.DisableResize;
            m_engine.Initialize("Aluna Tools Demo", 1280, 720, flags, -1);
            Aluna.AlunaNETBridge.CfcAlunaBridgeInitialize(m_engine.window._window);

            var textRenderer = (TextRenderer_Standalone)m_engine.textDraw;
            textRenderer.AddFont("Fonts/FreeSans.ttf");

            m_scene = new Scene(true);
            m_renderer = new SceneRenderer(m_engine, m_scene, "fullbright", "none", false);
            m_camera = new CameraFPS(m_engine, false);

            m_camera.SetPosition(new Microsoft.Xna.Framework.Vector3(2,0,2));
            m_camera.LookAtDirection(new Microsoft.Xna.Framework.Vector3(-1,0,0));
            m_camera.InputMoveCameraEnabled = m_camera.InputRotateCameraEnabled = false;

            m_loadedScene = m_scene.LoadScene("Scenes/HallwayDoor_01.mfs");
        }

        private static void MainLoop()
        {
            while (m_engine.window.IsClosed() == false && Engine.Running)
            {
                m_engine.window._window.BeginFrame();
                m_engine.renderer.BeginFrame();
                m_engine.renderer.SetClearColor(0.0f, 0.0f, 0.0f, 0.0f);
                m_engine.renderer.Clear(true, true, false);

                bool isRightMouseDown = m_engine.window.IsMouseDown(Aluna.WM_MouseButton.WMBTN_RIGHT);
                m_camera.InputMoveCameraEnabled = m_camera.InputRotateCameraEnabled = isRightMouseDown;
                m_camera.Update();
                m_camera.Apply();
                m_renderer.Render();
                m_engine.Update();
                Invoker.ExecuteQueue();

                m_engine.renderer.Swap();
                m_engine.window._window.EndFrame();
                m_engine.EndFrame();
            }
        }

        private static void Shutdown()
        {
            m_loadedScene.Unload();
            m_camera.Unload();

            if (Engine.PhysicsEngine != null)
                Engine.PhysicsEngine.Dispose();

            m_engine.Unload();
            m_engine = null;
        }

        private static void Main(string[] args)
        {
            Init();

            MainLoop();

            Shutdown();
        }
    }
}
