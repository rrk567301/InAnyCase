//
//  main.hpp
//  InAnyCase
//
//  Created by EinTim23, Alexandra Göttlicher
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * Overrides the implementation of a method in a class.
 *
 * @param const char* class_name              The name of the class containing the method
 * @param const char* selector_name           The name of the selector to override the method implementation for
 * @param void*       override_implementation The new implementation for the method
 * @param void**      original_implementation The original implementation of the method
 */
inline void MSHookMessageEx(const char* class_name, const char* selector_name, void* override_implementation, void** original_implementation) {
    Class _class = objc_getClass(class_name);
    SEL selector = sel_registerName(selector_name);

    // Get the method from the class.
    Method method = class_getInstanceMethod(_class, selector);
    if (!method) {
        method = class_getClassMethod(_class, selector);
        if (!method) {
            return;
        }
    }

    // Replace the implementation of the method with the new one.
    void* implementation = (void *)method_setImplementation(method, (IMP)override_implementation);
    if (original_implementation) {
        *original_implementation = implementation;
    }
}
