#if OS == .WINDOWS {
    SDL3 :: #library "windows/x64/SDL3";
}

// Basics
#load "sdl_init.jai";
#load "sdl_properties.jai";
#load "sdl_error.jai";
#load "sdl_version.jai";

// Video
#load "sdl_video.jai";
#load "sdl_render.jai";
#load "sdl_rect.jai";

// Input Events
#load "sdl_events.jai";
#load "sdl_keyboard.jai";
#load "sdl_keycode.jai";
#load "sdl_scancode.jai";
#load "sdl_joystick.jai";
#load "sdl_gamepad.jai";
#load "sdl_sensor.jai";

// Audio
#load "sdl_audio.jai";

// Time
#load "sdl_timer.jai";

// Platform & CPU Information
#load "sdl_endian.jai";

// Additional Functionality
#load "sdl_power.jai";
#load "sdl_guid.jai";
