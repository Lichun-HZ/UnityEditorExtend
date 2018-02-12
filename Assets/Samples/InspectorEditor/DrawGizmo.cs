using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
#if UNITY_EDITOR
using UnityEditor;
#endif

/*
 * 展示用OnDrawGizmos和OnDrawGizmosSelected在场景视图中渲染辅助物。
 */
[ExecuteInEditMode]
public class DrawGizmo : MonoBehaviour
{
    public float NearClipPlane = 0.01f;
    public float FarClipPlane = 5.0f;
    public float FieldOfView = 60.0f;
    public float AspectRatio = 1.0f;
    public bool Orthographic = true;
    public float OrthographicSize = 2.0f;
    public Material Material;
    public LayerMask IgnoreLayers;
    
    // Use this for initialization
    void Start()
    {

    }

    Matrix4x4 GetProjectMatrix()
    {
        Matrix4x4 viewMatrix = gameObject.transform.worldToLocalMatrix;
        viewMatrix.m22 *= -1.0f;
        Matrix4x4 perspectiveMatrix;

        /*
                Vector3 pos = gameObject.transform.position;
                Vector3 up = gameObject.transform.up;
                Vector3 target = pos + gameObject.transform.forward;
                Matrix4x4 viewMatrix = Matrix4x4.LookAt(pos, target, up).inverse;*/

        if (Orthographic)
        {
            float fHalfWidth = OrthographicSize * AspectRatio;
            perspectiveMatrix = Matrix4x4.Ortho(-OrthographicSize, OrthographicSize, -OrthographicSize, OrthographicSize, NearClipPlane, FarClipPlane);
        }
        else
        {
            perspectiveMatrix = Matrix4x4.Perspective(FieldOfView, AspectRatio, NearClipPlane, FarClipPlane);
        }

        return perspectiveMatrix * viewMatrix;
    }


    // Update is called once per frame
    void Update()
    {
    }

#if UNITY_EDITOR
    // OnDrawGizmos在每帧调用，所有在OnDrawGizmos中渲染的gizmos都是可见的。
    // OnDrawGizmosSelected仅在脚本附加的物体被选中时调用。
    // public virtual void OnDrawGizmos()
    public virtual void OnDrawGizmosSelected()
    {
        // 用OnDrawGizmos时也可以用这个检测是否被选中
//      if (Selection.activeGameObject != gameObject)
//          return;

        Matrix4x4 temp = Gizmos.matrix;
        Gizmos.matrix = Matrix4x4.TRS(transform.position, transform.rotation, Vector3.one);
        if (Orthographic)
        {
            float spread = FarClipPlane - NearClipPlane;
            float center = (FarClipPlane + NearClipPlane) * 0.5f;
            Gizmos.DrawWireCube(new Vector3(0, 0, center), new Vector3(OrthographicSize * 2 * AspectRatio, OrthographicSize * 2, spread));
        }
        else
        {
            Gizmos.DrawFrustum(new Vector3(0, 0, NearClipPlane), FieldOfView, FarClipPlane, NearClipPlane, AspectRatio);
        }
        Gizmos.matrix = temp;
    }
#endif
}
