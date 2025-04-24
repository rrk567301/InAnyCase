//
//  main.mm
//  InAnyCase
//
//  Created by Alexandra Göttlicher
//

#import <dlfcn.h>
#import <dobby.h>

#import "./main.hpp"
#import "./popup_hooks.hpp"
#import "./syscall_hooks.hpp"

#pragma mark - Constructor

/**
 * Initializes the Tweak.
 */
__attribute__((constructor)) static void initialize() {
    NSString* processName = [[NSProcessInfo processInfo] processName];

    // syscall hooks.
    DobbyHook(dlsym(RTLD_DEFAULT, "open"), (void *)override_open, (void **)&original_open);
    DobbyHook(dlsym(RTLD_DEFAULT, "stat"), (void *)override_stat, (void **)&original_stat);
    DobbyHook(dlsym(RTLD_DEFAULT, "lstat"), (void *)override_lstat, (void **)&original_lstat);
    DobbyHook(dlsym(RTLD_DEFAULT, "access"), (void *)override_access, (void **)&original_access);
    DobbyHook(dlsym(RTLD_DEFAULT, "chown"), (void *)override_chown, (void **)&original_chown);
    DobbyHook(dlsym(RTLD_DEFAULT, "chmod"), (void *)override_chmod, (void **)&original_chmod);
    DobbyHook(dlsym(RTLD_DEFAULT, "lchmod"), (void *)override_lchmod, (void **)&original_lchmod);
    DobbyHook(dlsym(RTLD_DEFAULT, "execv"), (void *)override_execv, (void **)&original_execv);
    DobbyHook(dlsym(RTLD_DEFAULT, "dlopen"), (void *)override_dlopen, (void **)&original_dlopen);

    // Pop-up hooks.
    MSHookMessageEx("NSURL", "getResourceValue:forKey:error:", (void *)override_getResourceValue_forKey_error, (void **)&original_getResourceValue_forKey_error);

    if ([processName isEqualToString:@"Unity"]) {
        MSHookMessageEx("NSURL", "EnsureSuitableFileSystem", (void *)override_EnsureSuitableFileSystem, (void **)&original_EnsureSuitableFileSystem);
    }
}
