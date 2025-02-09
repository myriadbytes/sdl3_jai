// SDL_stdinc.h
// NOTE(Lucas): This SDL header deals with a lot of C/C++ stuff, so I'm only porting the most relevant parts for now (i.e: math functions)

/**
 * # CategoryStdinc
 *
 * SDL provides its own implementation of some of the most important C runtime
 * functions.
 *
 * Using these functions allows an app to have access to common C
 * functionality without depending on a specific C runtime (or a C runtime at
 * all). More importantly, the SDL implementations work identically across
 * platforms, so apps can avoid surprises like snprintf() behaving differently
 * between Windows and Linux builds, or itoa() only existing on some
 * platforms.
 *
 * For many of the most common functions, like SDL_memcpy, SDL might just call
 * through to the usual C runtime behind the scenes, if it makes sense to do
 * so (if it's faster and always available/reliable on a given platform),
 * reducing library size and offering the most optimized option.
 *
 * SDL also offers other C-runtime-adjacent functionality in this header that
 * either isn't, strictly speaking, part of any C runtime standards, like
 * SDL_crc32() and SDL_reinterpret_cast, etc. It also offers a few better
 * options, like SDL_strlcpy(), which functions as a safer form of strcpy().
 */

/**
 * Define a four character code as a Uint32.
 *
 * \param A the first ASCII character.
 * \param B the second ASCII character.
 * \param C the third ASCII character.
 * \param D the fourth ASCII character.
 * \returns the four characters converted into a Uint32, one character
 *          per-byte.
 *
 * \threadsafety It is safe to call this macro from any thread.
 *
 * \since This macro is available since SDL 3.2.0.
 */
 
SDL_FOURCC :: inline (A: u8, B: u8, C: u8, D: u8) -> u32 {
    return A | (B << 8) | (C << 16) | (D << 24);
}

/**
 * Seeds the pseudo-random number generator.
 *
 * Reusing the seed number will cause SDL_rand_*() to repeat the same stream
 * of 'random' numbers.
 *
 * \param seed the value to use as a random number seed, or 0 to use
 *             SDL_GetPerformanceCounter().
 *
 * \threadsafety This should be called on the same thread that calls
 *               SDL_rand*()
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_rand
 * \sa SDL_rand_bits
 * \sa SDL_randf
 */
SDL_srand :: (seed: u64) -> void #foreign SDL3;

/**
 * Generate a pseudo-random number less than n for positive n
 *
 * The method used is faster and of better quality than `rand() % n`. Odds are
 * roughly 99.9% even for n = 1 million. Evenness is better for smaller n, and
 * much worse as n gets bigger.
 *
 * Example: to simulate a d6 use `SDL_rand(6) + 1` The +1 converts 0..5 to
 * 1..6
 *
 * If you want to generate a pseudo-random number in the full range of Sint32,
 * you should use: (Sint32)SDL_rand_bits()
 *
 * If you want reproducible output, be sure to initialize with SDL_srand()
 * first.
 *
 * There are no guarantees as to the quality of the random sequence produced,
 * and this should not be used for security (cryptography, passwords) or where
 * money is on the line (loot-boxes, casinos). There are many random number
 * libraries available with different characteristics and you should pick one
 * of those to meet any serious needs.
 *
 * \param n the number of possible outcomes. n must be positive.
 * \returns a random value in the range of [0 .. n-1].
 *
 * \threadsafety All calls should be made from a single thread
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_srand
 * \sa SDL_randf
 */
SDL_rand :: (n: s32) -> s32 #foreign SDL3;

/**
 * Generate a uniform pseudo-random floating point number less than 1.0
 *
 * If you want reproducible output, be sure to initialize with SDL_srand()
 * first.
 *
 * There are no guarantees as to the quality of the random sequence produced,
 * and this should not be used for security (cryptography, passwords) or where
 * money is on the line (loot-boxes, casinos). There are many random number
 * libraries available with different characteristics and you should pick one
 * of those to meet any serious needs.
 *
 * \returns a random value in the range of [0.0, 1.0).
 *
 * \threadsafety All calls should be made from a single thread
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_srand
 * \sa SDL_rand
 */
SDL_randf :: () -> float32 #foreign SDL3;

