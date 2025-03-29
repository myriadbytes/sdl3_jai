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
#load "sdl_pixels.jai";
#load "sdl_blendmode.jai";
#load "sdl_rect.jai";
#load "sdl_surface.jai";

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

// GPU
#load "sdl_gpu.jai";

// Time
#load "sdl_timer.jai";
#load "sdl_time.jai";

// File and I/O Abstractions
#load "sdl_filesystem.jai";
#load "sdl_iostream.jai";

// Platform & CPU Information
#load "sdl_endian.jai";

// Additional Functionality
#load "sdl_power.jai";
#load "sdl_stdinc.jai";
#load "sdl_guid.jai";
