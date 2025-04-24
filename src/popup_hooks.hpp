//
//  popup_hooks.hpp
//  InAnyCase
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

inline BOOL (* original_getResourceValue_forKey_error)(void* self, SEL _cmd, id* value, NSURLResourceKey key, NSError** error);
BOOL override_getResourceValue_forKey_error(void* self, SEL _cmd, id* value, NSURLResourceKey key, NSError** error);

inline BOOL (* original_EnsureSuitableFileSystem)();
int64_t override_EnsureSuitableFileSystem();