/**
 * Generate 32 pseudo-random bits.
 *
 * You likely want to use SDL_rand() to get a psuedo-random number instead.
 *
 * There are no guarantees as to the quality of the random sequence produced,
 * and this should not be used for security (cryptography, passwords) or where
 * money is on the line (loot-boxes, casinos). There are many random number
 * libraries available with different characteristics and you should pick one
 * of those to meet any serious needs.
 *
 * \returns a random value in the range of [0-SDL_MAX_UINT32].
 *
 * \threadsafety All calls should be made from a single thread
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_rand
 * \sa SDL_randf
 * \sa SDL_srand
 */
SDL_rand_bits :: () -> u32 #foreign SDL3;

/**
 * Generate a pseudo-random number less than n for positive n
 *
 * The method used is faster and of better quality than `rand() % n`. Odds are
 * roughly 99.9% even for n = 1 million. Evenness is better for smaller n, and
 * much worse as n gets bigger.
 *
 * Example: to simulate a d6 use `SDL_rand_r(state, 6) + 1` The +1 converts
 * 0..5 to 1..6
 *
 * If you want to generate a pseudo-random number in the full range of Sint32,
 * you should use: (Sint32)SDL_rand_bits_r(state)
 *
 * There are no guarantees as to the quality of the random sequence produced,
 * and this should not be used for security (cryptography, passwords) or where
 * money is on the line (loot-boxes, casinos). There are many random number
 * libraries available with different characteristics and you should pick one
 * of those to meet any serious needs.
 *
 * \param state a pointer to the current random number state, this may not be
 *              NULL.
 * \param n the number of possible outcomes. n must be positive.
 * \returns a random value in the range of [0 .. n-1].
 *
 * \threadsafety This function is thread-safe, as long as the state pointer
 *               isn't shared between threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_rand
 * \sa SDL_rand_bits_r
 * \sa SDL_randf_r
 */
SDL_rand_r :: (state: *u64, n: s32) -> s32 #foreign SDL3;

/**
 * Generate a uniform pseudo-random floating point number less than 1.0
 *
 * If you want reproducible output, be sure to initialize with SDL_srand()
 * first.
 *
 * There are no guarantees as to the quality of the random sequence produced,
 * and this should not be used for security (cryptography, passwords) or where
 * money is on the line (loot-boxes, casinos). There are many random number
 * libraries available with different characteristics and you should pick one
 * of those to meet any serious needs.
 *
 * \param state a pointer to the current random number state, this may not be
 *              NULL.
 * \returns a random value in the range of [0.0, 1.0).
 *
 * \threadsafety This function is thread-safe, as long as the state pointer
 *               isn't shared between threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_rand_bits_r
 * \sa SDL_rand_r
 * \sa SDL_randf
 */
SDL_randf_r :: (state: *u64) -> float32 #foreign SDL3;

/**
 * Generate 32 pseudo-random bits.
 *
 * You likely want to use SDL_rand_r() to get a psuedo-random number instead.
 *
 * There are no guarantees as to the quality of the random sequence produced,
 * and this should not be used for security (cryptography, passwords) or where
 * money is on the line (loot-boxes, casinos). There are many random number
 * libraries available with different characteristics and you should pick one
 * of those to meet any serious needs.
 *
 * \param state a pointer to the current random number state, this may not be
 *              NULL.
 * \returns a random value in the range of [0-SDL_MAX_UINT32].
 *
 * \threadsafety This function is thread-safe, as long as the state pointer
 *               isn't shared between threads.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_rand_r
 * \sa SDL_randf_r
 */
SDL_rand_bits_r :: (state: *u64) -> u32 #foreign SDL3;

/**
 * The value of Pi, as a double-precision floating point literal.
 *
 * \since This macro is available since SDL 3.2.0.
 *
 * \sa SDL_PI_F
 */
SDL_PI_D : float64 : 3.141592653589793238462643383279502884;      /**< pi (double) */

/**
 * The value of Pi, as a single-precision floating point literal.
 *
 * \since This macro is available since SDL 3.2.0.
 *
 * \sa SDL_PI_D
 */
SDL_PI_F : float32 : cast(float32, 3.141592653589793238462643383279502884);     /**< pi (float) */

/**
 * Compute the arc cosine of `x`.
 *
 * The definition of `y = acos(x)` is `x = cos(y)`.
 *
 * Domain: `-1 <= x <= 1`
 *
 * Range: `0 <= y <= Pi`
 *
 * This function operates on double-precision floating point values, use
 * SDL_acosf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns arc cosine of `x`, in radians.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_acosf
 * \sa SDL_asin
 * \sa SDL_cos
 */
