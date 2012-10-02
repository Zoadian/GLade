/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 */
module glade.render;

import derelict.opengl3.gl3;


///RenderBuffer
final class RenderBuffer
{
private:
    GLuint _id;
    static GLuint _s_boundId;

public:    
    this() { glGenRenderbuffers(1, &this._id); }        
    ~this() { glDeleteRenderbuffers(1, &this._id); } 
    
public:     
    void bind() { glBindRenderbuffer(GL_RENDERBUFFER, this._id); this._s_boundId = this._id; }
    
    void unbind(){ glBindRenderbuffer(GL_RENDERBUFFER, 0); this._s_boundId = 0; }    
    
    @property bool isBound() { return this._s_boundId == this._id; }
    
    //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glRenderbufferStorageMultisample.xml
    //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glRenderbufferStorage.xml
    
    
    //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glGetRenderbufferParameter.xml
//    @property uint width() {}
//    @property uint height() {}
//    @property uint internalFormat() {}
//    @property uint redSize() {}
//    @property uint greenSize() {}
//    @property uint blueSize() {}
//    @property uint alphaSize() {}
//    @property uint depthSize() {}
//    @property uint stencilSize() {}
//    @property uint samples() {}
}

///FrameBuffer
final class FrameBuffer
{
    enum Target : GLenum
    {
        Read = GL_DRAW_FRAMEBUFFER,
        Write = GL_READ_FRAMEBUFFER,
        Both = GL_FRAMEBUFFER
    }
    
private:
    GLuint _id;
    static GLuint[Target] _s_boundId;
    
public:
    this() { glDeleteFramebuffers(1, &this._id); }        
    ~this() { glDeleteFramebuffers(1, &this._id); }    
    
public:
    void bind(Target target) { glBindFramebuffer(target, this._id); this._s_boundId[target] = this._id;}    
    
    void unbind(Target target) { glBindFramebuffer(target, 0); this._s_boundId[target] = 0;}
        
    bool isBound(Target target) { return this._s_boundId[target] == this._id; }
    
    enum Status : GLenum
    {
        Complete = GL_FRAMEBUFFER_COMPLETE,
        Error = 0,
        Undefines = GL_FRAMEBUFFER_UNDEFINED,
        IncompleteAttachment = GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT,
        IncompleteMissingAttachment = GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT,
        IncompleteDrawBuffer = GL_FRAMEBUFFER_INCOMPLETE_DRAW_BUFFER,
        IncompleteReadBuffer = GL_FRAMEBUFFER_INCOMPLETE_READ_BUFFER,
        Unsupported = GL_FRAMEBUFFER_UNSUPPORTED,
        IncompleteMultisample = GL_FRAMEBUFFER_INCOMPLETE_MULTISAMPLE,        
        IncompleteLayerTargets = GL_FRAMEBUFFER_INCOMPLETE_LAYER_TARGETS
    }
    
    static Status status(Target target)
    {
        return cast(Status)glCheckFramebufferStatus(target);
    }    
    
    version(OpenGL4)
    {
        void defaultWidth(Target target, uint width) { glFramebufferParameteri(target, GL_FRAMEBUFFER_DEFAULT_WIDTH, width); }
        uint defaultWidth(Target target) { GLint width; glGetFramebufferParameteriv(target, GL_FRAMEBUFFER_DEFAULT_WIDTH, &width); }
        
        void defaultHeight(Target target, uint height) { glFramebufferParameteri(target, GL_FRAMEBUFFER_DEFAULT_HEIGHT, height); }
        uint defaultWidth(Target target) { GLint height; glGetFramebufferParameteriv(target, GL_FRAMEBUFFER_DEFAULT_HEIGHT, &height); }
        
        void defaultLayers(Target target, uint layers) { glFramebufferParameteri(target, GL_FRAMEBUFFER_DEFAULT_LAYERS, layers); }
        uint defaultWidth(Target target) { GLint layers; glGetFramebufferParameteriv(target, GL_FRAMEBUFFER_DEFAULT_LAYERS, &layers); }
        
        void defaultSamles(Target target, uint samples) { glFramebufferParameteri(target, GL_FRAMEBUFFER_DEFAULT_SAMPLES, samples); }
        uint defaultWidth(Target target) { GLint samples; glGetFramebufferParameteriv(target, GL_FRAMEBUFFER_DEFAULT_SAMPLES, &samples); }
        
        void defaultFixedSampleLocations(Target target, uint fixedSampleLocations) { glFramebufferParameteri(target, GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS, fixedSampleLocations); }
        uint defaultFixedSampleLocations(Target target) { GLint fixedSampleLocations; glGetFramebufferParameteriv(target, GL_FRAMEBUFFER_DEFAULT_FIXED_SAMPLE_LOCATIONS, &fixedSampleLocations); }
    }
//    /// make sure this framebuffer is bound!
//    void attach(RenderBuffer renderBuffer)
//    {
//        static assert(false, "not implemented yet.");
//        //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glFramebufferRenderbuffer.xml
//    }
//    
//    /// make sure this framebuffer is bound!
//    void attach(Texture texture)
//    {
//        static assert(false, "not implemented yet.");
//        //TODO: http://www.opengl.org/sdk/docs/man3/xhtml/glFramebufferTexture.xml
//    }
//    
//    /// make sure this framebuffer is bound!
//    void attach(TextureLayer textureLayer)
//    {
//        static assert(false, "not implemented yet.");
//        //TODO: http://www.opengl.org/sdk/docs/man3/xhtml/glFramebufferTextureLayer.xml
//    }
    
