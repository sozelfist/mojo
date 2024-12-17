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
"""Defines the `AnyType` trait.

These are Mojo built-ins, so you don't need to import them.
"""

# ===----------------------------------------------------------------------=== #
#  AnyType
# ===----------------------------------------------------------------------=== #


# TODO(MOCO-1468): Add @explicit_destroy here so we get an error message,
#     preferably one that mentions a link the user can go to to learn about
#     linear types.
trait UnknownDestructibility:
    """The UnknownDestructibility trait is the most basic trait, that all other
    types extend.

    This has no __del__ method. For types that should have the __del__ method,
    use ImplicitlyDestructible instead.
    """

    pass


trait AnyType:
    """The AnyType trait describes a type that has a destructor.

    In Mojo, a type that provide a destructor indicates to the language that it
    is an object with a lifetime whose destructor needs to be called whenever
    an instance of the object reaches the end of its lifetime. Hence, only
    non-trivial types may have destructors.

    Any composition of types that have origins is also an object with a
    lifetime, and the resultant type receives a destructor regardless of whether
    the user explicitly defines one.

    Unless they specify @explicit_destroy, all Mojo structs and traits are
    considered to inherit from AnyType, providing a default no-op destructor
    implementation for types that may need them.

    Example implementing the `AnyType` trait on `Foo` that frees the
    allocated memory:

    ```mojo
    @value
    struct Foo(AnyType):
        var p: UnsafePointer[Int]
        var size: Int

        @implicit
        fn __init__(out self, size: Int):
            self.p = UnsafePointer[Int].alloc(size)
            self.size = size

        fn __del__(owned self):
            print("--freeing allocated memory--")
            self.p.free()
    ```
    """

    fn __del__(owned self, /):
        """Destroy the contained value.

        The destructor receives an owned value and is expected to perform any
        actions needed to end the lifetime of the object. In the simplest case,
        this is nothing, and the language treats the object as being dead at the
        end of this function.
        """
        ...


# A temporary alias to help with the linear types transition, see
# https://www.notion.so/modularai/Linear-Types-14a1044d37bb809ab074c990fe1a84e3.
alias ImplicitlyDestructible = AnyType