SDL_acos :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the arc cosine of `x`.
 *
 * The definition of `y = acos(x)` is `x = cos(y)`.
 *
 * Domain: `-1 <= x <= 1`
 *
 * Range: `0 <= y <= Pi`
 *
 * This function operates on single-precision floating point values, use
 * SDL_acos for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns arc cosine of `x`, in radians.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_acos
 * \sa SDL_asinf
 * \sa SDL_cosf
 */
SDL_acosf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the arc sine of `x`.
 *
 * The definition of `y = asin(x)` is `x = sin(y)`.
 *
 * Domain: `-1 <= x <= 1`
 *
 * Range: `-Pi/2 <= y <= Pi/2`
 *
 * This function operates on double-precision floating point values, use
 * SDL_asinf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns arc sine of `x`, in radians.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_asinf
 * \sa SDL_acos
 * \sa SDL_sin
 */
SDL_asin :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the arc sine of `x`.
 *
 * The definition of `y = asin(x)` is `x = sin(y)`.
 *
 * Domain: `-1 <= x <= 1`
 *
 * Range: `-Pi/2 <= y <= Pi/2`
 *
 * This function operates on single-precision floating point values, use
 * SDL_asin for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns arc sine of `x`, in radians.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_asin
 * \sa SDL_acosf
 * \sa SDL_sinf
 */
SDL_asinf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the arc tangent of `x`.
 *
 * The definition of `y = atan(x)` is `x = tan(y)`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-Pi/2 <= y <= Pi/2`
 *
 * This function operates on double-precision floating point values, use
 * SDL_atanf for single-precision floats.
 *
 * To calculate the arc tangent of y / x, use SDL_atan2.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns arc tangent of of `x` in radians, or 0 if `x = 0`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_atanf
 * \sa SDL_atan2
 * \sa SDL_tan
 */
SDL_atan :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the arc tangent of `x`.
 *
 * The definition of `y = atan(x)` is `x = tan(y)`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-Pi/2 <= y <= Pi/2`
 *
 * This function operates on single-precision floating point values, use
 * SDL_atan for dboule-precision floats.
 *
 * To calculate the arc tangent of y / x, use SDL_atan2f.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns arc tangent of of `x` in radians, or 0 if `x = 0`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_atan
 * \sa SDL_atan2f
 * \sa SDL_tanf
 */
SDL_atanf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the arc tangent of `y / x`, using the signs of x and y to adjust
 * the result's quadrant.
 *
 * The definition of `z = atan2(x, y)` is `y = x tan(z)`, where the quadrant
 * of z is determined based on the signs of x and y.
 *
 * Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
 *
 * Range: `-Pi/2 <= y <= Pi/2`
 *
 * This function operates on double-precision floating point values, use
 * SDL_atan2f for single-precision floats.
 *
 * To calculate the arc tangent of a single value, use SDL_atan.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param y floating point value of the numerator (y coordinate).
 * \param x floating point value of the denominator (x coordinate).
 * \returns arc tangent of of `y / x` in radians, or, if `x = 0`, either
 *          `-Pi/2`, `0`, or `Pi/2`, depending on the value of `y`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_atan2f
 * \sa SDL_atan
 * \sa SDL_tan
 */
SDL_atan2 :: (y: float64, x: float64) -> float64 #foreign SDL3;

/**
 * Compute the arc tangent of `y / x`, using the signs of x and y to adjust
 * the result's quadrant.
 *
 * The definition of `z = atan2(x, y)` is `y = x tan(z)`, where the quadrant
 * of z is determined based on the signs of x and y.
 *
 * Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
 *
 * Range: `-Pi/2 <= y <= Pi/2`
 *
 * This function operates on single-precision floating point values, use
 * SDL_atan2 for double-precision floats.
 *
 * To calculate the arc tangent of a single value, use SDL_atanf.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param y floating point value of the numerator (y coordinate).
 * \param x floating point value of the denominator (x coordinate).
 * \returns arc tangent of of `y / x` in radians, or, if `x = 0`, either
 *          `-Pi/2`, `0`, or `Pi/2`, depending on the value of `y`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_atan2
 * \sa SDL_atan
 * \sa SDL_tan
 */
