/**
 * Authors: Felix Hufnagel
 * Copyright: Felix Hufnagel
 */
module glade.image;

import derelict.opengl3.gl3;

struct Color
{
private:
    float[4] _rgba;
    
public:
    this(float r, float g, float b, float a)
    {
        assert(r >= 0 && r <= 1); 
        assert(g >= 0 && g <= 1); 
        assert(b >= 0 && b <= 1); 
        assert(a >= 0 && a <= 1);    
        this._rgba = [r,g,b,a];
    }
    
public:    
    @property auto data(){ return this._rgba; }
    @property auto r(){ return this._rgba[0]; }
    @property auto g(){ return this._rgba[1]; }
    @property auto b(){ return this._rgba[2]; }
    @property auto a(){ return this._rgba[3]; }
}




///
final class Image
{
public:
    enum BaseFormat : GLenum 
    {
        Depth = GL_DEPTH_COMPONENT,
        Depth_Stencil = GL_DEPTH_STENCIL,
        Red = GL_RED,
        RG = GL_RG,
        RGB = GL_RGB,
        RGBA = GL_RGBA,
    }
    
    
    enum SizedFormat : GLenum
    {
    //    LUMINANCE8 = GL_LUMINANCE, ///1byte per pixel RGBA all the same
    //    LUMINANCE32F = GL_LUMINANCE32F_ARB,///1 float for RGBA
    //    LUMINANCE_ALPHA8 = GL_LUMINANCE_ALPHA,///1byte for RGB, 1 byte for alpha
        R16F = GL_R16F,///16 bit float for red
        R32F = GL_R32F,///32 bit float for red 
        RGB8 = GL_RGB8,///ubyte for R, G and B 
        RGB16 = GL_RGB16,///ushort for R, G and B 
        RGB16F = GL_RGB16F,///16bit float for R, G and B 
        RGB32F = GL_RGB32F,///32bit float for R, G and B 
        RGBA8 = GL_RGBA8,///ubyte for R, G, B and Alpha 
        RGBA16 = GL_RGBA16,///ushort for R, G, B and Alpha 
        RGBA16F = GL_RGBA16F,///16 bit float for R, G, B and Alpha 
        RGBA32F = GL_RGBA32F,///32 bit float for R, G, B and Alpha 
        DEPTH16 = GL_DEPTH_COMPONENT16,///16 bit uint depth 
        DEPTH24 = GL_DEPTH_COMPONENT24,///24 bit uint depth 
        DEPTH32 = GL_DEPTH_COMPONENT32,///32 bit uint depth 
        DEPTH24STENCIL = GL_DEPTH24_STENCIL8,///24 bit uint depth , ubyte stencil
    }
    
    
    enum Component : GLenum 
    {
        UByte       = GL_UNSIGNED_BYTE,
        UShort      = GL_UNSIGNED_SHORT,
        UInt        = GL_UNSIGNED_INT,
        UInt_24_8   = GL_UNSIGNED_INT_24_8, 
        Float       = GL_FLOAT
    }
    
private:
    Size _size;
    ubyte[] _data;
    BaseFormat _baseFormat;
    SizedFormat _sizedFormat;
    Component _component;
    
public:
    this()
    {}
    
    ~this()
    {}
    
public:
    @property Size size() const { return this._size; }
    @property size_t bitsPerPixel() const { return 0; } //TODO:
    @property BaseFormat baseFormat() const { return this._baseFormat; }
    @property SizedFormat sizedFormat() const { return this._sizedFormat; }
    //bool empty() const { return (m_Data is null); }
}