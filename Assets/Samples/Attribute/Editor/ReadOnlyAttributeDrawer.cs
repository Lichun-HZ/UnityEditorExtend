using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;


[CustomPropertyDrawer(typeof(ReadOnlyAttribute))] // 指定是什么属性的绘制类
public class ReadOnlyAttributeDrawer : PropertyDrawer
{
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        string value;

        switch(property.propertyType)
        {
            case SerializedPropertyType.Integer:
                value = property.intValue.ToString();
                break;
            case SerializedPropertyType.String:
                value = property.stringValue;
                break;
            case SerializedPropertyType.Color:
                value = property.colorValue.ToString();
                break;
            case SerializedPropertyType.Vector3:
                value = property.vector3Value.ToString();
                break;
            case SerializedPropertyType.Rect:
                value = property.rectValue.ToString();
                break;
            default:
                throw new ArgumentOutOfRangeException();
        }

        //EditorGUI.LabelField(position, property.displayName + "\t\t:\t" + value);

        // 经过测试，颜色值不起作用，alpha可以。
        ReadOnlyAttribute att = attribute as ReadOnlyAttribute;
        GUI.color = att.textColor;
        GUI.Label(position, property.displayName + "\t\t:\t" + value);
        GUI.color = Color.white;
    }

}

[CustomPropertyDrawer(typeof(ReadOnlyRangeAttribute))]
public class RangeDrawer : PropertyDrawer
{

    // Draw the property inside the given rect
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        ReadOnlyRangeAttribute range = attribute as ReadOnlyRangeAttribute;
        GUI.enabled = false;
        if (property.propertyType == SerializedPropertyType.Float)
        {
            EditorGUI.Slider(position, property, range.min, range.max, "- " + label.text);
        }
        GUI.enabled = true;
    }
}

[CustomPropertyDrawer(typeof(CustomLabelRangeAttribute))]
public class RangeCustomLabel : PropertyDrawer
{

    // Draw the property inside the given rect
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        CustomLabelRangeAttribute range = attribute as CustomLabelRangeAttribute;
        if (property.propertyType == SerializedPropertyType.Float)
        {
            EditorGUI.Slider(position, property, range.min, range.max, range.labeltext);
        }
    }
}
