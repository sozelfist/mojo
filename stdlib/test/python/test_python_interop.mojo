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
# XFAIL: asan && !system-darwin
# RUN: %mojo %s

from python.python import Python, PythonObject, _get_global_python_itf
from testing import assert_equal


fn test_execute_python_string(mut python: Python) -> String:
    try:
        _ = Python.evaluate("print('evaluated by PyRunString')")
        return str(Python.evaluate("'a' + 'b'"))
    except e:
        return str(e)


fn test_local_import(mut python: Python) -> String:
    try:
        var my_module: PythonObject = Python.import_module("my_module")
        if my_module:
            var foo = my_module.Foo("apple")
            foo.bar = "orange"
            return str(foo.bar)
        return "no module, no fruit"
    except e:
        return str(e)


fn test_dynamic_import(mut python: Python, times: Int = 1) -> String:
    alias INLINE_MODULE = """
called_already = False
def hello(name):
    global called_already
    if not called_already:
        called_already = True
        return f"Hello {name}!"
    return "Again?"
"""
    try:
        var mod = Python.evaluate(INLINE_MODULE, file=True)
        for _ in range(times - 1):
            mod.hello("world")
        return str(mod.hello("world"))
    except e:
        return str(e)


fn test_call(mut python: Python) -> String:
    try:
        var my_module: PythonObject = Python.import_module("my_module")
        return str(
            my_module.eat_it_all(
                "carrot",
                "bread",
                "rice",
                fruit="pear",
                protein="fish",
                cake="yes",
            )
        )
    except e:
        return str(e)


def main():
    var python = Python()
    assert_equal(test_local_import(python), "orange")

    # Test twice to ensure that the module state is fresh.
    assert_equal(test_dynamic_import(python), "Hello world!")
    assert_equal(test_dynamic_import(python), "Hello world!")

    # Test with two calls to ensure that the state is persistent.
    assert_equal(test_dynamic_import(python, times=2), "Again?")

    assert_equal(
        test_call(python),
        (
            "carrot ('bread', 'rice') fruit=pear {'protein': 'fish', 'cake':"
            " 'yes'}"
        ),
    )

    var obj: PythonObject = [1, 2.4, True, "False"]
    assert_equal(str(obj), "[1, 2.4, True, 'False']")

    obj = (1, 2.4, True, "False")
    assert_equal(str(obj), "(1, 2.4, True, 'False')")

    obj = None
    assert_equal(str(obj), "None")

    assert_equal(test_execute_python_string(python), "ab")
