const std = @import("std");

const input = @embedFile("../input.txt");

pub fn main() anyerror!void {
    var iterator = std.mem.split(input, "\n\n");

    var pt1: usize = 0;
    var pt2: usize = 0;
    while (iterator.next()) |e| {
        var group = std.mem.replaceOwned(u8, std.heap.page_allocator, e, "\n", " ") catch continue;
        pt1 += solvePart1(group);
        pt2 += solvePart2(group);
    }
    std.debug.warn("{}, {}", .{ pt1, pt2 });
}

fn solvePart1(group: []const u8) usize {
    var count: u32 = 0;
    outer: for (group) |ch1, idx| {
        if (ch1 == ' ')
            continue;
        for (group[0..idx]) |ch2| {
            if (ch1 == ch2)
                continue :outer;
        }
        count += 1;
    }
    return count;
}

fn solvePart2(group: []const u8) usize {
    var members: u32 = 0;
    var ppl_it = std.mem.tokenize(group, " ");
    var map = std.AutoHashMap(u8, usize).init(std.heap.page_allocator);
    defer map.deinit();

    while (ppl_it.next()) |p_votes| {
        ofor: for (p_votes) |p_char, i| {
            for (p_votes[0..i]) |prev_char| {
                if (p_char == prev_char)
                    continue :ofor;
            }
            var val: usize = map.get(p_char) orelse 0;
            map.put(p_char, val + 1) catch continue;
        }
        members += 1;
    }

    var count: usize = 0;
    var map_it = map.iterator();
    var num_of_spaces = std.mem.count(u8, group, " ");
    while (map_it.next()) |entry| {
        if (entry.value == members) {
            count += 1;
        }
    }

    return count;
}