SDL_atan2f :: (y: float32, x: float32) -> float32 #foreign SDL3;

/**
 * Compute the ceiling of `x`.
 *
 * The ceiling of `x` is the smallest integer `y` such that `y > x`, i.e `x`
 * rounded up to the nearest integer.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on double-precision floating point values, use
 * SDL_ceilf for single-precision floats.
 *
 * \param x floating point value.
 * \returns the ceiling of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_ceilf
 * \sa SDL_floor
 * \sa SDL_trunc
 * \sa SDL_round
 * \sa SDL_lround
 */
SDL_ceil :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the ceiling of `x`.
 *
 * The ceiling of `x` is the smallest integer `y` such that `y > x`, i.e `x`
 * rounded up to the nearest integer.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on single-precision floating point values, use
 * SDL_ceil for double-precision floats.
 *
 * \param x floating point value.
 * \returns the ceiling of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_ceil
 * \sa SDL_floorf
 * \sa SDL_truncf
 * \sa SDL_roundf
 * \sa SDL_lroundf
 */
SDL_ceilf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Copy the sign of one floating-point value to another.
 *
 * The definition of copysign is that ``copysign(x, y) = abs(x) * sign(y)``.
 *
 * Domain: `-INF <= x <= INF`, ``-INF <= y <= f``
 *
 * Range: `-INF <= z <= INF`
 *
 * This function operates on double-precision floating point values, use
 * SDL_copysignf for single-precision floats.
 *
 * \param x floating point value to use as the magnitude.
 * \param y floating point value to use as the sign.
 * \returns the floating point value with the sign of y and the magnitude of
 *          x.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_copysignf
 * \sa SDL_fabs
 */
SDL_copysign :: (x: float64, y: float64) -> float64 #foreign SDL3;

/**
 * Copy the sign of one floating-point value to another.
 *
 * The definition of copysign is that ``copysign(x, y) = abs(x) * sign(y)``.
 *
 * Domain: `-INF <= x <= INF`, ``-INF <= y <= f``
 *
 * Range: `-INF <= z <= INF`
 *
 * This function operates on single-precision floating point values, use
 * SDL_copysign for double-precision floats.
 *
 * \param x floating point value to use as the magnitude.
 * \param y floating point value to use as the sign.
 * \returns the floating point value with the sign of y and the magnitude of
 *          x.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_copysign
 * \sa SDL_fabsf
 */
SDL_copysignf :: (x: float32, y: float32) -> float32 #foreign SDL3;

/**
 * Compute the cosine of `x`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-1 <= y <= 1`
 *
 * This function operates on double-precision floating point values, use
 * SDL_cosf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value, in radians.
 * \returns cosine of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_cosf
 * \sa SDL_acos
 * \sa SDL_sin
 */
SDL_cos :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the cosine of `x`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-1 <= y <= 1`
 *
 * This function operates on single-precision floating point values, use
 * SDL_cos for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value, in radians.
 * \returns cosine of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_cos
 * \sa SDL_acosf
 * \sa SDL_sinf
 */
SDL_cosf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the exponential of `x`.
 *
 * The definition of `y = exp(x)` is `y = e^x`, where `e` is the base of the
 * natural logarithm. The inverse is the natural logarithm, SDL_log.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * The output will overflow if `exp(x)` is too large to be represented.
 *
 * This function operates on double-precision floating point values, use
 * SDL_expf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns value of `e^x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_expf
 * \sa SDL_log
 */
