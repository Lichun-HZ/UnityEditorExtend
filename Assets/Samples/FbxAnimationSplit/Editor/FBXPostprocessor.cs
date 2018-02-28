using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using System.Text.RegularExpressions;
using System;
using System.Collections.Generic;

public class FBXPostprocessor : AssetPostprocessor
{
    enum AniFlag
    {
        Looping = 0x1,
    };

    // This method is called just before importing an FBX.  
    void OnPreprocessModel()
    {
        if (Path.GetExtension(assetPath).ToLower() != ".fbx")
            return;

        Debug.Log("OnPreprocessModel " + assetPath);

        ModelImporter mi = (ModelImporter)assetImporter;

        //clips txt  
        TextAsset clipsAsset = (TextAsset)AssetDatabase.LoadAssetAtPath(assetPath.Substring(0, assetPath.LastIndexOf('.')) + "_clips.txt", typeof(TextAsset));
        if (clipsAsset != null)
        {
            List<ModelImporterClipAnimation> anims = new List<ModelImporterClipAnimation>();

            string[] clipsText = clipsAsset.text.Replace("\r\n", "\n").Split('\n');
            foreach (string c in clipsText)
            {
                string[] vs = c.Split(',');
                if (vs.Length >= 4)
                {
                    string name = vs[0];
                    string begin = vs[1].Substring(0, vs[1].Length - 1); 
                    string end = vs[2].Substring(0, vs[2].Length - 1);
                    string flag = vs[3];

                    ModelImporterClipAnimation clip = new ModelImporterClipAnimation();
                    clip.name = name;
                    clip.firstFrame = System.Convert.ToInt32(begin);
                    clip.lastFrame = System.Convert.ToInt32(end);
                    int iFlag = System.Convert.ToInt32(flag);

                    if ((iFlag & (int)AniFlag.Looping) != 0)
                    {
                        clip.loop = true;
                        clip.loopPose = true;
                    }

                    anims.Add(clip);
                }
            }

            mi.clipAnimations = anims.ToArray();
        }
    }
}
