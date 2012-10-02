/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 
 VertexArrayObject vao;
 VertexBufferObject vbo;
 
 vao[ArrayBuffer] = vbo;
 */
module glade.vertexdata;

import derelict.opengl3.gl3;


enum BufferTarget
{
    ArrayBuffer = GL_ARRAY_BUFFER, 
    AtomicCounterBuffer = GL_ATOMIC_COUNTER_BUFFER, 
    CopyReadBuffer= GL_COPY_READ_BUFFER, 
    CopyWriteBuffer = GL_COPY_WRITE_BUFFER, 
    DrawIndirectBuffer = GL_DRAW_INDIRECT_BUFFER, 
    ElementArrayBuffer = GL_ELEMENT_ARRAY_BUFFER, 
    PixelPackBuffer = GL_PIXEL_PACK_BUFFER, 
    PixelUnpackBuffer = GL_PIXEL_UNPACK_BUFFER, 
    TextureBuffer = GL_TEXTURE_BUFFER, 
    TransformFeedbackBuffer = GL_TRANSFORM_FEEDBACK_BUFFER,
    UniformBuffer = GL_UNIFORM_BUFFER
    //TODO: opengl4: DispatchIndirectBuffer = GL_DISPATCH_INDIRECT_BUFFER, 
    //TODO: opengl4: ShaderStorageBuffer = GL_SHADER_STORAGE_BUFFER
}

///
alias VertexArrayObject VAO;
final class VertexArrayObject
{    
private:
    GLuint _id;
    static VertexArrayObject _s_curBoundVAO = null;
    static VertexBufferObject[BufferTarget] _s_curBoundVBO = null;
    
public:   
    /// 
    this() nothrow {
        glGenVertexArrays(1, &this._id);
    }
     
    /// 
    ~this() {
        glDeleteVertexArrays(1, &this._id);
    }
    
public:
    void bind() nothrow { glBindVertexArray(this._id); this._s_curBoundVAO = this; }

    void unbind() nothrow { glBindVertexArray(0); this._s_curBoundVAO = null; }
    
    @property bool isBound() const @safe nothrow { return this._s_curBoundVAO is this; }
    
    auto opIndexAssign(VertexBufferObject vbo, BufferTarget target) nothrow {
        if(!this.isBound) { 
            this.bind();
        }
        if(vbo is null) {
            glBindBuffer(target, vbo._id); 
            _s_curBoundVBO[target] = vbo;
        } else {
            glBindBuffer(target, 0);
            _s_curBoundVBO[target] = null;
        }
    }
}


///
VertexArrayObject getCurBoundVAO() @safe nothrow { 
    return VertexArrayObject._s_curBoundVAO; 
}


///
VertexBufferObject getCurBoundVBO(BufferTarget target) @safe nothrow { 
    return VertexArrayObject._s_curBoundVBO[target]; 
}  

 
/// 
alias VertexBufferObject VBO;
final class VertexBufferObject
{
private:
    GLuint _id;
    
public:   
    /// 
    this() {
        glGenBuffers(1, &this._id);
    }
     
    /// 
    ~this() {
        glDeleteBuffers(1, &this._id);
    }
    
public:
    bool isBound(BufferTarget target) { 
        return getCurBoundVBO(target) is this; 
    }
    
    //TODO:
    //glBufferData
    //glBufferSubData
    //glCopyBufferSubData
    //glGetBufferParameter
    //glGetBufferPointerv
    //glGetBufferSubData
    
}






class Vertexdata
{
	this()
	{
		// Constructor code
	}
}

