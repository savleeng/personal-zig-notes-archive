const std = @import("std");

// Enums: Auto-incrementing starts at 0.
// Type: smallest possible unsigned int
const Color = enum(u8) {
    red,
    green,
    blue,
    // Zls: non-exhaustive enum missing an integer tag type,
    // if missing explicit type declaration for enum.
    _, // Non-exhaustive enum

    // Enums can have methods!
    fn isRed(self: Color) bool {
        return self == .red;
    }
};

// Union: only one field can be active at any given time.
// Allocated memory size = size of the largest field.
// Unions can have methods.

// Un-Tagged Union: union{}
const Number = union {
    int: u8,
    float: f64,
};

// (Single) Tagged Union: union(enum){}
const Token = union(enum) {
    keyword_if, // void
    keyword_switch: void,
    digit: usize,

    fn is(self: Token, tag: std.meta.Tag(Token)) bool {
        return self == tag;
    }
};

pub fn main() void {
    var color: Color = .blue;
    std.debug.print("color: {s}\nisRed: {}\n", .{ @tagName(color), color.isRed() });
    std.debug.print("@intFromEnum: {}\n", .{@intFromEnum(color)});

    color = @enumFromInt(0);
    std.debug.print("color: {s}\nisRed: {}\n", .{ @tagName(color), color.isRed() });

    // Using switches on enums
    switch (color) {
        .red => std.debug.print("It's red.\n", .{}),
        .green => std.debug.print("It's green.\n", .{}),
        .blue => std.debug.print("It's blue.\n", .{}),
        // switch on non-exhaustive enum include the else prong (usually)
        else => std.debug.print("Idk\n", .{}),
        // https://ziglang.org/documentation/0.11.0/#enum
        // A swtch on a non-exhaustive enum can include a `_` prong
        // as an alternative to the `else` prong. However, it's a compile
        // error if all the known tag name are not handled by the switch.
    }

    // Assigning the .int field of the untagged union, Number.
    var num: Number = .{ .int = 13 };
    std.debug.print("{}.int: {}\n", .{ @TypeOf(num), num.int });

    // Re-assigning a value to Number but with .float field.
    num = .{ .float = 3.14 };
    std.debug.print("{}.float: {}\n", .{ @TypeOf(num), num.float });

    var token: Token = .keyword_if;
    std.debug.print("token.is(.keyword_if): {}\n", .{token.is(.keyword_if)});

    // Reassigning a tagged union and capturing payload with switches
    token = .{ .digit = 69 };
    switch (token) {
        .keyword_if => std.debug.print("if\n", .{}),
        .keyword_switch => std.debug.print("switch\n", .{}),
        .digit => |d| std.debug.print("digit: {}\n", .{d}),
    }
    if (token == .digit and token.digit == 69) {
        std.debug.print("...nice\n", .{});
    }
}
