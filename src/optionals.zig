const std = @import("std");

fn optionalVariables() void {

    // Optional variables: null
    var maybe_byte: ?u8 = null;
    maybe_byte = 42;

    // Assert that the Optional varialbe is not null and extract payload
    std.debug.print("maybe_byte.?: {d}\n", .{maybe_byte.?});

    // Set default value when Optional is null with orelse
    // https://ziggit.dev/t/unreachable/3653#optional-unwrap-1
    var the_byte: u8 = maybe_byte orelse 13;
    std.debug.print("the_byte: {d}\n", .{the_byte});

    // Capture payload of Optional with a conditional statement
    if (maybe_byte) |b| {
        std.debug.print("payload: {d}\n", .{b});
    } else {
        std.debug.print("There is no payload.\n", .{});
    }

    // Check if payload exists but discard the value
    if (maybe_byte) |_| std.debug.print("Payload detected.\n", .{}) else std.debug.print("No payload.\n", .{});

    // Only Optionals can be used for comparison with null
    var is_it_null: bool = if (maybe_byte == null) true else false; // ternary expression
    std.debug.print("is_it_null: {}\n", .{is_it_null});
}

pub fn main() void {
    optionalVariables();
}
