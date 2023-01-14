const std = @import("std");
const testing = std.testing;
const gd = @cImport(@cInclude("godot/gdnative_interface.h"));

export fn the_test_init_function(p_interface: *const gd.GDNativeInterface, p_library: gd.GDNativeExtensionClassLibraryPtr, r_initialization: *gd.GDNativeInitialization) callconv(.C) gd.GDNativeBool {
    _ = p_library;
    _ = r_initialization;

    std.debug.print("Hello from Zigodot!\n", .{});
    std.debug.print("Looks like we running Godot {}.{}.{}, AKA '{s}'.\n",
        .{ p_interface.version_major, p_interface.version_minor, p_interface.version_patch, p_interface.version_string });

    return 1;
}
