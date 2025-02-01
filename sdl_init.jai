// SDL_init.h

/**
 * Initialization flags for SDL_Init and/or SDL_InitSubSystem
 *
 * These are the flags which may be passed to SDL_Init(). You should specify
 * the subsystems which you will be using in your application.
 *
 * \since This datatype is available since SDL 3.2.0.
 *
 * \sa SDL_Init
 * \sa SDL_Quit
 * \sa SDL_InitSubSystem
 * \sa SDL_QuitSubSystem
 * \sa SDL_WasInit
 */
using SDL_InitFlags :: enum_flags u32
{
    SDL_INIT_AUDIO      :: 0x00000010; /* < `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
    SDL_INIT_VIDEO      :: 0x00000020; /* < `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS`, should be initialized on the main thread */
    SDL_INIT_JOYSTICK   :: 0x00000200; /* < `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS`, should be initialized on the same thread as SDL_INIT_VIDEO on Windows if you don't set SDL_HINT_JOYSTICK_THREAD */
    SDL_INIT_HAPTIC     :: 0x00001000;
    SDL_INIT_GAMEPAD    :: 0x00002000; /* < `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
    SDL_INIT_EVENTS     :: 0x00004000;
    SDL_INIT_SENSOR     :: 0x00008000; /* < `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
    SDL_INIT_CAMERA     :: 0x00010000; /* < `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
}

/**
 * Initialize the SDL library.
 *
 * SDL_Init() simply forwards to calling SDL_InitSubSystem(). Therefore, the
 * two may be used interchangeably. Though for readability of your code
 * SDL_InitSubSystem() might be preferred.
 *
 * The file I/O (for example: SDL_IOFromFile) and threading (SDL_CreateThread)
 * subsystems are initialized by default. Message boxes
 * (SDL_ShowSimpleMessageBox) also attempt to work without initializing the
 * video subsystem, in hopes of being useful in showing an error dialog when
 * SDL_Init fails. You must specifically initialize other subsystems if you
 * use them in your application.
 *
 * Logging (such as SDL_Log) works without initialization, too.
 *
 * `flags` may be any of the following OR'd together:
 *
 * - `SDL_INIT_AUDIO`: audio subsystem; automatically initializes the events
 *   subsystem
 * - `SDL_INIT_VIDEO`: video subsystem; automatically initializes the events
 *   subsystem, should be initialized on the main thread.
 * - `SDL_INIT_JOYSTICK`: joystick subsystem; automatically initializes the
 *   events subsystem
 * - `SDL_INIT_HAPTIC`: haptic (force feedback) subsystem
 * - `SDL_INIT_GAMEPAD`: gamepad subsystem; automatically initializes the
 *   joystick subsystem
 * - `SDL_INIT_EVENTS`: events subsystem
 * - `SDL_INIT_SENSOR`: sensor subsystem; automatically initializes the events
 *   subsystem
 * - `SDL_INIT_CAMERA`: camera subsystem; automatically initializes the events
 *   subsystem
 *
 * Subsystem initialization is ref-counted, you must call SDL_QuitSubSystem()
 * for each SDL_InitSubSystem() to correctly shutdown a subsystem manually (or
 * call SDL_Quit() to force shutdown). If a subsystem is already loaded then
 * this call will increase the ref-count and return.
 *
 * Consider reporting some basic metadata about your application before
 * calling SDL_Init, using either SDL_SetAppMetadata() or
 * SDL_SetAppMetadataProperty().
 *
 * \param flags subsystem initialization flags.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_SetAppMetadata
 * \sa SDL_SetAppMetadataProperty
 * \sa SDL_InitSubSystem
 * \sa SDL_Quit
 * \sa SDL_SetMainReady
 * \sa SDL_WasInit
 */
SDL_Init :: (flags: SDL_InitFlags) -> bool #foreign SDL3;

/**
 * Compatibility function to initialize the SDL library.
 *
 * This function and SDL_Init() are interchangeable.
 *
 * \param flags any of the flags used by SDL_Init(); see SDL_Init for details.
 * \returns true on success or false on failure; call SDL_GetError() for more
 *          information.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_Init
 * \sa SDL_Quit
 * \sa SDL_QuitSubSystem
 */
SDL_InitSubSystem :: (flags: SDL_InitFlags) -> bool #foreign SDL3;

/**
 * Shut down specific SDL subsystems.
 *
 * You still need to call SDL_Quit() even if you close all open subsystems
 * with SDL_QuitSubSystem().
 *
 * \param flags any of the flags used by SDL_Init(); see SDL_Init for details.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_InitSubSystem
 * \sa SDL_Quit
 */
SDL_QuitSubSystem :: (flags: SDL_InitFlags) -> bool #foreign SDL3;

/**
 * Get a mask of the specified subsystems which are currently initialized.
 *
 * \param flags any of the flags used by SDL_Init(); see SDL_Init for details.
 * \returns a mask of all initialized subsystems if `flags` is 0, otherwise it
 *          returns the initialization status of the specified subsystems.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_Init
 * \sa SDL_InitSubSystem
 */
SDL_WasInit :: (flags: SDL_InitFlags) -> SDL_InitFlags #foreign SDL3;

/**
 * Clean up all initialized subsystems.
 *
 * You should call this function even if you have already shutdown each
 * initialized subsystem with SDL_QuitSubSystem(). It is safe to call this
 * function even in the case of errors in initialization.
 *
 * You can use this function with atexit() to ensure that it is run when your
 * application is shutdown, but it is not wise to do this from a library or
 * other dynamically loaded code.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_Init
 * \sa SDL_QuitSubSystem
 */
SDL_Quit :: () #foreign SDL3;

/**
 * Return whether this is the main thread.
 *
 * On Apple platforms, the main thread is the thread that runs your program's
 * main() entry point. On other platforms, the main thread is the one that
 * calls SDL_Init(SDL_INIT_VIDEO), which should usually be the one that runs
 * your program's main() entry point. If you are using the main callbacks,
 * SDL_AppInit(), SDL_AppIterate(), and SDL_AppQuit() are all called on the
 * main thread.
 *
 * \returns true if this thread is the main thread, or false otherwise.
 *
 * \threadsafety It is safe to call this function from any thread.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_RunOnMainThread
 */
SDL_IsMainThread :: () -> bool #foreign SDL3;

