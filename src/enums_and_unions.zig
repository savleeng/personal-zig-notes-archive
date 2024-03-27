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
}
