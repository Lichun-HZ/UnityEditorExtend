using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * 展示用Editor在OnInspectorGUI中自定义Inspector面板以及在OnSceneGUI中渲染场景辅助物。
 */
[ExecuteInEditMode]
public class LookAtPoint : MonoBehaviour {

    public Vector3 lookAtPoint = Vector3.zero;

    // Use this for initialization
    public void Start ()
    {
	}

    // Update is called once per frame
    public void Update ()
    {
        transform.LookAt(lookAtPoint);
    }
}
