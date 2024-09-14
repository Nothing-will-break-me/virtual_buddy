using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureChanger : MonoBehaviour
{
    int textureCounter = 0;
    Renderer textureRenderer;

    public List<Texture> textures;
    
    // Start is called before the first frame update
    void Start()
    {
        textureRenderer = GetComponent<Renderer>();
        textureRenderer.material.SetTexture("_MainTex", textures[0]);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void NextTexture(string x) {
        textureCounter += 1;
        if (textureCounter >= textures.Count) {
            textureCounter = 0;
        }
        textureRenderer?.material.SetTexture("_MainTex", textures[textureCounter]);
    }
}
