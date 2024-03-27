const std = @import("std");

fn blocksAndLabels() void {

    // Blocks define their own scope, can be expressions and return a value.
    // Block without a label
    {
        const x: u8 = 42;
        std.debug.print("x = {d}\n", .{x});
    }

    // Block with label and as an expression + break keyword
    const x: u8 = blk: {
        var y: u8 = 13;
        const z: u8 = 42;
        break :blk y + z;
    };
    std.debug.print("const x: u8 = blk: <expression>: {d}\n", .{x});
}

pub fn main() void {
    blocksAndLabels();
}
