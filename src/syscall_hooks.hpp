//
//  syscall_hooks.hpp
//  InAnyCase
//
//  Created by Alexandra Göttlicher
//

#import <Foundation/Foundation.h>

inline int (* original_open)(const char* path, int oflag, ...);
int override_open(const char* path, int oflag, ...);

inline int (* original_stat)(const char* path, struct stat* buf);
int override_stat(const char* path, struct stat* buf);

inline int (* original_lstat)(const char* path, struct stat* buf);
int override_lstat(const char* path, struct stat* buf);

inline int (* original_access)(const char* path, int amode);
int override_access(const char* path, int amode);

inline int (* original_chown)(const char *path, uid_t owner, gid_t group);
int override_chown(const char *path, uid_t owner, gid_t group);

inline int (* original_chmod)(const char* path, mode_t mode);
int override_chmod(const char* path, mode_t mode);

inline int (* original_lchmod)(const char* path, mode_t flags);
int override_lchmod(const char* path, mode_t flags);

inline int (* original_execv)(const char* path, char* const argv[]);
int override_execv(const char* path, char* const argv[]);

inline void* (* original_dlopen)(const char* path, int mode);
void* override_dlopen(const char* path, int mode);
