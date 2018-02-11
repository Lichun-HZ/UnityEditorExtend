﻿using UnityEngine;

[CustomPropertyDrawer(typeof(Ingredient))]
{
    // Draw the property inside the given rect
    public override void OnGUI(Rect position, SerializedProperty property, GUIContent label)
    {
        // Using BeginProperty / EndProperty on the parent property means that
        // prefab override logic works on the entire property.
        EditorGUI.BeginProperty(position, label, property);
        // Draw label
        position = EditorGUI.PrefixLabel(position, GUIUtility.GetControlID(FocusType.Passive), label);
        // Don't make child fields be indented
        int indent = EditorGUI.indentLevel;

        // Calculate rects
        Rect amountRect = new Rect(position.x, position.y, 30, position.height);

        // Draw fields - passs GUIContent.none to each so they are drawn without labels
        EditorGUI.PropertyField(amountRect, property.FindPropertyRelative("amount"), GUIContent.none);

        // Set indent back to what it was
        EditorGUI.indentLevel = indent;
        EditorGUI.EndProperty();