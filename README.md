# InAnyCase
An attempt to make apps like Unity and the Adobe Suite work on case sensitive APFS.

> [!WARNING]
> A few apps may still not work until I have found a solution regarding permission errors.

> [!WARNING]
> A few apps may need their mach-o header modified to function.
> See the compatibility table below.

## Usage
1. Download the latest `dylib` from the [releases](https://github.com/rrk567301/InAnyCase/releases)
2. Inject the `dylib`:
    - CLI: `DYLD_INSERT_LIBRARIES=<ABSOLUTE_DYLIB_PATH> <APP_BINARY_PATH>`

> [!IMPORTANT]
> You may need to use `sudo -i` when injecting via the CLI, if you see a "permission denied" error.

## Compatibility
<table>
    <thead>
        <tr>
            <th>Status</th>
            <th>App</th>
            <th>Reason</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>⚠️</td>
            <td>Adobe After Effects</td>
            <td>Works once installed.</td>
        </tr>
        <tr>
            <td>❌</td>
            <td>Steam</td>
            <td>Permission denied (unknown).</td>
        </tr>
        <tr>
            <td>✅</td>
            <td>Ultimate Vocal Remover</td>
            <td></td>
        </tr>
        <tr>
            <td>⚠️</td>
            <td>Unity</td>
            <td>Works with a modified mach-o header.</td>
        </tr>
        <tr>
            <td>⚠️</td>
            <td>Wuthering Waves</td>
            <td>Works, but needs to be launched as root.</td>
        </tr>
    </tbody>
</table>

## Compiling
### macOS
1. Install the dependencies:
    - `Xcode`: 13 or later
    - `cmake`: 3.10 or later
2. Clone the project: `git clone --recursive https://github.com/rrk567301/InAnyCase.git && cd ./InAnyCase/`
3. Configure the project: `cmake -S . -B ./build/ -DCMAKE_BUILD_TYPE=Release`
4. Build the project: `cmake --build ./build/ --config Release -j`

## Contributing
If you would like to contribute, please take a look at my contribution guidelines first.

## Credits
- [EinTim23](https://github.com/EinTim23) for helping me with the hooks
- [jmpews](https://github.com/jmpews) for [Dobby](https://github.com/jmpews/Dobby)

## License
[GPL-3.0](https://github.com/rrk567301/InAnyCase/blob/main/COPYING)
