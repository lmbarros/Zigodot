# Zigodot

Toying with Godot 4's GDExtension and the Zig programming language.

May become something someday. For now, it's just a bunch of semi-random
experiments and learning.

## Assorted notes

* Testing with Zig 0.10.0 and Godot 4 beta 10.
* So far, testing on Linux only, though I am hoping for some pleasant
  cross-compiling experience (because Zig).
* To test it out:
    1. `zig build`
    2. Copy or symlink `zig-out/lib/libzigodot.so` to `test/bin`.
    3. Open the Godot project at `test`.
    4. You shall see some stuff printed to the console.
