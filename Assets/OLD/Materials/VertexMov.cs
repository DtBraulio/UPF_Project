using UnityEngine;
using System.Collections;

public class VertexMov : MonoBehaviour {

    public Vector3 position_Vertex;
    public int selected_Vertex;
    public Vector3[] vertices;
    public Vector2[] uvs;
    //public Color[] vertices_Color;
    public Mesh mesh;
    public Texture2D testTexture;

    void Start()
    {
        selected_Vertex = 0;

        mesh = GetComponent<MeshFilter>().mesh;

        vertices = mesh.vertices;
        // vertices_Color = mesh.colors;

        uvs = new Vector2[vertices.Length];

        for (int i = 0; i < uvs.Length; i++)
        {
            uvs[i] = new Vector2(vertices[i].x, vertices[i].z);
        }

        mesh.uv = uvs;

        for (int i = 0; i < vertices.Length; i++)
        {
            Color currentColor = testTexture.GetPixel((int)uvs[i].x, (int)uvs[i].y);

            float currentHeight = currentColor.grayscale;

            currentHeight = (currentHeight - 0.5F) * 10F;

            position_Vertex = new Vector3(vertices[i].x, currentColor.grayscale * 10, vertices[i].z);

            Debug.Log(currentHeight);
            vertices[i] = position_Vertex;
        }


        mesh.vertices = vertices;
        // mesh.colors = vertices_Color;
        mesh.RecalculateBounds();

    }


}

