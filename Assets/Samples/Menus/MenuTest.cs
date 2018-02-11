using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif
/*
 * 这个脚本演示了菜单项扩展的基本用法，包括
 * 1：组件菜单项的添加，以及设置该组件不能重复添加，添加该组件时自动添加依赖组件，自定义文档链接。
 * 2：ContexMenu和ContextMenuItem的用法。
 * 3：MenuItem的普通用法，以及Menu快捷键添加。
 * 4：MenuItem的特殊用法，包括在Assets菜单中添加（其实和普通的差不多，只是Assets是一个特殊的菜单目录），以及在其他Component上添加菜单。
 */
[AddComponentMenu("ESComponent/MenuTest")]  // 添加Component菜单项[DisallowMultipleComponent]                 // 不允许重复添加该组件[RequireComponent(typeof(Rigidbody))]       // 自动添加其他Component
[HelpURL("http://www.baidu.com")]           // 提供一个自定义文档链接，点击组件上的文档图标即可打开你指定的连接public class MenuTest : MonoBehaviour
{
    /*     * ContextMenu()属性允许添加一个命令到该组件上，你可以通过右键或者点击设置图标来调用到它（一般用于函数），且是在非运行状态下执行该函数;      * ContextMenuItem()属性允许添加一个命令到该变量上，可通过右击变量显示出菜单来调用对应方法     */
    [ContextMenuItem("右击时显示", "OutputInfo")]    public string pname = "Lilei";    public int age = 10;    // 在Component右侧下来菜单中显示    [ContextMenu("OutputInfo")]      void OutputInfo()    {        print(pname + "|" + age);    }

#if UNITY_EDITOR
    /*
     * 为了使超级用户和喜欢使用键盘的用户工作的更快捷，我们可以为新的菜单项关联一个快捷键-使用快捷键的组合将自动的启动他们菜单项。 
     * 下面是被指定的键（它们也可以组合起来使用）：
	 * • % - CTRL 在Windows / CMD在OSX
	 * • # - Shift
	 * • & - Alt
	 * • LEFT/RIGHT/UP/DOWN-光标键
	 * • F1…F12
	 * • HOME,END,PGUP,PDDN
     * 字母键不是key-sequence的一部分，要让字母键被添加到key-sequence中必须在前面加上下划线（例如：_g对应于快捷键”G”）。 
     * 快捷键的组合被添加在菜单项的路径后面，并以一个空格分隔。如下显示的示例：
     */
    // 普通Menu带快捷键
    // Add a new menu item with hotkey CTRL-SHIFT-X
    [MenuItem("MenuTest/New Option %#x")]
    private static void NewMenuOption()
    {
        print("NewMenuOption CTRL-SHIFT-X");
    }
    // Add a new menu item with hotkey CTRL-G
    [MenuItem("MenuTest/Item %g")]
    private static void NewNestedOption()
    {
        print("NewMenuOption CTRL-G");
    }
    // Add a new menu item with hotkey G
    [MenuItem("MenuTest/Item2 _g")]
    private static void NewOptionWithHotkey()
    {
        print("NewMenuOption G");
    }


    // 特殊路径Menu：
    // Assets -菜单项将被显示在“Assets”菜单下，同时也显示在右键单击项目视图时弹出的菜单中。
    // Asset/Create - 菜单项将被列出在，当你在项目视图中单了右键菜单里的“Create”子菜单中（当你创建了能够添加项目的新类型时，此功能是是非常有用的）。
    // CONTEXT/ComponentName - 菜单项将出现在给定组件的上下文菜单（右键单击显示的菜单）中。

    // Add a new menu item that is accessed by right-clicking on an asset in the project view
    [MenuItem("Assets/MenuTest/PeopleFormAssetMenu")]
    private static void LoadAdditiveScene()
    {

    }

    // Adding a new menu item under Assets/Create
    [MenuItem("Assets/Create/PeopleFormAssetCreateMenu")]
    private static void AddConfig()
    {
        // Create and add a new ScriptableObject for storing configuration
    }

    // Add a new menu item that is accessed by right-clicking inside the RigidBody component
    [MenuItem("CONTEXT/Rigidbody/PeopleFormRigidBodyComponent")]
    private static void NewOpenForRigidBody()
    {
    }
#endif}

