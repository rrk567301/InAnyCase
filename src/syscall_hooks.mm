//
//  syscall_hooks.mm
//  InAnyCase
//
//  Created by Alexandra Göttlicher, EinTim23
//

#import <dirent.h>
#import "./syscall_hooks.hpp"

static const char* find_case_sensitive_path(const char* original_file_path);
static NSString* find_case_sensitive_file_name(NSString* caseSensitiveFilePath, NSString* caseInsensitiveFileName);
static BOOL path_exists(NSString* path);

#pragma mark - syscall hooks

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_open(const char* path, int oflag, ...) {
    va_list arguments;
    va_start(arguments, oflag);
    int success = original_open(find_case_sensitive_path(path), oflag, arguments);
    va_end(arguments);
    return success;
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_stat(const char* path, struct stat* buf) {
    return original_stat(find_case_sensitive_path(path), buf);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_lstat(const char* path, struct stat* buf) {
    return original_lstat(find_case_sensitive_path(path), buf);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_access(const char* path, int amode) {
    return original_access(find_case_sensitive_path(path), amode);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_chown(const char *path, uid_t owner, gid_t group) {
    return original_chown(find_case_sensitive_path(path), owner, group);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_chmod(const char* path, mode_t mode) {
    return original_chmod(find_case_sensitive_path(path), mode);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_lchmod(const char* path, mode_t flags) {
    return original_lchmod(find_case_sensitive_path(path), flags);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
int override_execv(const char* path, char* const argv[]) {
    return original_execv(find_case_sensitive_path(path), argv);
}

/**
 * Overrides the file path with the correct case sensitive one if necessary.
 *
 * @{inheritdoc}
 */
void* override_dlopen(const char* path, int mode) {
    if (!path) {
        return original_dlopen(path, mode);
    }
    return original_dlopen(find_case_sensitive_path(path), mode);
}

#pragma mark - File path correction

/**
 * Returns the case sensitive path for a given file path.
 *
 * @param  const char* original_file_path The case insensitive file path
 *
 * @return const char*               The case sensitive file path
 */
static const char* find_case_sensitive_path(const char* original_file_path) {
    NSString* caseInsensitiveFilePath = [NSString stringWithUTF8String:original_file_path];

    // Return if the case insensitive path really exists.
    if (path_exists(caseInsensitiveFilePath)) {
        return original_file_path;
    }

    // Prepare to check if each part of the case insensitive path exists.
    NSMutableArray* caseInsensitiveFilePathParts = [[caseInsensitiveFilePath componentsSeparatedByString:@"/"] mutableCopy];

    // Remove the first element from the split parts.
    // Paths not starting with `/` `../` or `./` are alone standing relative files.
    // Those could already be spelled incorrectly, which is fixed in the next step.
    if ([caseInsensitiveFilePath hasPrefix:@"/"] ||
        [caseInsensitiveFilePath hasPrefix:@"../"] ||
        [caseInsensitiveFilePath hasPrefix:@"./"]
    ) {
        [caseInsensitiveFilePathParts removeObjectAtIndex:0];
    }

    // Initialize the case sensitive path with the correct accessor.
    NSString* caseSensitiveFilePath = nil;
    if ([caseInsensitiveFilePath hasPrefix:@"/"]) {
        caseSensitiveFilePath = @"/";
    } else if ([caseInsensitiveFilePath hasPrefix:@"../"]) {
        caseSensitiveFilePath = @"../";
    } else if ([caseInsensitiveFilePath hasPrefix:@"./"]) {
        caseSensitiveFilePath = @"./";
    } else {
        return [find_case_sensitive_file_name(@"", caseInsensitiveFilePath) UTF8String];
    }

    NSUInteger index = 0;
    for (NSString* pathPart in caseInsensitiveFilePathParts) {
        index += 1;

        // Append the correct part to the case sensitive file path.
        if (path_exists([caseInsensitiveFilePath stringByAppendingString:pathPart])) {
            caseSensitiveFilePath = [caseSensitiveFilePath stringByAppendingString:pathPart];
        } else {
            caseSensitiveFilePath = [caseSensitiveFilePath stringByAppendingString:find_case_sensitive_file_name(caseSensitiveFilePath, pathPart)];
        }

        // Add a slash if it's not the last iteration.
        if ([caseInsensitiveFilePathParts count] != index) {
            caseSensitiveFilePath = [caseSensitiveFilePath stringByAppendingString:@"/"];
        }
    }

    return [caseSensitiveFilePath UTF8String];
}

/**
 * Returns the case sensitive file name for a file in a given directory.
 *
 * @param  NSString* caseSensitiveFilePath   The case sensitive file path
 * @param  NSString* caseInsensitiveFileName The case insensitive file name
 *
 * @return NSString*                         The case sensitive file name
 */
static NSString* find_case_sensitive_file_name(NSString* caseSensitiveFilePath, NSString* caseInsensitiveFileName) {
    DIR* directory = opendir([caseSensitiveFilePath UTF8String]);
    struct dirent* entry;

    if (!directory) {
        return caseInsensitiveFileName;
    }

    // Iterate through the directory contents and return the correct file name.
    while (NULL != (entry = readdir(directory))) {
        NSString* entryFileName = [NSString stringWithUTF8String:entry->d_name];
        // The correct file name is the entry's file name if it matches with the given one in lowercase.
        if ([[entryFileName lowercaseString] isEqualToString:[caseInsensitiveFileName lowercaseString]]) {
            closedir(directory);
            return entryFileName;
        }
    }

    closedir(directory);

    return caseInsensitiveFileName;
}

/**
 * Returns whether a file exists at a given path or not
 *
 * @param  NSString* path The file path
 *
 * @return int            Whether the file exists or not
 */
static BOOL path_exists(NSString* path) {
    // Use the original access function to prevent hooking the call.
    return F_OK == original_access([path UTF8String], F_OK);
}