SDL_exp :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the exponential of `x`.
 *
 * The definition of `y = exp(x)` is `y = e^x`, where `e` is the base of the
 * natural logarithm. The inverse is the natural logarithm, SDL_logf.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * The output will overflow if `exp(x)` is too large to be represented.
 *
 * This function operates on single-precision floating point values, use
 * SDL_exp for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value.
 * \returns value of `e^x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_exp
 * \sa SDL_logf
 */
SDL_expf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the absolute value of `x`
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * This function operates on double-precision floating point values, use
 * SDL_fabsf for single-precision floats.
 *
 * \param x floating point value to use as the magnitude.
 * \returns the absolute value of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_fabsf
 */
SDL_fabs :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the absolute value of `x`
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * This function operates on single-precision floating point values, use
 * SDL_fabs for double-precision floats.
 *
 * \param x floating point value to use as the magnitude.
 * \returns the absolute value of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_fabs
 */
SDL_fabsf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the floor of `x`.
 *
 * The floor of `x` is the largest integer `y` such that `y > x`, i.e `x`
 * rounded down to the nearest integer.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on double-precision floating point values, use
 * SDL_floorf for single-precision floats.
 *
 * \param x floating point value.
 * \returns the floor of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_floorf
 * \sa SDL_ceil
 * \sa SDL_trunc
 * \sa SDL_round
 * \sa SDL_lround
 */
SDL_floor :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the floor of `x`.
 *
 * The floor of `x` is the largest integer `y` such that `y > x`, i.e `x`
 * rounded down to the nearest integer.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on single-precision floating point values, use
 * SDL_floor for double-precision floats.
 *
 * \param x floating point value.
 * \returns the floor of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_floor
 * \sa SDL_ceilf
 * \sa SDL_truncf
 * \sa SDL_roundf
 * \sa SDL_lroundf
 */
SDL_floorf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Truncate `x` to an integer.
 *
 * Rounds `x` to the next closest integer to 0. This is equivalent to removing
 * the fractional part of `x`, leaving only the integer part.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on double-precision floating point values, use
 * SDL_truncf for single-precision floats.
 *
 * \param x floating point value.
 * \returns `x` truncated to an integer.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_truncf
 * \sa SDL_fmod
 * \sa SDL_ceil
 * \sa SDL_floor
 * \sa SDL_round
 * \sa SDL_lround
 */
SDL_trunc :: (x: float64) -> float64 #foreign SDL3;

/**
 * Truncate `x` to an integer.
 *
 * Rounds `x` to the next closest integer to 0. This is equivalent to removing
 * the fractional part of `x`, leaving only the integer part.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on single-precision floating point values, use
 * SDL_trunc for double-precision floats.
 *
 * \param x floating point value.
 * \returns `x` truncated to an integer.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_trunc
 * \sa SDL_fmodf
 * \sa SDL_ceilf
 * \sa SDL_floorf
 * \sa SDL_roundf
 * \sa SDL_lroundf
 */
SDL_truncf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Return the floating-point remainder of `x / y`
 *
 * Divides `x` by `y`, and returns the remainder.
 *
 * Domain: `-INF <= x <= INF`, `-INF <= y <= INF`, `y != 0`
 *
 * Range: `-y <= z <= y`
 *
 * This function operates on double-precision floating point values, use
 * SDL_fmodf for single-precision floats.
 *
 * \param x the numerator.
 * \param y the denominator. Must not be 0.
 * \returns the remainder of `x / y`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_fmodf
 * \sa SDL_modf
 * \sa SDL_trunc
 * \sa SDL_ceil
 * \sa SDL_floor
 * \sa SDL_round
 * \sa SDL_lround
 */
SDL_fmod :: (x: float64, y: float64) -> float64 #foreign SDL3;

/**
 * Return the floating-point remainder of `x / y`
 *
 * Divides `x` by `y`, and returns the remainder.
 *
 * Domain: `-INF <= x <= INF`, `-INF <= y <= INF`, `y != 0`
 *
 * Range: `-y <= z <= y`
 *
 * This function operates on single-precision floating point values, use
 * SDL_fmod for double-precision floats.
 *
 * \param x the numerator.
 * \param y the denominator. Must not be 0.
 * \returns the remainder of `x / y`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_fmod
 * \sa SDL_truncf
 * \sa SDL_modff
 * \sa SDL_ceilf
 * \sa SDL_floorf
 * \sa SDL_roundf
 * \sa SDL_lroundf
 */
SDL_fmodf :: (x: float32, y: float32) -> float32 #foreign SDL3;

/**
 * Return whether the value is infinity.
 *
 * \param x double-precision floating point value.
 * \returns non-zero if the value is infinity, 0 otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_isinff
 */
SDL_isinf :: (x: float64) -> int #foreign SDL3;

/**
 * Return whether the value is infinity.
 *
 * \param x floating point value.
 * \returns non-zero if the value is infinity, 0 otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_isinf
 */
SDL_isinff :: (x: float32) -> int #foreign SDL3;

/**
 * Return whether the value is NaN.
 *
 * \param x double-precision floating point value.
 * \returns non-zero if the value is NaN, 0 otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_isnanf
 */
SDL_isnan :: (x: float64) -> int #foreign SDL3;

/**
 * Return whether the value is NaN.
 *
 * \param x floating point value.
 * \returns non-zero if the value is NaN, 0 otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_isnan
 */
SDL_isnanf :: (x: float32) -> int #foreign SDL3;

/**
 * Compute the natural logarithm of `x`.
 *
 * Domain: `0 < x <= INF`
 *
 * Range: `-INF <= y <= INF`
 *
 * It is an error for `x` to be less than or equal to 0.
 *
 * This function operates on double-precision floating point values, use
 * SDL_logf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value. Must be greater than 0.
 * \returns the natural logarithm of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_logf
 * \sa SDL_log10
 * \sa SDL_exp
 */
SDL_log :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the natural logarithm of `x`.
 *
 * Domain: `0 < x <= INF`
 *
 * Range: `-INF <= y <= INF`
 *
 * It is an error for `x` to be less than or equal to 0.
 *
 * This function operates on single-precision floating point values, use
 * SDL_log for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value. Must be greater than 0.
 * \returns the natural logarithm of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_log
 * \sa SDL_expf
 */
SDL_logf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the base-10 logarithm of `x`.
 *
 * Domain: `0 < x <= INF`
 *
 * Range: `-INF <= y <= INF`
 *
 * It is an error for `x` to be less than or equal to 0.
 *
 * This function operates on double-precision floating point values, use
 * SDL_log10f for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value. Must be greater than 0.
 * \returns the logarithm of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_log10f
 * \sa SDL_log
 * \sa SDL_pow
 */
SDL_log10 :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the base-10 logarithm of `x`.
 *
 * Domain: `0 < x <= INF`
 *
 * Range: `-INF <= y <= INF`
 *
 * It is an error for `x` to be less than or equal to 0.
 *
 * This function operates on single-precision floating point values, use
 * SDL_log10 for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value. Must be greater than 0.
 * \returns the logarithm of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_log10
 * \sa SDL_logf
 * \sa SDL_powf
 */
SDL_log10f :: (x: float32) -> float32 #foreign SDL3;

/**
 * Split `x` into integer and fractional parts
 *
 * This function operates on double-precision floating point values, use
 * SDL_modff for single-precision floats.
 *
 * \param x floating point value.
 * \param y output pointer to store the integer part of `x`.
 * \returns the fractional part of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_modff
 * \sa SDL_trunc
 * \sa SDL_fmod
 */
SDL_modf :: (x: float64, y: *float64) -> float64 #foreign SDL3;

/**
 * Split `x` into integer and fractional parts
 *
 * This function operates on single-precision floating point values, use
 * SDL_modf for double-precision floats.
 *
 * \param x floating point value.
 * \param y output pointer to store the integer part of `x`.
 * \returns the fractional part of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_modf
 * \sa SDL_truncf
 * \sa SDL_fmodf
 */
SDL_modff :: (x: float32, y: *float32) -> float32 #foreign SDL3;

/**
 * Raise `x` to the power `y`
 *
 * Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
 *
 * Range: `-INF <= z <= INF`
 *
 * If `y` is the base of the natural logarithm (e), consider using SDL_exp
 * instead.
 *
 * This function operates on double-precision floating point values, use
 * SDL_powf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x the base.
 * \param y the exponent.
 * \returns `x` raised to the power `y`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_powf
 * \sa SDL_exp
 * \sa SDL_log
 */
SDL_pow :: (x: float64, y: float64) -> float64 #foreign SDL3;

/**
 * Raise `x` to the power `y`
 *
 * Domain: `-INF <= x <= INF`, `-INF <= y <= INF`
 *
 * Range: `-INF <= z <= INF`
 *
 * If `y` is the base of the natural logarithm (e), consider using SDL_exp
 * instead.
 *
 * This function operates on single-precision floating point values, use
 * SDL_pow for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x the base.
 * \param y the exponent.
 * \returns `x` raised to the power `y`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_pow
 * \sa SDL_expf
 * \sa SDL_logf
 */
SDL_powf :: (x: float32, y: float32) -> float32 #foreign SDL3;

/**
 * Round `x` to the nearest integer.
 *
 * Rounds `x` to the nearest integer. Values halfway between integers will be
 * rounded away from zero.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on double-precision floating point values, use
 * SDL_roundf for single-precision floats. To get the result as an integer
 * type, use SDL_lround.
 *
 * \param x floating point value.
 * \returns the nearest integer to `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_roundf
 * \sa SDL_lround
 * \sa SDL_floor
 * \sa SDL_ceil
 * \sa SDL_trunc
 */
