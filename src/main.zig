const std = @import("std");
const testing = std.testing;
const gd = @cImport(@cInclude("godot/gdnative_interface.h"));

// Need a better solution for these constants. Will do for now.
const gdTrue = 1;
const gdFalse = 0;


export fn inits_init(userdata: ?*anyopaque, p_level: gd.GDNativeInitializationLevel) callconv(.C) void {
    std.debug.print("inits_init({any}, {})\n", .{userdata, p_level});
}

export fn inits_deinit(userdata: ?*anyopaque, p_level: gd.GDNativeInitializationLevel) callconv(.C) void {
    std.debug.print("inits_deinit({any}, {})\n", .{userdata, p_level});
}


export fn the_test_init_function(p_interface: *const gd.GDNativeInterface, p_library: gd.GDNativeExtensionClassLibraryPtr, r_initialization: *gd.GDNativeInitialization) callconv(.C) gd.GDNativeBool {
    _ = p_library;

    std.debug.print("Hello from Zigodot!\n", .{});
    std.debug.print("Looks like we running Godot {}.{}.{}, AKA '{s}'.\n",
        .{ p_interface.version_major, p_interface.version_minor, p_interface.version_patch, p_interface.version_string });

    r_initialization.minimum_initialization_level = gd.GDNATIVE_INITIALIZATION_SCENE; // Doesn't seem to have any effect...
    r_initialization.initialize = inits_init;
    r_initialization.deinitialize = inits_deinit;

    return gdTrue;
}
