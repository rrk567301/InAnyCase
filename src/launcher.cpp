#include <stdio.h>
#include <unistd.h>

int main() {
    const char* program = "/Users/Shared/Riot Games/Riot Client.app/Contents/MacOS/RiotClientServices";

    char* env[] = {
        "DYLD_INSERT_LIBRARIES=/Users/alexandra/a.dylib",
        NULL
    };

    char* args[] = {
        (char *)program,
        NULL
    };

    if (-1 == execve(program, args, env)) {
        perror("execve failed");
        return -1;
    }

    return 0;
}
