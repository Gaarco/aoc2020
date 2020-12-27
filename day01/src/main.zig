const std = @import("std");
const warn = std.debug.warn;
const allocator = std.heap.page_allocator;

const input = @embedFile("../input.txt");
const sample = @embedFile("../sample.txt");

pub fn main() anyerror!void {
    var iterator = std.mem.split(input, "\n");
    var list = std.ArrayList(u32).init(allocator);
    defer list.deinit();

    while (iterator.next()) |val| {
        try list.append(std.fmt.parseUnsigned(u32, val, 10) catch continue);
    }
    solve(list.items);
}

pub fn solve(items: []const u32) void {
    for (items) |x, idx0| {
        for (items[idx0 + 1 ..]) |y, idx1| {
            if (x + y == 2020) {
                warn("Part 1: {}\n", .{x * y});
            }
            for (items[std.math.max(idx0, idx1)..]) |z, idx2| {
                if (x + y + z == 2020) {
                    warn("Part 2: {}\n", .{x * y * z});
                }
            }
        }
    }
}
