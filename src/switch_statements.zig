const std = @import("std");

fn switchStatements() void {

    // switch, 3-dot notation, multiple matches, block expression, else prong
    const x: u8 = 55;
    switch (x) {
        0...20 => std.debug.print("Between 0 and 20, inclusive on both ends.\n", .{}),
        31, 32, 33 => std.debug.print("Either 31, 32 or 33.\n", .{}),
        40...60 => |n| std.debug.print("Caught the payload: {}\n", .{n}),
        77 => {
            const a = 1;
            const b = 2;
            std.debug.print("a + b = {}\n", .{a + b});
        },
        blk: {
            const a = 100;
            const b = 2;
            break :blk a + b;
        } => std.debug.print("Block as an expression: it's 102.\n", .{}),
        else => std.debug.print("No matches found.\n", .{}),
    }
}

fn switchStatementAsExpression() void {
    const x: u8 = 42;
    const answer: u8 = switch (x) {
        0...10 => 1,
        42 => 2,
        else => 3,
    };
    std.debug.print("Answer is: {}\n", .{answer});
}

pub fn main() void {
    switchStatements();
    switchStatementAsExpression();
}
