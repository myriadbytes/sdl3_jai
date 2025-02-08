// SDL_surface.h

/**
 * # CategorySurface
 *
 * SDL surfaces are buffers of pixels in system RAM. These are useful for
 * passing around and manipulating images that are not stored in GPU memory.
 *
 * SDL_Surface makes serious efforts to manage images in various formats, and
 * provides a reasonable toolbox for transforming the data, including copying
 * between surfaces, filling rectangles in the image data, etc.
 *
 * There is also a simple .bmp loader, SDL_LoadBMP(). SDL itself does not
 * provide loaders for various other file formats, but there are several
 * excellent external libraries that do, including its own satellite library,
 * SDL_image:
 *
 * https://github.com/libsdl-org/SDL_image
 */

/**
 * The flags on an SDL_Surface.
 *
 * These are generally considered read-only.
 *
 * \since This datatype is available since SDL 3.2.0.
 */
using SDL_SurfaceFlags :: enum_flags u32 
{
    SDL_SURFACE_PREALLOCATED    :: 0x00000001; /**< Surface uses preallocated pixel memory */
    SDL_SURFACE_LOCK_NEEDED     :: 0x00000002; /**< Surface needs to be locked to access pixels */
    SDL_SURFACE_LOCKED          :: 0x00000004; /**< Surface is currently locked */
    SDL_SURFACE_SIMD_ALIGNED    :: 0x00000008; /**< Surface uses pixel memory allocated with SDL_aligned_alloc() */
}

/**
 * Evaluates to true if the surface needs to be locked before access.
 *
 * \since This macro is available since SDL 3.2.0.
 */
SDL_MUSTLOCK :: inline (S: SDL_Surface) -> bool { return ((S.*.flags & SDL_SURFACE_LOCK_NEEDED) == SDL_SURFACE_LOCK_NEEDED); }

/**
 * The scaling mode.
 *
 * \since This enum is available since SDL 3.2.0.
 */
using SDL_ScaleMode :: enum u32
{
    SDL_SCALEMODE_NEAREST; /**< nearest pixel sampling */
    SDL_SCALEMODE_LINEAR;  /**< linear filtering */
}

/**
 * The flip mode.
 *
 * \since This enum is available since SDL 3.2.0.
 */
using SDL_FlipMode :: enum u32
{
    SDL_FLIP_NONE;          /**< Do not flip */
    SDL_FLIP_HORIZONTAL;    /**< flip horizontally */
    SDL_FLIP_VERTICAL;      /**< flip vertically */
}

/**
 * A collection of pixels used in software blitting.
 *
 * Pixels are arranged in memory in rows, with the top row first. Each row
 * occupies an amount of memory given by the pitch (sometimes known as the row
 * stride in non-SDL APIs).
 *
 * Within each row, pixels are arranged from left to right until the width is
 * reached. Each pixel occupies a number of bits appropriate for its format,
 * with most formats representing each pixel as one or more whole bytes (in
 * some indexed formats, instead multiple pixels are packed into each byte),
 * and a byte order given by the format. After encoding all pixels, any
 * remaining bytes to reach the pitch are used as padding to reach a desired
 * alignment, and have undefined contents.
 *
 * When a surface holds YUV format data, the planes are assumed to be
 * contiguous without padding between them, e.g. a 32x32 surface in NV12
 * format with a pitch of 32 would consist of 32x32 bytes of Y plane followed
 * by 32x16 bytes of UV plane.
 *
 * \since This struct is available since SDL 3.2.0.
 *
 * \sa SDL_CreateSurface
 * \sa SDL_DestroySurface
 */
SDL_Surface :: struct
{
    flags: SDL_SurfaceFlags;     /**< The flags of the surface, read-only */
    format: SDL_PixelFormat;     /**< The format of the surface, read-only */
    w: s32;                      /**< The width of the surface, read-only. */
    h: s32;                      /**< The height of the surface, read-only. */
    pitch: s32;                  /**< The distance in bytes between rows of pixels, read-only */
    pixels: *void;               /**< A pointer to the pixels of the surface, the pixels are writeable if non-NULL */

    refcount: s32;               /**< Application reference count, used when freeing surface */

    reserved: *void;             /**< Reserved for internal use */
};

/**
 * Allocate a new surface with a specific pixel format.
 *
 * The pixels of the new surface are initialized to zero.
 *
 * \param width the width of the surface.
 * \param height the height of the surface.
 * \param format the SDL_PixelFormat for the new surface's pixel format.
 * \returns the new SDL_Surface structure that is created or NULL on failure;
 *          call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_CreateSurfaceFrom
 * \sa SDL_DestroySurface
 */
SDL_CreateSurface :: (width: s32, height: s32, format: SDL_PixelFormat) -> *SDL_Surface #foreign SDL3;

/**
 * Allocate a new surface with a specific pixel format and existing pixel
 * data.
 *
 * No copy is made of the pixel data. Pixel data is not managed automatically;
 * you must free the surface before you free the pixel data.
 *
 * Pitch is the offset in bytes from one row of pixels to the next, e.g.
 * `width*4` for `SDL_PIXELFORMAT_RGBA8888`.
 *
 * You may pass NULL for pixels and 0 for pitch to create a surface that you
 * will fill in with valid values later.
 *
 * \param width the width of the surface.
 * \param height the height of the surface.
 * \param format the SDL_PixelFormat for the new surface's pixel format.
 * \param pixels a pointer to existing pixel data.
 * \param pitch the number of bytes between each row, including padding.
 * \returns the new SDL_Surface structure that is created or NULL on failure;
 *          call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_CreateSurface
 * \sa SDL_DestroySurface
 */
