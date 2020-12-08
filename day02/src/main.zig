const std = @import("std");

const input = @embedFile("../input.txt");

pub fn main() anyerror!void {
    var lines_iterator = std.mem.tokenize(input, "\n");
    //solvePart1(&lines_iterator);
    solvePart2(&lines_iterator);
}

pub fn solvePart1(lines_iterator: *std.mem.TokenIterator) void {
    var correct_lines: u32 = 0;

    while (lines_iterator.next()) |line| {
        const dash_pos = std.mem.indexOf(u8, line, "-") orelse continue;
        const first_space = std.mem.indexOf(u8, line, " ") orelse continue;
        const colon = std.mem.indexOf(u8, line, ":") orelse continue;
        const lower_bound = std.fmt.parseUnsigned(u32, line[0..dash_pos], 10) catch continue;
        const upper_bound = std.fmt.parseUnsigned(u32, line[dash_pos + 1 .. first_space], 10) catch continue;
        const char: u8 = line[colon - 1];

        var char_count: u32 = 0;
        for (line[colon..]) |c| {
            if (c == char) {
                char_count += 1;
            }
        }
        if (char_count <= upper_bound and char_count >= lower_bound) {
            correct_lines += 1;
        }
    }
    std.debug.warn("Part 1: {}\n", .{correct_lines});
}

pub fn solvePart2(lines_iterator: *std.mem.TokenIterator) void {
    var correct_lines: u32 = 0;

    while (lines_iterator.next()) |line| {
        const dash_pos = std.mem.indexOf(u8, line, "-") orelse continue;
        const first_space = std.mem.indexOf(u8, line, " ") orelse continue;
        const colon = std.mem.indexOf(u8, line, ":") orelse continue;
        const lower_bound = std.fmt.parseUnsigned(u32, line[0..dash_pos], 10) catch continue;
        const upper_bound = std.fmt.parseUnsigned(u32, line[dash_pos + 1 .. first_space], 10) catch continue;
        const char: u8 = line[colon - 1];
        const password = line[colon + 2 ..];

        const lower_bound_char = password[lower_bound - 1];
        const upper_bound_char = password[upper_bound - 1];

        if (lower_bound_char == char and upper_bound_char != char or lower_bound_char != char and upper_bound_char == char) {
            correct_lines += 1;
        }
    }
    std.debug.warn("Part 2: {}\n", .{correct_lines});
}
