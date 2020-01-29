const std = @import("std");
const debug = std.debug;
const testing = std.testing;
const expect = testing.expect;

var argv: [*]const [*]const u8 = undefined;

test "const slice child" {
    const strs = [_][*]const u8{
        "one",
        "two",
        "three",
    };
    argv = &strs;
    bar(strs.len);
}

fn foo(args: [][]const u8) void {
    expect(args.len == 3);
    expect(streql(args[0], "one"));
    expect(streql(args[1], "two"));
    expect(streql(args[2], "three"));
}

fn bar(argc: usize) void {
    const args = testing.leak_count_allocator.alloc([]const u8, argc) catch unreachable;
    defer testing.leak_count_allocator.free(args);
    for (args) |_, i| {
        const ptr = argv[i];
        args[i] = ptr[0..strlen(ptr)];
    }
    foo(args);
}

fn strlen(ptr: [*]const u8) usize {
    var count: usize = 0;
    while (ptr[count] != 0) : (count += 1) {}
    return count;
}

fn streql(a: []const u8, b: []const u8) bool {
    if (a.len != b.len) return false;
    for (a) |item, index| {
        if (b[index] != item) return false;
    }
    return true;
}
