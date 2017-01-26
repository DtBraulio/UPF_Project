using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PostEffectScript : MonoBehaviour {


    public Material mat;
    
    void OnRenderImage( RenderTexture scr, RenderTexture destiny) 
    {
        Graphics.Blit(scr, destiny, mat);

    }
}
