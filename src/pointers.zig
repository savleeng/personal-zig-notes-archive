const std = @import("std");

fn singleItemPointer() void {

    // Keep (im)mutability in mind when working with pointers
    // Pointer dereferencing:
    // - C: `*pointer` and `pointer->structMember`
    // - Zig: `pointer.*`

    var a: u8 = 0; // NOTE: value held by a is VARIABLE
    const a_ptr = &a; // value to a's memory address is CONSTANT

    a_ptr.* += 1; // accessing value at `a` with a_ptr.*
    // a_ptr += 1; // ERROR: memory address location is constant
    std.debug.print("a_ptr: {}, type: {}\n", .{ a_ptr.*, @TypeOf(a_ptr) });
}

fn pointerAssignment() void {

    // Type safety and const correctness

    var a: u8 = 0;
    const b: u8 = 2;

    const a_ptr = &a;
    const b_ptr = &b;
    std.debug.print("a_ptr: {}, b_ptr: {}\n", .{ @TypeOf(a_ptr), @TypeOf(b_ptr) });

    var c_ptr = b_ptr; // IMPORTANT: c_ptr INFERRED as *const u8
    std.debug.print("c_ptr = b_ptr: {}\n", .{@TypeOf(c_ptr)});

    c_ptr = a_ptr; // *u8 -> *const u8 : Legal Assignment
    std.debug.print("c_ptr = a_ptr: {}\n", .{@TypeOf(c_ptr)});

    // *const u8 -> *u8 : Illegal Assignment
    // var c_ptr = a_ptr; // c-ptr INFERRED as *u8
    // c_ptr = b_ptr; // ERROR: expecting *u8, got *const u8
    // NOTE: cast discards const qualifier
}

fn multiItemPointer() void {

    // AKA slice pointers?

    // Assigning and initializing a multi-item pointer
    var arr = [_]u8{ 1, 2, 3, 4, 5 };
    std.debug.print("arr: {any}\n", .{arr});

    var arr_ptr: [*]u8 = &arr;
    std.debug.print("arr_ptr[0]: {}, type: {}\n", .{ arr_ptr[0], @TypeOf(arr_ptr) });

    // Pointer indexing
    arr_ptr[1] += 5; // `arr` second element value is now 7.
    std.debug.print("arr_ptr[1] += 5: arr_ptr[1]: {}, type: {}\n", .{ arr_ptr[1], @TypeOf(arr_ptr) });

    // Pointer Arithmetic
    // By incrementing `arr_ptr`, we are not adding 1. `arr_ptr` is
    // moved forward in memory by a size of one u8. Since arrays are
    // contiguous blocks of memory, moving the pointer forward by u8
    // results in `arr_ptr` pointing at the next element in `arr`.

    arr_ptr += 1;

    // The first element of the pointer is no longer pointing
    // to the first element of the array.
    std.debug.print("arr_ptr += 1: arr_ptr[0]: {}, type: {}\n", .{ arr_ptr[0], @TypeOf(arr_ptr) });

    // Similarly, the pointer can be decremented to once again
    // point at the first element of the array
    arr_ptr -= 1;
    std.debug.print("arr_ptr -= 1: arr_ptr[0]: {}, type: {}\n", .{ arr_ptr[0], @TypeOf(arr_ptr) });

    std.debug.print("arr: {any}\n", .{arr});
}

fn pointerToArray() void {

    // A pointer to an array refers to the entire array, not just the
    // first element of the array. A pointer to an array carries size
    // information about the array. This allows for checking the length
    // of a given array. Provides type safety for out-of-bound access.

    var arr = [_]u8{ 1, 2, 3, 4, 5 };
    const arr_ptr = &arr;
    std.debug.print("arr: {any}\n", .{arr});

    std.debug.print("arr_ptr[0]: {}, type: {} ", .{ arr_ptr[0], @TypeOf(arr_ptr) });
    std.debug.print("<- `arr` size known by `arr_ptr`\n", .{});

    // Indexing to access arr element
    arr_ptr[1] += 8;
    std.debug.print("arr_ptr[1] += 8: arr_ptr[1]: {}, arr: {any}\n", .{ arr_ptr[1], arr });

    // Accessing arr length because arr_ptr stores arr's size info
    std.debug.print("arr_ptr.len: {}\n", .{arr_ptr.len});
}

fn sentinelTerminatedPointer() void {

    // Sentinel Terminated Pointer
    // [*:x]T, where `x` is the sentinel value.
    // The length of a sentinel pointer is determined by the sentinel value.
    // Protection against buffer overflows and overreads.
    // https://ziglang.org/documentation/0.11.0/#Sentinel-Terminated-Pointers

    var arr = [_]u8{ 1, 2, 3, 4, 5, 6 };
    std.debug.print("arr: {any}\n", .{arr});

    // Defining sentinel value at index 4
    arr[4] = 0;

    // Assignment using slice syntax [start..stop :sentinel_value]
    const arr_ptr: [*:0]const u8 = arr[1..4 :0];
    std.debug.print("arr[1..4 :0]: arr_ptr[0]: {}, type: {}\n", .{ arr_ptr[0], @TypeOf(arr_ptr) });

    std.debug.print("arr: {any}\n\n", .{arr});

    // @intFromPtr
    const addr = @intFromPtr(arr_ptr);
    std.debug.print("@intFromPtr: addr: {}, type: {}\n", .{ addr, @TypeOf(addr) });

    // @ptrFromInt
    const addr_ptr: [*:0]const u8 = @ptrFromInt(addr);
    std.debug.print("@ptrFromInt: addr_ptr[1]: {}, type: {}\n", .{ addr_ptr[1], @TypeOf(addr_ptr) });
}

pub fn main() void {
    std.debug.print("==Single Item Pointer==\n", .{});
    singleItemPointer();

    std.debug.print("\n==Pointer Assignment==\n", .{});
    pointerAssignment();

    std.debug.print("\n==Multi-Item Pointer==\n", .{});
    multiItemPointer();

    std.debug.print("\n==Pointer to an Array==\n", .{});
    pointerToArray();

    std.debug.print("\n==Sentinel-Terminated Pointer==\n", .{});
    sentinelTerminatedPointer();
}
