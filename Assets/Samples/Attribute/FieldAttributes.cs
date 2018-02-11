using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// 让子类（继承类）的变量属性显示在检视面板中，也能序列化它，如果没有设置Serializable
// 则FieldAttributes类中的Boy成员不会显示在Inspector面板，也无法序列化它。
[System.Serializable]
public class Boy{    public int stength;}

public class FieldAttributes : MonoBehaviour {

    [Header("BaseInfo")]   // 添加属性的标题
    [Multiline(5)]         // 给string类型添加多行输入
    public string stringField;

    [Range(-2, 2)]  // 将一个值指定在一定的范围内，并在Inspector面板中为其添加滑块
    public int intRange;

    [Range(-2.0f, 2.0f)]
    public float floatRange;

    [Space(10)]                // 在Inspector面板两属性之间添加指定的距离（像素）
    [Tooltip("用于设置性别!")]  // 当鼠标停留在设置了Tooptip()的属性上时显示指定的提示
    public string sex;

    // 类对象成员
    public Boy bb;

    // HideInInspector和NonSerialized都会使public变量在面板隐藏，但是HideInInspector修饰
    // 的public变量还是会被序列化，而NonSerialized修饰的不会被序列化。
    [HideInInspector]
    public int hidenInt = 0;
    [System.NonSerialized]
    public int nonSerializeInt = 0;

    // SerializeField使得非public变量也能被序列化，而且还是显示在Inspector面板上。
    // 和HideInInspector一起用可以让它能被序列化而且不会显示在面板上。
    [HideInInspector]
    [SerializeField, Range(0, 100)]  // 成员变量需要序列化用SerializeField，类对象在类定义前加Serializable
    private int age = 0;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}

    [ContextMenu("IncreHideInt")]
    void IncreHideInt()    {        ++hidenInt;        ++nonSerializeInt;        ++age;    }

    [ContextMenu("OutputInfo")]
    void OutputHidenInfo()    {        print(hidenInt + " | " + nonSerializeInt + " | " + age);    }
}
