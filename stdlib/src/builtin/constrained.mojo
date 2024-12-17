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
"""Implements compile time constraints.

These are Mojo built-ins, so you don't need to import them.
"""


@always_inline("nodebug")
fn constrained[cond: Bool, msg: StringLiteral = "param assertion failed"]():
    """Compile time checks that the condition is true.

    The `constrained` is similar to `static_assert` in C++ and is used to
    introduce constraints on the enclosing function. In Mojo, the assert places
    a constraint on the function. The message is displayed when the assertion
    fails.

    Parameters:
        cond: The bool value to assert.
        msg: The message to display on failure.

    Example:

    ```mojo
    from sys.info import num_physical_cores

    def main():
        alias cores_to_use = 2
        multicore_check[cores_to_use]()

    def multicore_check[cores: Int]():
        constrained[
            cores <= num_physical_cores(),
            "build failed: not enough cores"
        ]()
        constrained[
            cores >= 2,
            "at least two cores are required"
        ]()

    ```

    """
    __mlir_op.`kgen.param.assert`[
        cond = cond.__mlir_i1__(), message = msg.value
    ]()


@always_inline("nodebug")
fn constrained[cond: Bool, msg: String]():
    """Compile time checks that the condition is true.

    The `constrained` is similar to `static_assert` in C++ and is used to
    introduce constraints on the enclosing function. In Mojo, the assert places
    a constraint on the function. The message is displayed when the assertion
    fails, and takes a generalized string.

    Parameters:
        cond: The bool value to assert.
        msg: The message to display on failure.

    Example:

    ```mojo
    from sys.info import num_physical_cores

    def main():
        alias cores_to_use = 2
        multicore_check[cores_to_use]()

    def multicore_check[cores: Int]():
        constrained[
            cores <= num_physical_cores(),
            "build failed: not enough cores"
        ]()
        constrained[
            cores >= 2,
            "at least two cores are required"
        ]()
    """
    constrained[cond, StringLiteral.get[msg]()]()
