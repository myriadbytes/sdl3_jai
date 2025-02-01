// SDL_version.h

/**
 * # CategoryVersion
 *
 * Functionality to query the current SDL version, both as headers the app was
 * compiled against, and a library the app is linked to.
 */

/**
 * Get the version of SDL that is linked against your program.
 *
 * If you are linking to SDL dynamically, then it is possible that the current
 * version will be different than the version you compiled against. This
 * function returns the current version, while SDL_VERSION is the version you
 * compiled with.
 *
 * This function may be called safely at any time, even before SDL_Init().
 *
 * \returns the version of the linked library.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GetRevision
 */
SDL_GetVersion :: () -> s32 #foreign SDL3;