SDL_CreateSurfaceFrom :: (width: s32, height: s32, format: SDL_PixelFormat, pixels: *void, pitch: s32) -> *SDL_Surface #foreign SDL3;

/**
 * Free a surface.
 *
 * It is safe to pass NULL to this function.
 *
 * \param surface the SDL_Surface to free.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_CreateSurface
 * \sa SDL_CreateSurfaceFrom
 */
SDL_DestroySurface :: (surface: *SDL_Surface) -> void #foreign SDL3;

/**
 * Get the properties associated with a surface.
 *
 * The following properties are understood by SDL:
 *
 * - `SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT`: for HDR10 and floating point
 *   surfaces, this defines the value of 100% diffuse white, with higher
 *   values being displayed in the High Dynamic Range headroom. This defaults
 *   to 203 for HDR10 surfaces and 1.0 for floating point surfaces.
 * - `SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT`: for HDR10 and floating point
 *   surfaces, this defines the maximum dynamic range used by the content, in
 *   terms of the SDR white point. This defaults to 0.0, which disables tone
 *   mapping.
 * - `SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING`: the tone mapping operator
 *   used when compressing from a surface with high dynamic range to another
 *   with lower dynamic range. Currently this supports "chrome", which uses
 *   the same tone mapping that Chrome uses for HDR content, the form "*=N",
 *   where N is a floating point scale factor applied in linear space, and
 *   "none", which disables tone mapping. This defaults to "chrome".
 *
 * \param surface the SDL_Surface structure to query.
 * \returns a valid property ID on success or 0 on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_GetSurfaceProperties :: (surface: *SDL_Surface) -> SDL_PropertiesID #foreign SDL3;

SDL_PROP_SURFACE_SDR_WHITE_POINT_FLOAT              :: "SDL.surface.SDR_white_point";
SDL_PROP_SURFACE_HDR_HEADROOM_FLOAT                 :: "SDL.surface.HDR_headroom";
SDL_PROP_SURFACE_TONEMAP_OPERATOR_STRING            :: "SDL.surface.tonemap";

/**
 * Set the colorspace used by a surface.
 *
 * Setting the colorspace doesn't change the pixels, only how they are
 * interpreted in color operations.
 *
 * \param surface the SDL_Surface structure to update.
 * \param colorspace an SDL_Colorspace value describing the surface
 *                   colorspace.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceColorspace
 */
SDL_SetSurfaceColorspace :: (surface: *SDL_Surface, colorspace: SDL_Colorspace) -> bool #foreign SDL3;

/**
 * Get the colorspace used by a surface.
 *
 * The colorspace defaults to SDL_COLORSPACE_SRGB_LINEAR for floating point
 * formats, SDL_COLORSPACE_HDR10 for 10-bit formats, SDL_COLORSPACE_SRGB for
 * other RGB surfaces and SDL_COLORSPACE_BT709_FULL for YUV textures.
 *
 * \param surface the SDL_Surface structure to query.
 * \returns the colorspace used by the surface, or SDL_COLORSPACE_UNKNOWN if
 *          the surface is NULL.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfaceColorspace
 */
SDL_GetSurfaceColorspace :: (surface: *SDL_Surface) -> SDL_Colorspace #foreign SDL3;

/**
 * Create a palette and associate it with a surface.
 *
 * This function creates a palette compatible with the provided surface. The
 * palette is then returned for you to modify, and the surface will
 * automatically use the new palette in future operations. You do not need to
 * destroy the returned palette, it will be freed when the reference count
 * reaches 0, usually when the surface is destroyed.
 *
 * Bitmap surfaces (with format SDL_PIXELFORMAT_INDEX1LSB or
 * SDL_PIXELFORMAT_INDEX1MSB) will have the palette initialized with 0 as
 * white and 1 as black. Other surfaces will get a palette initialized with
 * white in every entry.
 *
 * If this function is called for a surface that already has a palette, a new
 * palette will be created to replace it.
 *
 * \param surface the SDL_Surface structure to update.
 * \returns a new SDL_Palette structure on success or NULL on failure (e.g. if
 *          the surface didn't have an index format); call SDL_GetError() for
 *          more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetPaletteColors
 */
SDL_CreateSurfacePalette :: (surface: *SDL_Surface) -> *SDL_Palette #foreign SDL3;

/**
 * Set the palette used by a surface.
 *
 * A single palette can be shared with many surfaces.
 *
 * \param surface the SDL_Surface structure to update.
 * \param palette the SDL_Palette structure to use.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_CreatePalette
 * \sa SDL_GetSurfacePalette
 */
SDL_SetSurfacePalette :: (surface: *SDL_Surface, palette: *SDL_Palette) -> bool #foreign SDL3;

/**
 * Get the palette used by a surface.
 *
 * \param surface the SDL_Surface structure to query.
 * \returns a pointer to the palette used by the surface, or NULL if there is
 *          no palette used.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfacePalette
 */
SDL_GetSurfacePalette :: (surface: *SDL_Surface) -> *SDL_Palette #foreign SDL3;

/**
 * Add an alternate version of a surface.
 *
 * This function adds an alternate version of this surface, usually used for
 * content with high DPI representations like cursors or icons. The size,
 * format, and content do not need to match the original surface, and these
 * alternate versions will not be updated when the original surface changes.
 *
 * This function adds a reference to the alternate version, so you should call
 * SDL_DestroySurface() on the image after this call.
 *
 * \param surface the SDL_Surface structure to update.
 * \param image a pointer to an alternate SDL_Surface to associate with this
 *              surface.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_RemoveSurfaceAlternateImages
 * \sa SDL_GetSurfaceImages
 * \sa SDL_SurfaceHasAlternateImages
 */
SDL_AddSurfaceAlternateImage :: (surface: *SDL_Surface, image: *SDL_Surface) -> bool #foreign SDL3;

