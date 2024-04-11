const std = @import("std");
const io = std.io;
const delimiter: u8 = '\n';
const reader = io.getStdIn().reader();

fn deprecatedReaderMethods() !void {
    // INFO: [DEPRECATED]
    // - readUntilDelimiter()
    // - readUntilDelimiterOrEof()

    var buffer: [4096]u8 = undefined;
    var readbuf = try reader.readUntilDelimiterOrEof(&buffer, delimiter);
    std.debug.print("{?s}\n", .{readbuf});
}

fn fixedBufferStreamUntilDelimiter() !void {
    var buffer: [4096]u8 = undefined;
    var stream = io.fixedBufferStream(&buffer);
    try reader.streamUntilDelimiter(stream.writer(), delimiter, buffer.len);
    std.debug.print("{s}\n", .{stream.getWritten()});
}

fn boundedArrayStream() !void {
    // NOTE: https://github.com/ziglang/zig/issues/15528
    // - BoundedArray()
    // - streamUntilDelimiter()
    // - fixedBufferStream()

    var array: std.BoundedArray(u8, 4096) = .{};
    try reader.streamUntilDelimiter(array.writer(), delimiter, array.capacity());
    std.debug.print("{s}\n", .{array.buffer});
}

pub fn main() !void {
    std.debug.print("[1/3]: ", .{});
    _ = try deprecatedReaderMethods();

    std.debug.print("[2/3]: ", .{});
    _ = try fixedBufferStreamUntilDelimiter();

    std.debug.print("[3/3]: ", .{});
    _ = try boundedArrayStream();

    // TODO: buffered I/O stream
}
