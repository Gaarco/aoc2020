const std = @import("std");

const input = @embedFile("../input.txt");

pub fn main() anyerror!void {
    std.log.info("All your codebase are belong to us.", .{});
}
