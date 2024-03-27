const std = @import("std");

fn twoDArray() void {

    // 2D Array
    const arr: [2][2]u8 = [_][2]u8{
        .{ 1, 2 }, // Tuple Literals
        .{ 3, 4 }, // AKA anonymous structs (?)
    };
    std.debug.print("arr: {any}\narr.len: {d}\n", .{ arr, arr.len });
}

fn sentinelTermArray() void {

    // Sentinel Terminated Array: [N:V]T
    // N = Length of the array
    // V = Sentinel Value = Array[N]
    // T = Type
    const st_arr: [2:0]u8 = .{ 1, 2 };
    std.debug.print("Array: {any}\nLength: {d}\nSentinal: {d}\n", .{ st_arr, st_arr.len, st_arr[st_arr.len] });
}

fn concatenateArray() void {

    // Concatenate Arrays: ++
    const arr_one: [3]u8 = [3]u8{ 1, 2, 3 };
    const arr_two: [3]u8 = [3]u8{ 4, 5, 6 };
    const arr_cat: [6]u8 = arr_one ++ arr_two;
    std.debug.print("1: {any}\n2: {any}\n3: {any}\n", .{ arr_one, arr_two, arr_cat });
}

fn getSquare(n: u8) u8 {
    return n *| n; // Saturation: min/max instead of overflow
}

fn initArrayWithFunc() void {

    // Modify a value by passing it a function right before initialization
    // https://ziggit.dev/t/allocation-is-not-initialization/3138
    const init_arr: [3]u8 = [1]u8{getSquare(3)} ** 3;
    std.debug.print("init_arr: {any}\n", .{init_arr});
}

pub fn main() u8 {
    twoDArray();
    sentinelTermArray();
    concatenateArray();
    initArrayWithFunc();
    return 0;
}
