# ===----------------------------------------------------------------------=== #
# Copyright (c) 2024, Modular Inc. All rights reserved.
#
# Licensed under the Apache License v2.0 with LLVM Exceptions:
# https://llvm.org/LICENSE.txt
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===----------------------------------------------------------------------=== #
"""Implements functions for retrieving compile-time defines.

You can use these functions to set parameter values or runtime constants based on
name-value pairs defined on the command line. For example:

```mojo
  from sys import is_defined

  alias float_type = DType.float32 if is_defined["FLOAT32"]() else DType.float64

  # Use `float_type` as a constant.
```

And on the command line:

```
  mojo -D FLOAT_32 main.mojo
```

For more information, see the [Mojo build docs](https://docs.modular.com/mojo/cli/build.html#d-keyvalue).
The `mojo run` command also supports the `-D` option.


You can import these APIs from the `sys` package. For example:

```mojo
from sys import is_defined
```
"""


fn is_defined[name: StringLiteral]() -> Bool:
    """Return true if the named value is defined.

    Parameters:
        name: The name to test.

    Returns:
        True if the name is defined.
    """
    return __mlir_attr[`#kgen.param.expr<get_env, `, name.value, `> : i1`]


fn env_get_bool[name: StringLiteral]() -> Bool:
    """Try to get an boolean-valued define. Compilation fails if the
    name is not defined or the value is neither `True` or `False`.

    Parameters:
        name: The name of the define.

    Returns:
        An boolean parameter value.
    """
    alias val = env_get_string[name]()

    @parameter
    if val in ("True", "true"):
        return True

    @parameter
    if val in ("False", "false"):
        return False

    constrained[
        False, "the boolean environment value is neither `True` nor `False`"
    ]()
    return False


fn env_get_bool[name: StringLiteral, default: Bool]() -> Bool:
    """Try to get an bool-valued define. If the name is not defined, return
    a default value instead. The boolean must be either `True` or `False`.

    Parameters:
        name: The name of the define.
        default: The default value to use.

    Returns:
        An bool parameter value.
    """

    @parameter
    if is_defined[name]():
        return env_get_bool[name]()
    else:
        return default


fn env_get_int[name: StringLiteral]() -> Int:
    """Try to get an integer-valued define. Compilation fails if the
    name is not defined.

    Parameters:
        name: The name of the define.

    Returns:
        An integer parameter value.
    """
    return __mlir_attr[`#kgen.param.expr<get_env, `, name.value, `> : index`]


fn env_get_int[name: StringLiteral, default: Int]() -> Int:
    """Try to get an integer-valued define. If the name is not defined, return
    a default value instead.

    Parameters:
        name: The name of the define.
        default: The default value to use.

    Returns:
        An integer parameter value.

    Example:
    ```mojo
    from sys.param_env import env_get_int

    def main():
        alias number = env_get_int[
            "favorite_number",
            1 # Default value
        ]()
        parametrized[number]()

    fn parametrized[num: Int]():
        print(num)
    ```

    If the program is `app.mojo`:
    - `mojo run -D favorite_number=2 app.mojo`
    - `mojo run -D app.mojo`

    Note: useful for parameterizing SIMD vector sizes.
    """

    @parameter
    if is_defined[name]():
        return env_get_int[name]()
    else:
        return default


fn env_get_string[name: StringLiteral]() -> StringLiteral:
    """Try to get a string-valued define. Compilation fails if the
    name is not defined.

    Parameters:
        name: The name of the define.

    Returns:
        A string parameter value.
    """
    return __mlir_attr[
        `#kgen.param.expr<get_env, `, name.value, `> : !kgen.string`
    ]


fn env_get_string[
    name: StringLiteral, default: StringLiteral
]() -> StringLiteral:
    """Try to get a string-valued define. If the name is not defined, return
    a default value instead.

    Parameters:
        name: The name of the define.
        default: The default value to use.

    Returns:
        A string parameter value.
    """

    @parameter
    if is_defined[name]():
        return env_get_string[name]()
    else:
        return default
