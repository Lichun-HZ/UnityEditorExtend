using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum IngredientUnit { Spoon, Cup, Bowl, Piece }

[System.Serializable]public class Ingredient : System.Object
{    public string name;    public int amount = 1;    public IngredientUnit unit;}

[ExecuteInEditMode]
public class PropertyDrawerTest : MonoBehaviour {

    // 自定义针对内置类型的Attribute
    [Header("ReadOnly")]
    [ReadOnly(1f, 0f, 0f)] // 也可以写完整[ReadOnlyAttribute]
    public string myString = "Hello";

    [ReadOnly(1f, 1f, 0f)]
    public int myInt = 22;

    [ReadOnly(1f, 1f, 1f, 0.2f)]
    public Color myColor = Color.green;

    [ReadOnly]
    public Vector3 myVector = Vector3.one;

    [ReadOnly]
    public Rect myRect = new Rect(1f,1f,1f,1f);

    [MyRange(0.0f, 10.0f)]
    public float myFloat = 0.0f;

    // 用Rainfall控制RainIntensity，RainIntensity为ReadOnly
    [Header("ReadOnlyRange")]
    [Range(0.0f, 1.0f)]
    public float Rainfall = 0.0f;          

    [ReadOnlyRange(0.0f, 1.0f)]
    public float RainIntensity = 0.0f;

    // 显示相同名称的Attribute
    [Header("CustomLabel")]
    [Space(2)]
    [Tooltip("I am Scale1.")]
    [CustomLabelRange(0.0f, 1.0f, "Scale")]
    public float Scale1 = 0.1f;
    [Tooltip("I am Scale2.")]
    [CustomLabelRange(0.0f, 1.0f, "Scale")]
    public float Scale2 = 0f;

    // 针对类类型的PropertyDrawer
    [Header("Class PropertyDrawer")]
    public Ingredient potionResult;    public Ingredient[] potionIngredients;

    // Use this for initialization
    public void Start ()
    {	
	}

    // 如果没有设置脚本ExecuteInEditMode，update只会在运行时调用。设置后，脚本参数有修改，就会调用一次Update。
    // Update is called once per frame
    public void Update ()
    {
        RainIntensity = Rainfall;
    }
}