    //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glInvalidateFramebuffer.xml
    //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glInvalidateSubFramebuffer.xml    
    //TODO: http://www.opengl.org/sdk/docs/man4/xhtml/glGetFramebufferAttachmentParameter.xml
}    

///maxDrawBuffers
int maxDrawBuffers()
{
    int maxDrawBuffers;
    glGetIntegerv(GL_MAX_DRAW_BUFFERS, &maxDrawBuffers);
    return maxDrawBuffers;
}

///maxColorBuffers
int maxColorBuffers()
{
    int maxColorBuffers;
    glGetIntegerv(GL_MAX_COLOR_ATTACHMENTS, &maxColorBuffers);
    return maxColorBuffers;
}


//~ //##################### DEPRECATED BELOW


//~ interface IRenderer
//~ {
    //~ void render(IRenderTarget target, SceneNode rootNode, Camera camera);
//~ }


//~ interface IRenderTarget
//~ {
    //~ void clear();
    //~ void show();
//~ }


//~ final class DeferredRenderer : IRenderer
//~ {
//~ public:
    //~ this()
    //~ {}
    
//~ public:
    //~ void render(IRenderTarget target, SceneNode rootNode, Camera camera)
    //~ {
        //~ target.clear();
        //~ target.show();
    //~ }
    
    //~ void renderAttributeStage()
    //~ {}
    
    //~ void renderDeferredStage()
    //~ {}
//~ }

//~ class DeferredRenderTarget
//~ {	    
    //~ struct RenderTargetPart
    //~ {
        //~ enum BufferType 
        //~ {
            //~ Depth,
            //~ Stencil,
            //~ Color,
            //~ DepthTexture
        //~ }
        
        //~ BufferType type;
    //~ }
    
//~ private:
    //~ GLuint _fbo;
    //~ Texture _depthBuffer;
    //~ Texture[] _colorBuffers;
    //~ bool _isInitialised;

//~ public:
    //~ this()
    //~ {     
    //~ }
    
    //~ ~this()
    //~ {        
        //~ if(this._fbo)
            //~ glDeleteFramebuffers(1, &this._fbo);
    //~ }
    
//~ public:    
    //~ void init(RenderTargetPart[] renderTargetParts)
    //~ {        
        //~ assert(!this._isInitialised);
        //~ // Create the Framebuffer
        //~ glGenFramebuffers(1, &this._fbo); 
        //~ glBindFramebuffer(GL_DRAW_FRAMEBUFFER, this._fbo);
        //~ scope(exit){ glBindFramebuffer(GL_DRAW_FRAMEBUFFER, 0); } 
        
        //~ foreach(i, target; renderTargetParts)
        //~ {
            //~ final switch(target.type)
            //~ {
            //~ case RenderTargetPart.BufferType.Depth:
                //~ //TODO:
                //~ break;
            //~ case RenderTargetPart.BufferType.Stencil:
                //~ //TODO:
                //~ break;
            //~ case RenderTargetPart.BufferType.Color:
                //~ //TODO:
                //~ break;
            //~ case RenderTargetPart.BufferType.DepthTexture:
                //~ //TODO:
                //~ break;
            //~ }
        //~ }
        //~ this._isInitialised = true;
    //~ }

//~ private:
    
    //~ @property void targets(size_t[] targets)
    //~ {
        
    //~ }
//~ }