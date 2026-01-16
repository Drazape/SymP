# Organisation
Each directory is a function with sub-functions, that are only called by it's parent function (with a few exceptions)
## Naming
Each function's name is prepended with *parent function name*`_`. So as the function names nest deaper, they keep getting longer.

> [!TIP]
> When calling subfunctions, you don't need to type out the parent function name, instead use `status current-function` as the parent function name

### `main.fish`
`main.fish` is treated as a special file in each function directory. Its name is not used as the suffix of the function name, and instead, the file is used as the function's directory's function content

# Debug Output
## Description
Functions that produce output assign themselves an output variable that is prepended to all the echoes made by the function (by using `_"$program_name"_common_set-output-prefix (status current-function)`)
## Call Trail
As the function calls other functions, the variable is appended by the functions. So the debug output shows the path to how the function was called
## Access
The debug output is accessed with the environment variables:
- `SYMP_LIST_FUNCTIONS`
- `LIST_FUNCTIONS`={`true`,`1`,`yes`}

