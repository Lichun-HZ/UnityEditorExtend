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