/**
 * Return whether a surface has alternate versions available.
 *
 * \param surface the SDL_Surface structure to query.
 * \returns true if alternate versions are available or false otherwise.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_AddSurfaceAlternateImage
 * \sa SDL_RemoveSurfaceAlternateImages
 * \sa SDL_GetSurfaceImages
 */
SDL_SurfaceHasAlternateImages :: (surface: *SDL_Surface) -> bool #foreign SDL3;

/**
 * Get an array including all versions of a surface.
 *
 * This returns all versions of a surface, with the surface being queried as
 * the first element in the returned array.
 *
 * Freeing the array of surfaces does not affect the surfaces in the array.
 * They are still referenced by the surface being queried and will be cleaned
 * up normally.
 *
 * \param surface the SDL_Surface structure to query.
 * \param count a pointer filled in with the number of surface pointers
 *              returned, may be NULL.
 * \returns a NULL terminated array of SDL_Surface pointers or NULL on
 *          failure; call SDL_GetError() for more information. This should be
 *          freed with SDL_free() when it is no longer needed.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_AddSurfaceAlternateImage
 * \sa SDL_RemoveSurfaceAlternateImages
 * \sa SDL_SurfaceHasAlternateImages
 */
SDL_GetSurfaceImages :: (surface: *SDL_Surface, count: *s32) -> **SDL_Surface #foreign SDL3;

/**
 * Remove all alternate versions of a surface.
 *
 * This function removes a reference from all the alternative versions,
 * destroying them if this is the last reference to them.
 *
 * \param surface the SDL_Surface structure to update.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_AddSurfaceAlternateImage
 * \sa SDL_GetSurfaceImages
 * \sa SDL_SurfaceHasAlternateImages
 */
SDL_RemoveSurfaceAlternateImages :: (surface: *SDL_Surface) -> void #foreign SDL3;

/**
 * Set up a surface for directly accessing the pixels.
 *
 * Between calls to SDL_LockSurface() / SDL_UnlockSurface(), you can write to
 * and read from `surface->pixels`, using the pixel format stored in
 * `surface->format`. Once you are done accessing the surface, you should use
 * SDL_UnlockSurface() to release it.
 *
 * Not all surfaces require locking. If `SDL_MUSTLOCK(surface)` evaluates to
 * 0, then you can read and write to the surface at any time, and the pixel
 * format of the surface will not change.
 *
 * \param surface the SDL_Surface structure to be locked.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_MUSTLOCK
 * \sa SDL_UnlockSurface
 */
SDL_LockSurface :: (surface: *SDL_Surface) -> bool #foreign SDL3;

/**
 * Release a surface after directly accessing the pixels.
 *
 * \param surface the SDL_Surface structure to be unlocked.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_LockSurface
 */
SDL_UnlockSurface :: (surface: *SDL_Surface) -> void #foreign SDL3;

/**
 * Load a BMP image from a seekable SDL data stream.
 *
 * The new surface should be freed with SDL_DestroySurface(). Not doing so
 * will result in a memory leak.
 *
 * \param src the data stream for the surface.
 * \param closeio if true, calls SDL_CloseIO() on `src` before returning, even
 *                in the case of an error.
 * \returns a pointer to a new SDL_Surface structure or NULL on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_DestroySurface
 * \sa SDL_LoadBMP
 * \sa SDL_SaveBMP_IO
 */
// TODO(Lucas): Enable this after I have ported SDL_IOSTREAM
// SDL_LoadBMP_IO :: (src: *SDL_IOStream, closeio: bool) -> *SDL_Surface #foreign SDL3;

/**
 * Load a BMP image from a file.
 *
 * The new surface should be freed with SDL_DestroySurface(). Not doing so
 * will result in a memory leak.
 *
 * \param file the BMP file to load.
 * \returns a pointer to a new SDL_Surface structure or NULL on failure; call
 *          SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_DestroySurface
 * \sa SDL_LoadBMP_IO
 * \sa SDL_SaveBMP
 */
SDL_LoadBMP :: (file: *u8) -> *SDL_Surface #foreign SDL3;

/**
 * Save a surface to a seekable SDL data stream in BMP format.
 *
 * Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
 * BMP directly. Other RGB formats with 8-bit or higher get converted to a
 * 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
 * surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
 * not supported.
 *
 * \param surface the SDL_Surface structure containing the image to be saved.
 * \param dst a data stream to save to.
 * \param closeio if true, calls SDL_CloseIO() on `dst` before returning, even
 *                in the case of an error.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_LoadBMP_IO
 * \sa SDL_SaveBMP
 */
// TODO(Lucas): Enable this after I have ported SDL_IOSTREAM
// SDL_SaveBMP_IO :: (surface: *SDL_Surface, dst: *SDL_IOStream, closeio: bool) -> bool #foreign SDL3;

/**
 * Save a surface to a file.
 *
 * Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
 * BMP directly. Other RGB formats with 8-bit or higher get converted to a
 * 24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
 * surface before they are saved. YUV and paletted 1-bit and 4-bit formats are
 * not supported.
 *
 * \param surface the SDL_Surface structure containing the image to be saved.
 * \param file a file to save to.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_LoadBMP
 * \sa SDL_SaveBMP_IO
 */
SDL_SaveBMP :: (surface: *SDL_Surface, file: *u8) -> bool #foreign SDL3;

/**
 * Set the RLE acceleration hint for a surface.
 *
 * If RLE is enabled, color key and alpha blending blits are much faster, but
 * the surface must be locked before directly accessing the pixels.
 *
 * \param surface the SDL_Surface structure to optimize.
 * \param enabled true to enable RLE acceleration, false to disable it.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurface
 * \sa SDL_LockSurface
 * \sa SDL_UnlockSurface
 */
