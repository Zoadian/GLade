/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 * 
 * Wraps OpenGL texture calls into an OO-like API
 * 
 * Texture tex1;
 * TextureUnit[42].Texture2D.bindTexture(tex1); 
 * 
 * which should be rewritten as:
 * 
 * glActiveTexture(GL_TEXTURE0 + 42);
 * glBindTexture(Texture2D, tex1._id);
 * 
 * TODO: i have yet to check asm if speed is optimal...
 * TODO: check commented functions, check openGL2-4 compatibility
 */
module glade.texture;

import std.conv;

import derelict.opengl3.gl3;

import glade.image;

version(OpenGL4){
    enum StencilTextureMode {
        DepthComponent = GL_DEPTH_COMPONENT,
        //TODO: StencilComponent = GL_STENCIL_COMPONENT
    }
}

enum CompareFunction {
    LessOrEqual = GL_LEQUAL,
    GreaterOrEqual = GL_GEQUAL,
    Less = GL_LESS,
    Greater = GL_GREATER,
    Equal = GL_EQUAL,
    NotEqual = GL_NOTEQUAL,
    Always = GL_ALWAYS,
    Never = GL_NEVER       
}

enum CompareMode {
    CompareRefToTexture = GL_COMPARE_REF_TO_TEXTURE,
    None = GL_NONE
}

enum MinFilter {
    Nearest = GL_NEAREST,
    Linear = GL_LINEAR,
    NearestMipmapNearest = GL_NEAREST_MIPMAP_NEAREST,
    LinearMipmapNearest = GL_LINEAR_MIPMAP_NEAREST,
    NearestMipmapLinear = GL_NEAREST_MIPMAP_LINEAR,
    LinearMipmapLinear = GL_LINEAR_MIPMAP_LINEAR        
}

enum MagFilter {
    Nearest = GL_NEAREST,
    Linear = GL_LINEAR     
}

enum Swizzle {
    Red = GL_RED, 
    Green = GL_GREEN, 
    Blue = GL_BLUE, 
    Alpha = GL_ALPHA, 
    Zero = GL_ZERO,
    One = GL_ONE
}

enum Wrap {
    ClampToEdge = GL_CLAMP_TO_EDGE, 
    ClampToBorder = GL_CLAMP_TO_BORDER, 
    MirroredRepeat = GL_MIRRORED_REPEAT,
    Repeat = GL_REPEAT
}

///
struct TextureUnit {
private:
    @disable this();
    @disable this(this); 
public:
    static auto opIndex(size_t texUnit) {
        assert(texUnit + 1 < GL_MAX_COMBINED_TEXTURE_IMAGE_UNITS);
        glActiveTexture(GL_TEXTURE0 + texUnit);
        return TextureUnitImpl();
    }
}

private struct TextureUnitImpl {
private:
    @disable this();
    @disable this(this);    
    template _mapTextureTarget(string op) {
        static if(op == "Texture1D") enum _mapTextureTarget = GL_TEXTURE_1D;
        else static if(op == "Texture2D") enum _mapTextureTarget  = GL_TEXTURE_2D;
        else static if(op == "Texture3D") enum _mapTextureTarget  = GL_TEXTURE_3D;
        else static if(op == "TextureArray1D") enum _mapTextureTarget  = GL_TEXTURE_1D_ARRAY;
        else static if(op == "TextureArray2D") enum _mapTextureTarget  = GL_TEXTURE_2D_ARRAY;        
        else static if(op == "TextureRactangle") enum _mapTextureTarget  = GL_TEXTURE_RECTANGLE; 
        else static if(op == "TextureCubeMap") enum _mapTextureTarget  = GL_TEXTURE_CUBE_MAP; 
        else static if(op == "Texture2DMultisample") enum _mapTextureTarget  = GL_TEXTURE_2D_MULTISAMPLE;
        else static if(op == "Texture2dMultisampleArray") enum _mapTextureTarget  = GL_TEXTURE_2D_MULTISAMPLE_ARRAY;
        else {
            static assert(false, op ~ " is not a valid TextureTarget!");
        }
    }
public:
    auto opDispatch(string op)() if (_mapTextureTarget!op) {
        return TextureTarget!(_mapTextureTarget!op)();
    }
}

///
struct TextureTarget(GLenum texTarget)
{
    Texture _boundTexture = null;
    enum _enTexTgt = texTarget;
    @disable this();
    @disable this(this);
public:      
    alias _enTexTgt this;
    
    void bindTexture(Texture texture) { glBindTexture(_enTexTgt, texture._id); this._boundTexture = texture;}
    
    void unbindTexture() { glBindTexture(_enTexTgt, 0); this._boundTexture = null; }
    
