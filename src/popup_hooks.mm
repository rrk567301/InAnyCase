//
//  popup_hooks.mm
//  InAnyCase
//
//  Created by Alexandra Göttlicher
//

#import "./popup_hooks.hpp"

#pragma mark - Pop-up hooks

/**
 * Patches the check in apps using `getResourceValue:forKey:error:`.
 *
 * @{inheritdoc}
 */
BOOL override_getResourceValue_forKey_error(void* self, SEL _cmd, id* value, NSURLResourceKey key, NSError** error) {
    if ([key isEqualTo:NSURLVolumeSupportsCaseSensitiveNamesKey]) {
        // 0 means that the file system is not case sensitive.
        *(NSNumber **)value = [NSNumber numberWithInt:0];
        return YES;
    }

    return original_getResourceValue_forKey_error(self, _cmd, value, key, error);
}

/**
 * Patches the check in Unity.
 *
 * @return int64_t Whether the file system is suitable or not
 */
int64_t override_EnsureSuitableFileSystem() {
    return 0;
}
