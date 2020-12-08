const std = @import("std");
const allocator = std.heap.page_allocator;

const input = @embedFile("../input.txt");

pub fn main() anyerror!void {
    var iterator = std.mem.split(input, "\n");
    var list = std.ArrayList(u32).init(allocator);
    defer list.deinit();

    while (iterator.next()) |val| {
        try list.append(std.fmt.parseUnsigned(u32, val, 10) catch continue);
    }
    solvePart1(list);
    solvePart2(list);
}

pub fn solvePart1(list: std.ArrayList(u32)) void {
    for (list.items) |x, i| {
        for (list.items[i + 1 ..]) |y| {
            if (x + y == 2020) {
                std.debug.warn("Part 1: {} * {} == {}\n", .{ x, y, x * y });
            }
        }
    }
}

pub fn solvePart2(list: std.ArrayList(u32)) void {
    for (list.items) |x, i| {
        for (list.items[i + 1 ..]) |y, j| {
            for (list.items[j + 1 ..]) |k| {
                if (x + y + k == 2020) {
                    std.debug.warn("Part 2: {} * {} * {} == {}\n", .{ x, y, k, x * y * k });
                }
            }
        }
    }
}
