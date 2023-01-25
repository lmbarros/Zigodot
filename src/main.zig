// See https://github.com/godot-dlang/godot-dlang/blob/master/src/godot/api/register.d
// https://github.com/godot-dlang/godot-dlang/blob/master/src/godot/string.d

const std = @import("std");
const testing = std.testing;
const gd = @cImport(@cInclude("godot/gdnative_interface.h"));

// TODO: Need a better solution for these constants. Will do for now.
const gdTrue = 1;
const gdFalse = 0;


var the_interface: ?*const gd.GDNativeInterface = null;
var the_library: ?gd.GDNativeExtensionClassLibraryPtr = null;


const TheZigodotClass = struct {
    some_float: f64 = 0.0,

    pub fn some_float_doubled(self: TheZigodotClass) f64 {
        return self.some_float * 2;
    }
};

// TODO: Allocate dynamically, to allow proper instantiation.
var the_class_instance = TheZigodotClass{};

export fn the_class_create_instance(p_userdata: ?*anyopaque) callconv(.C) gd.GDNativeObjectPtr {
    _ = p_userdata;
    return &the_class_instance;
}

export fn the_class_free_instance(p_userdata: ?*anyopaque, p_instance: gd.GDNativeObjectPtr) callconv(.C) void {
    _ = p_userdata;
    _ = p_instance;

    // Empty until we have real instances.
}

var the_class = gd.GDNativeExtensionClassCreationInfo{
    .is_virtual = gdFalse,
    .is_abstract = gdFalse,
    .create_instance_func = the_class_create_instance,
    .free_instance_func = the_class_free_instance,

    .get_func = null,
    .get_property_list_func = null,
    .free_property_list_func = null,
    .property_can_revert_func = null,
    .property_get_revert_func = null,
    .notification_func = null,
    .to_string_func = null,
    .reference_func = null,
    .unreference_func = null,
    .get_virtual_func = null,
    .get_rid_func = null,
    .class_userdata = null,
    .set_func = null,
};

export fn inits_init(userdata: ?*anyopaque, p_level: gd.GDNativeInitializationLevel) callconv(.C) void {
    std.debug.print("inits_init({?}, {})\n", .{userdata, p_level});

    if (p_level != gd.GDNATIVE_INITIALIZATION_SCENE) return;

    std.debug.print("----> {?}\n", .{the_interface.?.classdb_register_extension_class});

    the_interface.?.print_warning.?("Dummy warning", "dummy_function", "dummy.file", 171);

    var memCN = [_]u8{0} ** 1024;
    var nameCN: gd.GDNativeStringPtr = &memCN;
    the_interface.?.string_new_with_latin1_chars_and_len.?(nameCN, "TheZigodotClass", 15);

    var memBC = [_]u8{0} ** 1024;
    var nameBC: gd.GDNativeStringPtr = &memBC;
    the_interface.?.string_new_with_latin1_chars_and_len.?(nameBC, "Object", 6);

    the_interface.?.classdb_register_extension_class.?(the_library.?, nameCN, nameBC, &the_class);


    // the_interface.?.classdb_register_extension_class_integer_constant.?(the_library.?, "NonEkzisteClass", "TheEnumName",
    //     "TheConstantName", 1234, gdFalse);

    // if (the_interface.?.classdb_register_extension_class) |f| {
    //     // If `some_function()` returned a value we get here.
    //     f(the_library, "TheZigodotClass", "Object", &the_class);
    // } else {
    //      // TODO: Should we do better error handling here? I think the register
    //      // func is supposed to be always there.
    //     unreachable;
    // }


}

export fn inits_deinit(userdata: ?*anyopaque, p_level: gd.GDNativeInitializationLevel) callconv(.C) void {
    std.debug.print("inits_deinit({?}, {})\n", .{userdata, p_level});
}

export fn the_test_init_function(p_interface: *const gd.GDNativeInterface, p_library: gd.GDNativeExtensionClassLibraryPtr, r_initialization: *gd.GDNativeInitialization) callconv(.C) gd.GDNativeBool {
    std.debug.print("Hello from Zigodot!\n", .{});
    std.debug.print("Looks like we running Godot {}.{}.{}, AKA '{s}'.\n",
        .{ p_interface.version_major, p_interface.version_minor, p_interface.version_patch, p_interface.version_string });

    r_initialization.minimum_initialization_level = gd.GDNATIVE_INITIALIZATION_SCENE;
    r_initialization.initialize = inits_init;
    r_initialization.deinitialize = inits_deinit;

    the_interface = p_interface;
    the_library = p_library;

    return gdTrue;
}
