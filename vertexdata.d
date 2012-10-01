/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 */
module glade.vertexdata;

import derelict.opengl3.gl3;

///
final class VertexArrayObject
{
private:
    GLuint _id;
    static GLuint _s_boundId;
    
public:   
    /// 
    this()
    {
        glGenVertexArrays(1, &this._id);
    }
     
    /// 
    ~this()
    {
        glDeleteVertexArrays(1, &this._id);
    }
    
public:
    void bind() { glBindVertexArray(this._id); this._s_boundId = this._id; }

    void unbind() { glBindVertexArray(0); this._s_boundId = 0; }
    
    @property bool isBound() { return this._s_boundId == this._id; }
    
    //~ void attach(VertexBufferObject vbo)
    //~ {
        //~ if(!this.isBound) this.bind();
        //~ vbo.bind();
    //~ }
    
    //~ void detach(VertexBufferObject vbo)
    //~ {
        //~ if(!this.isBound) this.bind();
        //~ vbo.unbind();
    //~ }
}


 
/// 
final class VertexBufferObject
{
    enum Target
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

private:
    GLuint _id;
    static GLuint[Target] _s_boundId;
    
public:   
    /// 
    this()
    {
        glGenBuffers(1, &this._id);
    }
     
    /// 
    ~this()
    {
        glDeleteBuffers(1, &this._id);
    }
    
public:
    //~ void bind(Target target) { glBindBuffer(target, this._id); this._s_boundId = this._id; }
     
    //~ void unbind(Target target) { glBindBuffer(target, 0); this._s_boundId = 0; }
    
    //~ bool isBound(Target target) { return this._s_boundId[target] == this._id; }
    
    
    
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

