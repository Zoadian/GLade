pragma(lib, "DerelictGL3.lib");
pragma(lib, "DerelictIL.lib");
pragma(lib, "DerelictUtil.lib");

import glade.opengl;

int main() {
    Texture tex1;
    TextureUnit[42].Texture2D.bindTexture(tex1);    
    return 0;
    
    VertexArrayObject vao;
    VertexBufferObject vbo;
    
    vao[BufferTarget.ArrayBuffer] = vbo;
}