#if OS == .WINDOWS {
    SDL3 :: #library "windows/x64/SDL3";
}

#load "sdl_version.jai";
#load "sdl_error.jai";
#load "sdl_timer.jai";
#load "sdl_properties.jai";
#load "sdl_init.jai";
#load "sdl_video.jai";
#load "sdl_scancode.jai";
#load "sdl_keycode.jai";
#load "sdl_keyboard.jai";
#load "sdl_joystick.jai";
#load "sdl_gamepad.jai";
#load "sdl_events.jai";
#load "sdl_rect.jai";
#load "sdl_render.jai";