SDL_SetSurfaceRLE :: (surface: *SDL_Surface, enabled: bool) -> bool #foreign SDL3;

/**
 * Returns whether the surface is RLE enabled.
 *
 * It is safe to pass a NULL `surface` here; it will return false.
 *
 * \param surface the SDL_Surface structure to query.
 * \returns true if the surface is RLE enabled, false otherwise.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfaceRLE
 */
SDL_SurfaceHasRLE :: (surface: *SDL_Surface) -> bool #foreign SDL3;

/**
 * Set the color key (transparent pixel) in a surface.
 *
 * The color key defines a pixel value that will be treated as transparent in
 * a blit. For example, one can use this to specify that cyan pixels should be
 * considered transparent, and therefore not rendered.
 *
 * It is a pixel of the format used by the surface, as generated by
 * SDL_MapRGB().
 *
 * \param surface the SDL_Surface structure to update.
 * \param enabled true to enable color key, false to disable color key.
 * \param key the transparent pixel.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceColorKey
 * \sa SDL_SetSurfaceRLE
 * \sa SDL_SurfaceHasColorKey
 */
SDL_SetSurfaceColorKey :: (surface: *SDL_Surface, enabled: bool, key: u32) -> bool #foreign SDL3;

/**
 * Returns whether the surface has a color key.
 *
 * It is safe to pass a NULL `surface` here; it will return false.
 *
 * \param surface the SDL_Surface structure to query.
 * \returns true if the surface has a color key, false otherwise.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfaceColorKey
 * \sa SDL_GetSurfaceColorKey
 */
SDL_SurfaceHasColorKey :: (surface: *SDL_Surface) -> bool #foreign SDL3;

/**
 * Get the color key (transparent pixel) for a surface.
 *
 * The color key is a pixel of the format used by the surface, as generated by
 * SDL_MapRGB().
 *
 * If the surface doesn't have color key enabled this function returns false.
 *
 * \param surface the SDL_Surface structure to query.
 * \param key a pointer filled in with the transparent pixel.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfaceColorKey
 * \sa SDL_SurfaceHasColorKey
 */
SDL_GetSurfaceColorKey :: (surface: *SDL_Surface, key: *u32) -> bool #foreign SDL3;

/**
 * Set an additional color value multiplied into blit operations.
 *
 * When this surface is blitted, during the blit operation each source color
 * channel is modulated by the appropriate color value according to the
 * following formula:
 *
 * `srcC = srcC * (color / 255)`
 *
 * \param surface the SDL_Surface structure to update.
 * \param r the red color value multiplied into blit operations.
 * \param g the green color value multiplied into blit operations.
 * \param b the blue color value multiplied into blit operations.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceColorMod
 * \sa SDL_SetSurfaceAlphaMod
 */
SDL_SetSurfaceColorMod :: (surface: *SDL_Surface, r: u8, g: u8, b: u8) -> bool #foreign SDL3;


/**
 * Get the additional color value multiplied into blit operations.
 *
 * \param surface the SDL_Surface structure to query.
 * \param r a pointer filled in with the current red color value.
 * \param g a pointer filled in with the current green color value.
 * \param b a pointer filled in with the current blue color value.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceAlphaMod
 * \sa SDL_SetSurfaceColorMod
 */
SDL_GetSurfaceColorMod :: (surface: *SDL_Surface, r: *u8, g: *u8, b: *u8) -> bool #foreign SDL3;

/**
 * Set an additional alpha value used in blit operations.
 *
 * When this surface is blitted, during the blit operation the source alpha
 * value is modulated by this alpha value according to the following formula:
 *
 * `srcA = srcA * (alpha / 255)`
 *
 * \param surface the SDL_Surface structure to update.
 * \param alpha the alpha value multiplied into blit operations.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceAlphaMod
 * \sa SDL_SetSurfaceColorMod
 */
SDL_SetSurfaceAlphaMod :: (surface: *SDL_Surface, alpha: u8) -> bool #foreign SDL3;

/**
 * Get the additional alpha value used in blit operations.
 *
 * \param surface the SDL_Surface structure to query.
 * \param alpha a pointer filled in with the current alpha value.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceColorMod
 * \sa SDL_SetSurfaceAlphaMod
 */
SDL_GetSurfaceAlphaMod :: (surface: *SDL_Surface, alpha: *u8) -> bool #foreign SDL3;

/**
 * Set the blend mode used for blit operations.
 *
 * To copy a surface to another surface (or texture) without blending with the
 * existing data, the blendmode of the SOURCE surface should be set to
 * `SDL_BLENDMODE_NONE`.
 *
 * \param surface the SDL_Surface structure to update.
 * \param blendMode the SDL_BlendMode to use for blit blending.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceBlendMode
 */
SDL_SetSurfaceBlendMode :: (surface: *SDL_Surface, blendMode: SDL_BlendMode) -> bool #foreign SDL3;

/**
 * Get the blend mode used for blit operations.
 *
 * \param surface the SDL_Surface structure to query.
 * \param blendMode a pointer filled in with the current SDL_BlendMode.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfaceBlendMode
 */
SDL_GetSurfaceBlendMode :: (surface: *SDL_Surface, blendMode: *SDL_BlendMode) -> bool #foreign SDL3;

/**
 * Set the clipping rectangle for a surface.
 *
 * When `surface` is the destination of a blit, only the area within the clip
 * rectangle is drawn into.
 *
 * Note that blits are automatically clipped to the edges of the source and
 * destination surfaces.
 *
 * \param surface the SDL_Surface structure to be clipped.
 * \param rect the SDL_Rect structure representing the clipping rectangle, or
 *             NULL to disable clipping.
 * \returns true if the rectangle intersects the surface, otherwise false and
 *          blits will be completely clipped.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetSurfaceClipRect
 */
