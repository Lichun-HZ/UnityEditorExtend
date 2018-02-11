using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum IngredientUnit { Spoon, Cup, Bowl, Piece }

[System.Serializable]public class Ingredient : System.Object
{    public string name;    public int amount = 1;    public IngredientUnit unit;}

public class PropertyDrawerTest : MonoBehaviour {

    // 自定义针对内置类型的Attribute
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

    // 针对类类型的PropertyDrawer
    public Ingredient potionResult;    public Ingredient[] potionIngredients;

    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
