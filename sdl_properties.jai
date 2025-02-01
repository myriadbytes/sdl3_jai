// SDL_properties.h

SDL_PropertiesID :: u32;

SDL_PropertyType :: enum
{
    SDL_PROPERTY_TYPE_INVALID;
    SDL_PROPERTY_TYPE_POINTER;
    SDL_PROPERTY_TYPE_STRING;
    SDL_PROPERTY_TYPE_NUMBER;
    SDL_PROPERTY_TYPE_FLOAT;
    SDL_PROPERTY_TYPE_BOOLEAN;
};

SDL_GetGlobalProperties :: () -> SDL_PropertiesID #foreign SDL3;
SDL_CreateProperties :: () -> SDL_PropertiesID #foreign SDL3;
SDL_CopyProperties :: (src: SDL_PropertiesID, dst: SDL_PropertiesID) -> bool #foreign SDL3;
SDL_LockProperties :: (props: SDL_PropertiesID) -> bool #foreign SDL3;
SDL_UnlockProperties :: (props: SDL_PropertiesID) #foreign SDL3;

SDL_CleanupPropertyCallback :: #type (userdata: *void, value: *void) #c_call;
SDL_SetPointerPropertyWithCleanup :: (props: SDL_PropertiesID, name: *u8, value: *void, cleanup: SDL_CleanupPropertyCallback, userdata: *void) -> bool #foreign SDL3;
SDL_SetPointerProperty :: (props: SDL_PropertiesID, name: *u8, value: *void) -> bool #foreign SDL3;
SDL_SetStringProperty :: (props: SDL_PropertiesID, name: *u8, value: *u8) -> bool #foreign SDL3;
SDL_SetNumberProperty :: (props: SDL_PropertiesID, name: *u8, value: s64) -> bool #foreign SDL3;
SDL_SetFloatProperty :: (props: SDL_PropertiesID, name: *u8, value: float32) -> bool #foreign SDL3;
SDL_SetBooleanProperty :: (props: SDL_PropertiesID, name: *u8, value: bool) -> bool #foreign SDL3;
SDL_HasProperty :: (props: SDL_PropertiesID, name: *u8) -> bool #foreign SDL3;
SDL_GetPropertyType :: (props: SDL_PropertiesID, name: *u8) -> SDL_PropertyType #foreign SDL3;
SDL_GetPointerProperty :: (props: SDL_PropertiesID, name: *u8, default_value: *void) -> *void #foreign SDL3;
SDL_GetStringProperty :: (props: SDL_PropertiesID, name: *u8, default_value: *u8) -> *u8 #foreign SDL3;
SDL_GetNumberProperty :: (props: SDL_PropertiesID, name: *u8, default_value: s64) -> s64 #foreign SDL3;
SDL_GetFloatProperty :: (props: SDL_PropertiesID, name: *u8, default_value: float) -> float32 #foreign SDL3;
SDL_GetBooleanProperty :: (props: SDL_PropertiesID, name: *u8, default_value: bool) -> bool #foreign SDL3;
SDL_ClearProperty :: (props: SDL_PropertiesID, name: *u8) -> bool #foreign SDL3;

SDL_EnumeratePropertiesCallback :: #type (userdata: *void, props: SDL_PropertiesID, name: *u8) #c_call;
SDL_EnumerateProperties :: (props: SDL_PropertiesID, callback: SDL_EnumeratePropertiesCallback, userdata: *void) -> bool #foreign SDL3;
SDL_DestroyProperties :: (props: SDL_PropertiesID) #foreign SDL3;