SDL_round :: (x: float64) -> float64 #foreign SDL3;

/**
 * Round `x` to the nearest integer.
 *
 * Rounds `x` to the nearest integer. Values halfway between integers will be
 * rounded away from zero.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`, y integer
 *
 * This function operates on single-precision floating point values, use
 * SDL_round for double-precision floats. To get the result as an integer
 * type, use SDL_lroundf.
 *
 * \param x floating point value.
 * \returns the nearest integer to `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_round
 * \sa SDL_lroundf
 * \sa SDL_floorf
 * \sa SDL_ceilf
 * \sa SDL_truncf
 */
SDL_roundf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Scale `x` by an integer power of two.
 *
 * Multiplies `x` by the `n`th power of the floating point radix (always 2).
 *
 * Domain: `-INF <= x <= INF`, `n` integer
 *
 * Range: `-INF <= y <= INF`
 *
 * This function operates on double-precision floating point values, use
 * SDL_scalbnf for single-precision floats.
 *
 * \param x floating point value to be scaled.
 * \param n integer exponent.
 * \returns `x * 2^n`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_scalbnf
 * \sa SDL_pow
 */
SDL_scalbn :: (x: float64, n: s32) -> float64 #foreign SDL3;

/**
 * Scale `x` by an integer power of two.
 *
 * Multiplies `x` by the `n`th power of the floating point radix (always 2).
 *
 * Domain: `-INF <= x <= INF`, `n` integer
 *
 * Range: `-INF <= y <= INF`
 *
 * This function operates on single-precision floating point values, use
 * SDL_scalbn for double-precision floats.
 *
 * \param x floating point value to be scaled.
 * \param n integer exponent.
 * \returns `x * 2^n`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_scalbn
 * \sa SDL_powf
 */