SDL_SetSurfaceClipRect :: (surface: *SDL_Surface, rect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Get the clipping rectangle for a surface.
 *
 * When `surface` is the destination of a blit, only the area within the clip
 * rectangle is drawn into.
 *
 * \param surface the SDL_Surface structure representing the surface to be
 *                clipped.
 * \param rect an SDL_Rect structure filled in with the clipping rectangle for
 *             the surface.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetSurfaceClipRect
 */
SDL_GetSurfaceClipRect :: (surface: *SDL_Surface, rect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Flip a surface vertically or horizontally.
 *
 * \param surface the surface to flip.
 * \param flip the direction to flip.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_FlipSurface :: (surface: *SDL_Surface, flip: SDL_FlipMode) -> bool #foreign SDL3;

/**
 * Creates a new surface identical to the existing surface.
 *
 * If the original surface has alternate images, the new surface will have a
 * reference to them as well.
 *
 * The returned surface should be freed with SDL_DestroySurface().
 *
 * \param surface the surface to duplicate.
 * \returns a copy of the surface or NULL on failure; call SDL_GetError() for
 *          more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_DestroySurface
 */
SDL_DuplicateSurface :: (surface: *SDL_Surface) -> *SDL_Surface #foreign SDL3;

/**
 * Creates a new surface identical to the existing surface, scaled to the
 * desired size.
 *
 * The returned surface should be freed with SDL_DestroySurface().
 *
 * \param surface the surface to duplicate and scale.
 * \param width the width of the new surface.
 * \param height the height of the new surface.
 * \param scaleMode the SDL_ScaleMode to be used.
 * \returns a copy of the surface or NULL on failure; call SDL_GetError() for
 *          more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_DestroySurface
 */
SDL_ScaleSurface :: (surface: *SDL_Surface, width: s32, height: s32, scaleMode: SDL_ScaleMode) -> *SDL_Surface #foreign SDL3;

/**
 * Copy an existing surface to a new surface of the specified format.
 *
 * This function is used to optimize images for faster *repeat* blitting. This
 * is accomplished by converting the original and storing the result as a new
 * surface. The new, optimized surface can then be used as the source for
 * future blits, making them faster.
 *
 * If you are converting to an indexed surface and want to map colors to a
 * palette, you can use SDL_ConvertSurfaceAndColorspace() instead.
 *
 * If the original surface has alternate images, the new surface will have a
 * reference to them as well.
 *
 * \param surface the existing SDL_Surface structure to convert.
 * \param format the new pixel format.
 * \returns the new SDL_Surface structure that is created or NULL on failure;
 *          call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_ConvertSurfaceAndColorspace
 * \sa SDL_DestroySurface
 */
SDL_ConvertSurface :: (surface: *SDL_Surface, format: SDL_PixelFormat) -> *SDL_Surface #foreign SDL3;

/**
 * Copy an existing surface to a new surface of the specified format and
 * colorspace.
 *
 * This function converts an existing surface to a new format and colorspace
 * and returns the new surface. This will perform any pixel format and
 * colorspace conversion needed.
 *
 * If the original surface has alternate images, the new surface will have a
 * reference to them as well.
 *
 * \param surface the existing SDL_Surface structure to convert.
 * \param format the new pixel format.
 * \param palette an optional palette to use for indexed formats, may be NULL.
 * \param colorspace the new colorspace.
 * \param props an SDL_PropertiesID with additional color properties, or 0.
 * \returns the new SDL_Surface structure that is created or NULL on failure;
 *          call SDL_GetError() for more information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_ConvertSurface
 * \sa SDL_DestroySurface
 */
SDL_ConvertSurfaceAndColorspace :: (surface: *SDL_Surface, format: SDL_PixelFormat, palette: *SDL_Palette, colorspace: SDL_Colorspace, props: SDL_PropertiesID) -> *SDL_Surface #foreign SDL3;

/**
 * Copy a block of pixels of one format to another format.
 *
 * \param width the width of the block to copy, in pixels.
 * \param height the height of the block to copy, in pixels.
 * \param src_format an SDL_PixelFormat value of the `src` pixels format.
 * \param src a pointer to the source pixels.
 * \param src_pitch the pitch of the source pixels, in bytes.
 * \param dst_format an SDL_PixelFormat value of the `dst` pixels format.
 * \param dst a pointer to be filled in with new pixel data.
 * \param dst_pitch the pitch of the destination pixels, in bytes.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_ConvertPixelsAndColorspace
 */
SDL_ConvertPixels :: (width: s32, height: s32, src_format: SDL_PixelFormat, src: *void, src_pitch: s32, dst_format: SDL_PixelFormat, dst: *void, dst_pitch: s32) -> bool #foreign SDL3;

/**
 * Copy a block of pixels of one format and colorspace to another format and
 * colorspace.
 *
 * \param width the width of the block to copy, in pixels.
 * \param height the height of the block to copy, in pixels.
 * \param src_format an SDL_PixelFormat value of the `src` pixels format.
 * \param src_colorspace an SDL_Colorspace value describing the colorspace of
 *                       the `src` pixels.
 * \param src_properties an SDL_PropertiesID with additional source color
 *                       properties, or 0.
 * \param src a pointer to the source pixels.
 * \param src_pitch the pitch of the source pixels, in bytes.
 * \param dst_format an SDL_PixelFormat value of the `dst` pixels format.
 * \param dst_colorspace an SDL_Colorspace value describing the colorspace of
 *                       the `dst` pixels.
 * \param dst_properties an SDL_PropertiesID with additional destination color
 *                       properties, or 0.
 * \param dst a pointer to be filled in with new pixel data.
 * \param dst_pitch the pitch of the destination pixels, in bytes.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_ConvertPixels
 */
SDL_ConvertPixelsAndColorspace :: (width: s32, height: s32, src_format: SDL_PixelFormat, src_colorspace: SDL_Colorspace, src_properties: SDL_PropertiesID, src: *void, src_pitch: s32, dst_format: SDL_PixelFormat, dst_colorspace: SDL_Colorspace, dst_properties: SDL_PropertiesID, dst: *void, dst_pitch: s32) -> bool #foreign SDL3;

/**
 * Premultiply the alpha on a block of pixels.
 *
 * This is safe to use with src == dst, but not for other overlapping areas.
 *
 * \param width the width of the block to convert, in pixels.
 * \param height the height of the block to convert, in pixels.
 * \param src_format an SDL_PixelFormat value of the `src` pixels format.
 * \param src a pointer to the source pixels.
 * \param src_pitch the pitch of the source pixels, in bytes.
 * \param dst_format an SDL_PixelFormat value of the `dst` pixels format.
 * \param dst a pointer to be filled in with premultiplied pixel data.
 * \param dst_pitch the pitch of the destination pixels, in bytes.
 * \param linear true to convert from sRGB to linear space for the alpha
 *               multiplication, false to do multiplication in sRGB space.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_PremultiplyAlpha :: (width: s32, height: s32, src_format: SDL_PixelFormat, src: *void, src_pitch: s32, dst_format: SDL_PixelFormat, dst: *void, dst_pitch: s32, linear: bool) -> bool #foreign SDL3;

/**
 * Premultiply the alpha in a surface.
 *
 * This is safe to use with src == dst, but not for other overlapping areas.
 *
 * \param surface the surface to modify.
 * \param linear true to convert from sRGB to linear space for the alpha
 *               multiplication, false to do multiplication in sRGB space.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_PremultiplySurfaceAlpha :: (surface: *SDL_Surface, linear: bool) -> bool #foreign SDL3;

/**
 * Clear a surface with a specific color, with floating point precision.
 *
 * This function handles all surface formats, and ignores any clip rectangle.
 *
 * If the surface is YUV, the color is assumed to be in the sRGB colorspace,
 * otherwise the color is assumed to be in the colorspace of the suface.
 *
 * \param surface the SDL_Surface to clear.
 * \param r the red component of the pixel, normally in the range 0-1.
 * \param g the green component of the pixel, normally in the range 0-1.
 * \param b the blue component of the pixel, normally in the range 0-1.
 * \param a the alpha component of the pixel, normally in the range 0-1.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_ClearSurface :: (surface: *SDL_Surface, r: float32, g: float32, b: float32, a: float32) -> bool #foreign SDL3;

/**
 * Perform a fast fill of a rectangle with a specific color.
 *
 * `color` should be a pixel of the format used by the surface, and can be
 * generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
 * alpha component then the destination is simply filled with that alpha
 * information, no blending takes place.
 *
 * If there is a clip rectangle set on the destination (set via
 * SDL_SetSurfaceClipRect()), then this function will fill based on the
 * intersection of the clip rectangle and `rect`.
 *
 * \param dst the SDL_Surface structure that is the drawing target.
 * \param rect the SDL_Rect structure representing the rectangle to fill, or
 *             NULL to fill the entire surface.
 * \param color the color to fill with.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_FillSurfaceRects
 */
SDL_FillSurfaceRect :: (dst: *SDL_Surface, rect: *SDL_Rect, color: u32) -> bool #foreign SDL3;

/**
 * Perform a fast fill of a set of rectangles with a specific color.
 *
 * `color` should be a pixel of the format used by the surface, and can be
 * generated by SDL_MapRGB() or SDL_MapRGBA(). If the color value contains an
 * alpha component then the destination is simply filled with that alpha
 * information, no blending takes place.
 *
 * If there is a clip rectangle set on the destination (set via
 * SDL_SetSurfaceClipRect()), then this function will fill based on the
 * intersection of the clip rectangle and `rect`.
 *
 * \param dst the SDL_Surface structure that is the drawing target.
 * \param rects an array of SDL_Rects representing the rectangles to fill.
 * \param count the number of rectangles in the array.
 * \param color the color to fill with.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_FillSurfaceRect
 */
SDL_FillSurfaceRects :: (dst: *SDL_Surface, rects: *SDL_Rect, count: s32, color: u32) -> bool #foreign SDL3;

/**
 * Performs a fast blit from the source surface to the destination surface
 * with clipping.
 *
 * If either `srcrect` or `dstrect` are NULL, the entire surface (`src` or
 * `dst`) is copied while ensuring clipping to `dst->clip_rect`.
 *
 * The final blit rectangles are saved in `srcrect` and `dstrect` after all
 * clipping is performed.
 *
 * The blit function should not be called on a locked surface.
 *
 * The blit semantics for surfaces with and without blending and colorkey are
 * defined as follows:
 *
 * ```
 *    RGBA->RGB:
 *      Source surface blend mode set to SDL_BLENDMODE_BLEND:
 *       alpha-blend (using the source alpha-channel and per-surface alpha)
 *       SDL_SRCCOLORKEY ignored.
 *     Source surface blend mode set to SDL_BLENDMODE_NONE:
 *       copy RGB.
 *       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
 *       RGB values of the source color key, ignoring alpha in the
 *       comparison.
 *
 *   RGB->RGBA:
 *     Source surface blend mode set to SDL_BLENDMODE_BLEND:
 *       alpha-blend (using the source per-surface alpha)
 *     Source surface blend mode set to SDL_BLENDMODE_NONE:
 *       copy RGB, set destination alpha to source per-surface alpha value.
 *     both:
 *       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
 *       source color key.
 *
 *   RGBA->RGBA:
 *     Source surface blend mode set to SDL_BLENDMODE_BLEND:
 *       alpha-blend (using the source alpha-channel and per-surface alpha)
 *       SDL_SRCCOLORKEY ignored.
 *     Source surface blend mode set to SDL_BLENDMODE_NONE:
 *       copy all of RGBA to the destination.
 *       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
 *       RGB values of the source color key, ignoring alpha in the
 *       comparison.
 *
 *   RGB->RGB:
 *     Source surface blend mode set to SDL_BLENDMODE_BLEND:
 *       alpha-blend (using the source per-surface alpha)
 *     Source surface blend mode set to SDL_BLENDMODE_NONE:
 *       copy RGB.
 *     both:
 *       if SDL_SRCCOLORKEY set, only copy the pixels that do not match the
 *       source color key.
 * ```
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, or NULL to copy the entire surface.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the x and y position in
 *                the destination surface, or NULL for (0,0). The width and
 *                height are ignored, and are copied from `srcrect`. If you
 *                want a specific width and height, you should use
 *                SDL_BlitSurfaceScaled().
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurfaceScaled
 */
SDL_BlitSurface :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Perform low-level surface blitting only.
 *
 * This is a semi-private blit function and it performs low-level surface
 * blitting, assuming the input rectangles have already been clipped.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, may not be NULL.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, may not be NULL.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurface
 */
SDL_BlitSurfaceUnchecked :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Perform a scaled blit to a destination surface, which may be of a different
 * format.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, or NULL to copy the entire surface.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, or NULL to fill the entire
 *                destination surface.
 * \param scaleMode the SDL_ScaleMode to be used.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurface
 */
SDL_BlitSurfaceScaled :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect, scaleMode: SDL_ScaleMode) -> bool #foreign SDL3;

/**
 * Perform low-level surface scaled blitting only.
 *
 * This is a semi-private function and it performs low-level surface blitting,
 * assuming the input rectangles have already been clipped.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, may not be NULL.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, may not be NULL.
 * \param scaleMode the SDL_ScaleMode to be used.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurfaceScaled
 */
SDL_BlitSurfaceUncheckedScaled :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect, scaleMode: SDL_ScaleMode) -> bool #foreign SDL3;

