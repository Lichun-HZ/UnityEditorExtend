using UnityEngine;
using System.Collections;
using System.IO;
using UnityEditor;

public class ScriptViewWindow : EditorWindow
{

    /// <summary>
    /// 窗口的正确打开方式
    /// </summary>
    [MenuItem("WindowTest/ScriptViewWindow")]
    public static void ShowWindow()
    {
        ScriptViewWindow window = (ScriptViewWindow)EditorWindow.GetWindow(typeof(ScriptViewWindow), false, "ScriptViewWindow");
        window.Show();
    }

    void OnGUI()
    {
        Debug.Log(position);
        //整个窗口为水平布局
        GUILayout.BeginHorizontal();
        DrawLeft();
        DrawRight();
        GUILayout.EndHorizontal();
    }

    private string scriptsContext = "";
    private Vector2 scrollposition;

    /// <summary>
    /// 绘制左边区域
    /// </summary>
    void DrawLeft()
    {
        //局部窗口为垂直布局
        GUILayout.BeginVertical(GUILayout.Width(position.width / 2));
        //空出5个像素
        GUILayout.Space(5);

        //绘制标签
        GUILayout.Label("Preview");

        //开始滑块区域
        scrollposition = GUILayout.BeginScrollView(scrollposition);

        //绘制文本区域
        scriptsContext = GUILayout.TextArea(scriptsContext, GUILayout.ExpandHeight(true));//液态高度(占满高度)

        //结束滑块区域
        GUILayout.EndScrollView();
        GUILayout.EndVertical();
    }

    //文件资源对象
    private TextAsset textAssetObje;

    //脚本资源对象
    private TextAsset scriptAssetObje;

    //文件保存的路径
    private string saveFilePath = "";

    //脚本保存的路径
    private string saveScritpPath = "";

    //绘制2D图片对象
    private Texture2D image;

    /// <summary>
    /// 绘制右边区域
    /// </summary>
    void DrawRight()
    {
        //局部窗口为垂直布局
        GUILayout.BeginVertical();

        GUILayout.Space(5);

        #region 脚本转换为文本功能
        // 绘制对象字段（类型为TextAsset）
        textAssetObje = (TextAsset)EditorGUILayout.ObjectField("Script Object",
                                    textAssetObje, typeof(TextAsset), false);

        //绘制Text字段，用户获取用户指定的路径
        saveFilePath = EditorGUILayout.TextField("Save In", saveFilePath);

        GUILayout.Space(5);

        //当我们点击这个按钮时
        if (GUILayout.Button("Save File"))
        {
            //执行这个方法
            SaveFile();
        }

        #endregion

        GUILayout.Space(5);

        #region 绘制显示脚本内容功能
        //当点击 Show Script 按钮时
        if (GUILayout.Button("Show Script"))
        {
            //执行 ShowScript 函数
            ShowScript();
        }
        #endregion

        GUILayout.Space(10);

        #region 文本转换为脚本功能
        scriptAssetObje = (TextAsset)EditorGUILayout.ObjectField("Text Object",
                            scriptAssetObje, typeof(TextAsset), false);

        saveScritpPath = EditorGUILayout.TextField("Save In", saveScritpPath);

        GUILayout.Space(5);

        //当我们点击这个按钮时
        if (GUILayout.Button("Create Script"))
        {
            //执行这个方法
            CreateScript();
        }
        #endregion

        #region 绘制图片
        //通过Resources.load() 加载指定的图片
        if (image == null)
        {
            image = Resources.Load<Texture2D>("image");
        }

        //GUILayoutUtility.GetRect()方法会在剩下的区域返回指定宽高的矩阵
        GUI.DrawTexture(GUILayoutUtility.GetRect((position.width / 2), 0, GUILayout.ExpandHeight(true)), image);

        #endregion

        GUILayout.EndVertical();
    }

    //默认文件保存路径
    private const string defaultFilePath = "Assets/LitionUtility/TextAssets/";

    //默认脚本保存路径
    private const string defaultScriptPath = "Assets/LitionUtility/ScriptAssets/";

    /// <summary>
    /// 脚本转换文本
    /// </summary>
    void SaveFile()
    {
        //1.保存到默认路径
        if (saveFilePath.Equals(""))
        {
            //保存到默认路径            
            //如果文件夹不存在
            if (!Directory.Exists(defaultFilePath))
            {
                //则创建文件夹
                Directory.CreateDirectory(defaultFilePath);
            }

            //1.写入文件
            // 创建StreamWriter
            StreamWriter sw = new StreamWriter(defaultFilePath + textAssetObje.name + ".txt");

            //写入文件
            sw.Write(textAssetObje.text);

            //关闭流
            sw.Close();
        }
        else
        {
            //保存到用户指定的路径
            //判断文件夹是否存在
            if (!Directory.Exists("Assets/" + saveFilePath))
            {
                //不存在，则创建一个新的
                Directory.CreateDirectory("Assets/" + saveFilePath);
            }

            //同上
            StreamWriter sw = new StreamWriter("Assets/" + saveFilePath + "/" + textAssetObje.name + ".txt");
            sw.Write(textAssetObje.text);
            sw.Close();
        }

        //刷新资源
        AssetDatabase.Refresh();
    }

    void CreateScript()
    {
        //1.保存到默认路径
        if (saveScritpPath.Equals(""))
        {
            //保存到默认路径            
            //如果文件夹不存在
            if (!Directory.Exists(defaultScriptPath))
            {
                //则创建文件夹
                Directory.CreateDirectory(defaultScriptPath);
            }

            //1.写入文件
            // 创建StreamWriter
            StreamWriter sw = new StreamWriter(defaultScriptPath + scriptAssetObje.name + ".cs");

            //写入文件
            sw.Write(scriptAssetObje.text);

            //关闭流
            sw.Close();
        }
        else
        {
            //保存到用户指定的路径
            //判断文件夹是否存在
            if (!Directory.Exists("Assets/" + saveScritpPath))
            {
                //不存在，则创建一个新的
                Directory.CreateDirectory("Assets/" + saveScritpPath);
            }

            //同上
            StreamWriter sw = new StreamWriter("Assets/" + saveScritpPath + "/" + scriptAssetObje.name + ".txt");
            sw.Write(scriptAssetObje.text);
            sw.Close();
        }

        //刷新资源
        AssetDatabase.Refresh();
        //2.用户指定的路径
    }

    /// <summary>
    /// 将脚本的内容显示到左边的文本区域中
    /// </summary>
    void ShowScript()
    {
        //textAssetObje.text 将脚本的内容转换成字符串
        //scriptsContext 用于显示左边文本区域对应的变量
        scriptsContext = textAssetObje.text;
    }
}
