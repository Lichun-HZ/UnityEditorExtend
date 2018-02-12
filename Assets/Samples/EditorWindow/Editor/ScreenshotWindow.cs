﻿using UnityEditor;

[ExecuteInEditMode]
    int resWidth = Screen.width * 4;
    int resHeight = Screen.height * 4;
    public Camera myCamera;
    string path = "";
    bool isTransparent = false;

    // Add menu item named "My Window" to the Window menu
    [MenuItem("WindowTest/ScreenshotWindow")]
        //Show existing window instance. If one doesn't exist, make one.
        EditorWindow editorWindow = EditorWindow.GetWindow(typeof(ScreenshotWindow));

    float lastTime;
    void OnGUI()

        EditorGUILayout.Space();
        scale = EditorGUILayout.IntSlider("Scale", scale, 1, 15);
        //显示帮助信息
        EditorGUILayout.HelpBox("The default mode of screenshot is crop - so choose a proper width and height." +
            " The scale is a factor to multiply or enlarge the renders without loosing quality.", MessageType.None);

        EditorGUILayout.Space();
        GUILayout.Label("Save Path", EditorStyles.boldLabel);

        EditorGUILayout.BeginHorizontal();
        EditorGUILayout.EndHorizontal();

        EditorGUILayout.HelpBox("Choose the folder in which to save the screenshots ", MessageType.None);

        GUILayout.Label("Select Camera", EditorStyles.boldLabel);
        myCamera = EditorGUILayout.ObjectField(myCamera, typeof(Camera), true, null) as Camera;
        if (myCamera == null)
        isTransparent = EditorGUILayout.Toggle("Transparent Background", isTransparent);

        EditorGUILayout.HelpBox("Choose the camera of which to capture the render. You can make the background transparent using the transparency option.", MessageType.None);

        EditorGUILayout.Space();
        if (GUILayout.Button("Set To Screen Size"))
        }
        if (GUILayout.Button("Default Size"))
        EditorGUILayout.EndVertical();
        EditorGUILayout.Space();
        if (GUILayout.Button("Take Screenshot", GUILayout.MinHeight(60)))
        EditorGUILayout.Space();
        if (GUILayout.Button("Open Last Screenshot", GUILayout.MaxWidth(160), GUILayout.MinHeight(40)))
        if (GUILayout.Button("Open Folder", GUILayout.MaxWidth(100), GUILayout.MinHeight(40)))
            Application.OpenURL("file://" + path);
        if (GUILayout.Button("More Assets", GUILayout.MaxWidth(100), GUILayout.MinHeight(40)))
        EditorGUILayout.EndHorizontal();

        if (takeHiResShot)
        {
            TextureFormat tFormat;
            Texture2D screenShot = new Texture2D(resWidthN, resHeightN, tFormat, false);
            byte[] bytes = screenShot.EncodeToPNG();
            System.IO.File.WriteAllBytes(filename, bytes);
        EditorGUILayout.HelpBox("In case of any error, make sure you have Unity Pro as the plugin requires Unity Pro to work.", MessageType.Info);
    private bool takeHiResShot = false;
    public string ScreenShotName(int width, int height)
    {
        string strPath = "";
        strPath = string.Format("{0}/screen_{1}x{2}_{3}.png",
                                     path, width, height, System.DateTime.Now.ToString("yyyy-MM-dd_HH-mm-ss"));
        return strPath;
    public void TakeHiResShot()
    {