SDL_scalbnf :: (x: float32, n: s32) -> float32 #foreign SDL3;

/**
 * Compute the sine of `x`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-1 <= y <= 1`
 *
 * This function operates on double-precision floating point values, use
 * SDL_sinf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value, in radians.
 * \returns sine of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_sinf
 * \sa SDL_asin
 * \sa SDL_cos
 */
SDL_sin :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the sine of `x`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-1 <= y <= 1`
 *
 * This function operates on single-precision floating point values, use
 * SDL_sin for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value, in radians.
 * \returns sine of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_sin
 * \sa SDL_asinf
 * \sa SDL_cosf
 */
SDL_sinf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the square root of `x`.
 *
 * Domain: `0 <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * This function operates on double-precision floating point values, use
 * SDL_sqrtf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value. Must be greater than or equal to 0.
 * \returns square root of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_sqrtf
 */
SDL_sqrt :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the square root of `x`.
 *
 * Domain: `0 <= x <= INF`
 *
 * Range: `0 <= y <= INF`
 *
 * This function operates on single-precision floating point values, use
 * SDL_sqrt for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value. Must be greater than or equal to 0.
 * \returns square root of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_sqrt
 */
SDL_sqrtf :: (x: float32) -> float32 #foreign SDL3;

/**
 * Compute the tangent of `x`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`
 *
 * This function operates on double-precision floating point values, use
 * SDL_tanf for single-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value, in radians.
 * \returns tangent of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_tanf
 * \sa SDL_sin
 * \sa SDL_cos
 * \sa SDL_atan
 * \sa SDL_atan2
 */
SDL_tan :: (x: float64) -> float64 #foreign SDL3;

/**
 * Compute the tangent of `x`.
 *
 * Domain: `-INF <= x <= INF`
 *
 * Range: `-INF <= y <= INF`
 *
 * This function operates on single-precision floating point values, use
 * SDL_tan for double-precision floats.
 *
 * This function may use a different approximation across different versions,
 * platforms and configurations. i.e, it can return a different value given
 * the same input on different machines or operating systems, or if SDL is
 * updated.
 *
 * \param x floating point value, in radians.
 * \returns tangent of `x`.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_tan
 * \sa SDL_sinf
 * \sa SDL_cosf
 * \sa SDL_atanf
 * \sa SDL_atan2f
 */
SDL_tanf :: (x: float32) -> float32 #foreign SDL3;