    Texture boundTexture() { return this._boundTexture; }
    
    
    version(OpenGL4) {
        @property void depthStencilTextureMode(StencilTextureMode opt) {
            glTexParameteri(_enTexTgt, GL_DEPTH_STENCIL_TEXTURE_MODE, opt); 
        }
        
        @property StencilTextureMode depthStencilTextureMode(Target target) {             
            StencilTextureMode opt;
            glGetTexParameteri(_enTexTgt, GL_DEPTH_STENCIL_TEXTURE_MODE, &opt); 
            return opt;
        }
    }
    
    @property void baseLevel(int opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_BASE_LEVEL, opt); 
    }
    @property int baseLevel() {
        int opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_BASE_LEVEL, &opt); 
        return opt;
    }
     
    @property void borderColor(Color color) {
        glTexParameterfv(_enTexTgt, GL_TEXTURE_BORDER_COLOR, color.data.ptr);
    }
    @property Color borderColor() {
        Color color;
        glGetTexParameterfv(_enTexTgt, GL_TEXTURE_BORDER_COLOR, color.data.ptr);
        return color;
    }
    
    @property void compareFunction(CompareFunction opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_COMPARE_FUNC, opt); 
    }
    @property CompareFunction compareFunction() {
        CompareFunction opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_COMPARE_FUNC, cast(int*)&opt); 
        return opt;
    }
    
    @property void compareMode(CompareMode opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_COMPARE_MODE, opt); 
    }
    @property int compareMode() {
        CompareMode opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_COMPARE_MODE, cast(int*)&opt); 
        return opt;
    }
    
    @property void lodBias(float opt) {
        glTexParameterf(_enTexTgt, GL_TEXTURE_LOD_BIAS, opt);    
    }
    @property float lodBias() {
        float opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_LOD_BIAS, cast(int*)&opt); 
        return opt;
    }

    @property void minFilter(MinFilter opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_MIN_FILTER, opt);    
    }
    @property MinFilter minFilter() {
        MinFilter opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_MIN_FILTER, cast(int*)&opt); 
        return opt;
    }
    
    @property void magFilter(MagFilter opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_MAG_FILTER, opt);    
    }
    @property MagFilter magFilter() {
        MagFilter opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_MAG_FILTER, cast(int*)&opt); 
        return opt;
    }
    
    @property void minLod(int opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_MIN_LOD, opt);    
    }
    @property int minLod() {
        int opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_MIN_LOD, cast(int*)&opt); 
        return opt;
    }
    
    @property void maxLod(int opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_MAX_LOD, opt);    
    }
    @property int maxLod() {
        int opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_MAX_LOD, cast(int*)&opt); 
        return opt;
    }
    
    @property void maxLevel(int opt) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_MAX_LEVEL, opt);    
    }
    @property int maxLevel() {
        int opt;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_MAX_LEVEL, cast(int*)&opt); 
        return opt;
    }
    
    void setSwizzle(Swizzle r, Swizzle g, Swizzle b, Swizzle a) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_SWIZZLE_R, r); 
        glTexParameteri(_enTexTgt, GL_TEXTURE_SWIZZLE_G, g); 
        glTexParameteri(_enTexTgt, GL_TEXTURE_SWIZZLE_B, b); 
        glTexParameteri(_enTexTgt, GL_TEXTURE_SWIZZLE_A, a);    
    }
    void getSwizzle(out Swizzle r, out Swizzle g, out Swizzle b, out Swizzle a) {
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_SWIZZLE_R, cast(int*)&r);
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_SWIZZLE_G, cast(int*)&g);
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_SWIZZLE_B, cast(int*)&b);
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_SWIZZLE_A, cast(int*)&a);
    }
    @property void swizzle(Swizzle rgba) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_SWIZZLE_RGBA, rgba);    
    }
    @property Swizzle swizzle() {
        Swizzle rgba;
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_SWIZZLE_R, cast(int*)&rgba);
        return rgba;
    }
    
    void setWrap(Wrap s, Wrap t, Wrap r) {
        glTexParameteri(_enTexTgt, GL_TEXTURE_WRAP_S, s); 
        glTexParameteri(_enTexTgt, GL_TEXTURE_WRAP_T, t); 
        glTexParameteri(_enTexTgt, GL_TEXTURE_WRAP_R, r);  
    }
    void getWrap(out Wrap s, out Wrap t, out Wrap r) {
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_WRAP_S, cast(int*)&s);
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_WRAP_T, cast(int*)&t);
        glGetTexParameteriv(_enTexTgt, GL_TEXTURE_WRAP_R, cast(int*)&r);
    }
}


final class TextureLayer {
    //whatever this will be?!
}


final class Texture {
    GLuint _id;
}

