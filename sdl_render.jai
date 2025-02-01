SDL_Renderer :: void;

SDL_CreateRenderer :: (window: *SDL_Window, name: *u8) -> *SDL_Renderer #foreign SDL3;
SDL_DestroyRenderer :: (renderer: *SDL_Renderer) #foreign SDL3;
SDL_RenderClear :: (renderer: *SDL_Renderer) -> bool #foreign SDL3;
SDL_RenderFillRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign SDL3;
SDL_RenderRect :: (renderer: *SDL_Renderer, rect: *SDL_FRect) -> bool #foreign SDL3;
SDL_SetRenderDrawColor :: (renderer: *SDL_Renderer, r: u8, g: u8, b: u8, a: u8) -> bool #foreign SDL3;
SDL_RenderPresent :: (renderer: *SDL_Renderer) -> bool #foreign SDL3;
