using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ReadOnlyAttribute : PropertyAttribute
{
    // 字体颜色
    public Color textColor;
	public ReadOnlyAttribute()
    {
        textColor = Color.white;
    }

    public ReadOnlyAttribute(float r, float g, float b)
    {
        textColor = new Color(r,g,b);
    }

    public ReadOnlyAttribute(float r, float g, float b, float a)
    {
        textColor = new Color(r, g, b, a);
    }
}

public class ReadOnlyRangeAttribute : PropertyAttribute
{
    public float min;
    public float max;

    public ReadOnlyRangeAttribute(float min, float max)
    {
        this.min = min;
        this.max = max;
    }
}

public class CustomLabelRangeAttribute : PropertyAttribute
{
    public float min;
    public float max;
    public string labeltext;

    public CustomLabelRangeAttribute(float min, float max, string labeltext)
    {
        this.min = min;
        this.max = max;
        this.labeltext = labeltext;
    }
}