/**
 * Perform a stretched pixel copy from one surface to another.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, may not be NULL.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, may not be NULL.
 * \param scaleMode the SDL_ScaleMode to be used.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.4.0.
 *
 * \sa SDL_BlitSurfaceScaled
 */
SDL_StretchSurface :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect, scaleMode: SDL_ScaleMode) -> bool #foreign SDL3;

/**
 * Perform a tiled blit to a destination surface, which may be of a different
 * format.
 *
 * The pixels in `srcrect` will be repeated as many times as needed to
 * completely fill `dstrect`.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, or NULL to copy the entire surface.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, or NULL to fill the entire surface.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurface
 */
SDL_BlitSurfaceTiled :: (src: *SDL_Surface, srcrect: *SDL_Rect, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Perform a scaled and tiled blit to a destination surface, which may be of a
 * different format.
 *
 * The pixels in `srcrect` will be scaled and repeated as many times as needed
 * to completely fill `dstrect`.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be
 *                copied, or NULL to copy the entire surface.
 * \param scale the scale used to transform srcrect into the destination
 *              rectangle, e.g. a 32x32 texture with a scale of 2 would fill
 *              64x64 tiles.
 * \param scaleMode scale algorithm to be used.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, or NULL to fill the entire surface.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurface
 */
SDL_BlitSurfaceTiledWithScale :: (src: *SDL_Surface, srcrect: *SDL_Rect, scale: float32, scaleMode: SDL_ScaleMode, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Perform a scaled blit using the 9-grid algorithm to a destination surface,
 * which may be of a different format.
 *
 * The pixels in the source surface are split into a 3x3 grid, using the
 * different corner sizes for each corner, and the sides and center making up
 * the remaining pixels. The corners are then scaled using `scale` and fit
 * into the corners of the destination rectangle. The sides and center are
 * then stretched into place to cover the remaining destination rectangle.
 *
 * \param src the SDL_Surface structure to be copied from.
 * \param srcrect the SDL_Rect structure representing the rectangle to be used
 *                for the 9-grid, or NULL to use the entire surface.
 * \param left_width the width, in pixels, of the left corners in `srcrect`.
 * \param right_width the width, in pixels, of the right corners in `srcrect`.
 * \param top_height the height, in pixels, of the top corners in `srcrect`.
 * \param bottom_height the height, in pixels, of the bottom corners in
 *                      `srcrect`.
 * \param scale the scale used to transform the corner of `srcrect` into the
 *              corner of `dstrect`, or 0.0f for an unscaled blit.
 * \param scaleMode scale algorithm to be used.
 * \param dst the SDL_Surface structure that is the blit target.
 * \param dstrect the SDL_Rect structure representing the target rectangle in
 *                the destination surface, or NULL to fill the entire surface.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \threadsafety The same destination surface should not be used from two
 *               threads at once. It is safe to use the same source surface
 *               from multiple threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_BlitSurface
 */
SDL_BlitSurface9Grid :: (src: *SDL_Surface, srcrect: *SDL_Rect, left_width: s32, right_width: s32, top_height: s32, bottom_height: s32, scale: float32, scaleMode: SDL_ScaleMode, dst: *SDL_Surface, dstrect: *SDL_Rect) -> bool #foreign SDL3;

/**
 * Map an RGB triple to an opaque pixel value for a surface.
 *
 * This function maps the RGB color value to the specified pixel format and
 * returns the pixel value best approximating the given RGB color value for
 * the given pixel format.
 *
 * If the surface has a palette, the index of the closest matching color in
 * the palette will be returned.
 *
 * If the surface pixel format has an alpha component it will be returned as
 * all 1 bits (fully opaque).
 *
 * If the pixel format bpp (color depth) is less than 32-bpp then the unused
 * upper bits of the return value can safely be ignored (e.g., with a 16-bpp
 * format the return value can be assigned to a u16, and similarly a u8
 * for an 8-bpp format).
 *
 * \param surface the surface to use for the pixel format and palette.
 * \param r the red component of the pixel in the range 0-255.
 * \param g the green component of the pixel in the range 0-255.
 * \param b the blue component of the pixel in the range 0-255.
 * \returns a pixel value.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_MapSurfaceRGBA
 */
SDL_MapSurfaceRGB :: (surface: *SDL_Surface, r: u8, g: u8, b: u8) -> u32 #foreign SDL3;

/**
 * Map an RGBA quadruple to a pixel value for a surface.
 *
 * This function maps the RGBA color value to the specified pixel format and
 * returns the pixel value best approximating the given RGBA color value for
 * the given pixel format.
 *
 * If the surface pixel format has no alpha component the alpha value will be
 * ignored (as it will be in formats with a palette).
 *
 * If the surface has a palette, the index of the closest matching color in
 * the palette will be returned.
 *
 * If the pixel format bpp (color depth) is less than 32-bpp then the unused
 * upper bits of the return value can safely be ignored (e.g., with a 16-bpp
 * format the return value can be assigned to a u16, and similarly a u8
 * for an 8-bpp format).
 *
 * \param surface the surface to use for the pixel format and palette.
 * \param r the red component of the pixel in the range 0-255.
 * \param g the green component of the pixel in the range 0-255.
 * \param b the blue component of the pixel in the range 0-255.
 * \param a the alpha component of the pixel in the range 0-255.
 * \returns a pixel value.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_MapSurfaceRGB
 */
SDL_MapSurfaceRGBA :: (surface: *SDL_Surface, r: u8, g: u8, b: u8, a: u8) -> u32 #foreign SDL3;

/**
 * Retrieves a single pixel from a surface.
 *
 * This function prioritizes correctness over speed: it is suitable for unit
 * tests, but is not intended for use in a game engine.
 *
 * Like SDL_GetRGBA, this uses the entire 0..255 range when converting color
 * components from pixel formats with less than 8 bits per RGB component.
 *
 * \param surface the surface to read.
 * \param x the horizontal coordinate, 0 <= x < width.
 * \param y the vertical coordinate, 0 <= y < height.
 * \param r a pointer filled in with the red channel, 0-255, or NULL to ignore
 *          this channel.
 * \param g a pointer filled in with the green channel, 0-255, or NULL to
 *          ignore this channel.
 * \param b a pointer filled in with the blue channel, 0-255, or NULL to
 *          ignore this channel.
 * \param a a pointer filled in with the alpha channel, 0-255, or NULL to
 *          ignore this channel.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_ReadSurfacePixel :: (surface: *SDL_Surface, x: s32, y: s32, r: *u8, g: *u8, b: *u8, a: *u8) -> bool #foreign SDL3;

/**
 * Retrieves a single pixel from a surface.
 *
 * This function prioritizes correctness over speed: it is suitable for unit
 * tests, but is not intended for use in a game engine.
 *
 * \param surface the surface to read.
 * \param x the horizontal coordinate, 0 <= x < width.
 * \param y the vertical coordinate, 0 <= y < height.
 * \param r a pointer filled in with the red channel, normally in the range
 *          0-1, or NULL to ignore this channel.
 * \param g a pointer filled in with the green channel, normally in the range
 *          0-1, or NULL to ignore this channel.
 * \param b a pointer filled in with the blue channel, normally in the range
 *          0-1, or NULL to ignore this channel.
 * \param a a pointer filled in with the alpha channel, normally in the range
 *          0-1, or NULL to ignore this channel.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_ReadSurfacePixelFloat :: (surface: *SDL_Surface, x: s32, y: s32, r: *float32, g: *float32, b: *float32, a: *float32) -> bool #foreign SDL3;

/**
 * Writes a single pixel to a surface.
 *
 * This function prioritizes correctness over speed: it is suitable for unit
 * tests, but is not intended for use in a game engine.
 *
 * Like SDL_MapRGBA, this uses the entire 0..255 range when converting color
 * components from pixel formats with less than 8 bits per RGB component.
 *
 * \param surface the surface to write.
 * \param x the horizontal coordinate, 0 <= x < width.
 * \param y the vertical coordinate, 0 <= y < height.
 * \param r the red channel value, 0-255.
 * \param g the green channel value, 0-255.
 * \param b the blue channel value, 0-255.
 * \param a the alpha channel value, 0-255.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_WriteSurfacePixel :: (surface: *SDL_Surface, x: s32, y: s32, r: u8, g: u8, b: u8, a: u8) -> bool #foreign SDL3;

/**
 * Writes a single pixel to a surface.
 *
 * This function prioritizes correctness over speed: it is suitable for unit
 * tests, but is not intended for use in a game engine.
 *
 * \param surface the surface to write.
 * \param x the horizontal coordinate, 0 <= x < width.
 * \param y the vertical coordinate, 0 <= y < height.
 * \param r the red channel value, normally in the range 0-1.
 * \param g the green channel value, normally in the range 0-1.
 * \param b the blue channel value, normally in the range 0-1.
 * \param a the alpha channel value, normally in the range 0-1.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 */
SDL_WriteSurfacePixelFloat :: (surface: *SDL_Surface, x: s32, y: s32, r: float32, g: float32, b: float32, a: float32) -> bool #foreign SDL3;
