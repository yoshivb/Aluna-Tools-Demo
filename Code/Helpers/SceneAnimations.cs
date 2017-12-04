using Game.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AlunaToolsDemo.Helpers
{
    public class SceneAnimations
    {
        Dictionary<string, List<Aluna.ComponentAnimationController>> m_animationControllersMap = new Dictionary<string, List<Aluna.ComponentAnimationController>>();

        public SceneAnimations(Helpers_SceneLoadedSubset scene)
        {
            if (scene == null) return;
            foreach (var entity in scene.Entities)
            {
                var controller = entity.FindComponent<Aluna.ComponentAnimationController>();
                if (controller != null)
                {
                    for (int i = 0; i < controller.GetAnimationCount(); i++)
                    {
                        string animationName = controller.GetAnimationName(i);
                        if (!m_animationControllersMap.ContainsKey(animationName))
                            m_animationControllersMap.Add(animationName, new List<Aluna.ComponentAnimationController>());
                        m_animationControllersMap[animationName].Add(controller);
                    }
                }
            }
        }

        public void PlayAnimation(string animationName, bool isLooping = false)
        {
            if (m_animationControllersMap.ContainsKey(animationName))
            {
                foreach (var animator in m_animationControllersMap[animationName])
                    animator.PlayAnimation(animationName, isLooping);
            }
        }
    }
}
