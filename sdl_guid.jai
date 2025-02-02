// SDL_guid.h

/**
 * # CategoryGUID
 *
 * A GUID is a 128-bit value that represents something that is uniquely
 * identifiable by this value: "globally unique."
 *
 * SDL provides functions to convert a GUID to/from a string.
 */

/**
 * An SDL_GUID is a 128-bit identifier for an input device that identifies
 * that device across runs of SDL programs on the same platform.
 *
 * If the device is detached and then re-attached to a different port, or if
 * the base system is rebooted, the device should still report the same GUID.
 *
 * GUIDs are as precise as possible but are not guaranteed to distinguish
 * physically distinct but equivalent devices. For example, two game
 * controllers from the same vendor with the same product ID and revision may
 * have the same GUID.
 *
 * GUIDs may be platform-dependent (i.e., the same device may report different
 * GUIDs on different operating systems).
 *
 * \since This struct is available since SDL 3.2.0.
 */
SDL_GUID :: struct {
    data: [16]u8;
};

/* Function prototypes */

/**
 * Get an ASCII string representation for a given SDL_GUID.
 *
 * \param guid the SDL_GUID you wish to convert to string.
 * \param pszGUID buffer in which to write the ASCII string.
 * \param cbGUID the size of pszGUID, should be at least 33 bytes.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_StringToGUID
 */
SDL_GUIDToString :: (guid: SDL_GUID, pszGUID: *u8, cbGUID: s32) -> void #foreign SDL3;

/**
 * Convert a GUID string into a SDL_GUID structure.
 *
 * Performs no error checking. If this function is given a string containing
 * an invalid GUID, the function will silently succeed, but the GUID generated
 * will not be useful.
 *
 * \param pchGUID string containing an ASCII representation of a GUID.
 * \returns a SDL_GUID structure.
 *
 * \since This function is available since SDL 3.2.0.
 *
 * \sa SDL_GUIDToString
 */
SDL_StringToGUID :: (pchGUID: *u8) -> SDL_GUID #foreign SDL3;
