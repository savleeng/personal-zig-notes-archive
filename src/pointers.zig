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

    // Pointer arithmetic
    // NOTE: By incrementing the memory address pointer that
    // points to the first u8 element of `arr`, we are not
    // adding 1, per se. We are moving the pointer forward in
    // memory by a size of ONE (1) u8. And, since arrays are
    // contiguous blocks of memory, moving the pointer forward
    // by u8 effectively results in a pointer that's now
    // pointing at the next element in the array.
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

pub fn main() void {
    std.debug.print("==Single Item Pointer==\n", .{});
    singleItemPointer();
    std.debug.print("\n==Pointer Assignment==\n", .{});
    pointerAssignment();
    std.debug.print("\n==Multi-Item Pointer==\n", .{});
    multiItemPointer();
}
