using UnityEngine;
using UnityEditor;
public class MyWindow : EditorWindow
{
    string myString = "Hello World";
    bool groupEnabled;
    bool myBool = true;
    float myFloat = 1.23f;

    // Add menu named "My Window" to the Window menu
    [MenuItem("WindowTest/My Window")]
    static void Init()   // 这个函数的名称是可以随意的，只要是Static void()签名即可，后面的OnGUI和OnSceneGUI名称必须是固定的
    {
        // Get existing open window or if none, make a new one:
        MyWindow window = (MyWindow)EditorWindow.GetWindow(typeof(MyWindow));
        window.Show();
    }

    // Implement your own editor GUI here.
    void OnGUI()
    {
        GUILayout.Label("Base Settings", EditorStyles.boldLabel);
        myString = EditorGUILayout.TextField("Text Field", myString);

        groupEnabled = EditorGUILayout.BeginToggleGroup("Optional Settings", groupEnabled);
        myBool = EditorGUILayout.Toggle("Toggle", myBool);
        myFloat = EditorGUILayout.Slider("Slider", myFloat, -3, 3);
        EditorGUILayout.EndToggleGroup();
    }

    private void OnFocus()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
        SceneView.onSceneGUIDelegate += this.OnSceneGUI;

    }

    private void OnDestroy()
    {
        SceneView.onSceneGUIDelegate -= this.OnSceneGUI;
    }

    // 注意，EditorWindow是不会有OnSceneGUI回调的，这里只是在上面做了注册。但这就提供了一种通用的方法可以让EditorWindow也在
    // 场景中画一些自己的东西，比如我们自己做的刷阻挡的EditorWindow，在窗口被激活时在场景中画阻挡网格。继承至Editor的是会
    // 自动调用其OnSceneGUI的，让其在场景中绘制东西。Editor的方式和OnSceneGUIDelegate的方式两者的函数签名是不一样的。
    void OnSceneGUI(SceneView sceneView)
    {
        // get the chosen game object
   /*     DrawLine t = target as DrawLine;

        if (t == null || t.GameObjects == null)
            return;

        // grab the center of the parent
        Vector3 center = t.transform.position;

        // iterate over game objects added to the array...
        for (int i = 0; i < t.GameObjects.Length; i++)
        {
            // ... and draw a line between them
            if (t.GameObjects[i] != null)
                Handles.DrawLine(center, t.GameObjects[i].transform.position);
        }*/
    }

}
