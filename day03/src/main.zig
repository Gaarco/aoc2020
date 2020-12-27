const std = @import("std");

const input = @embedFile("../input.txt");

pub fn main() anyerror!void {
    var iterator = std.mem.tokenize(input, "\n");
    var rows = std.ArrayList([]const u8).init(std.heap.page_allocator);
    while (iterator.next()) |r| {
        rows.append(r) catch continue;
    }
    defer rows.deinit();

    const r11 = solve(rows, 1, 1);
    const r13 = solve(rows, 1, 3);
    const r15 = solve(rows, 1, 5);
    const r17 = solve(rows, 1, 7);
    const r21 = solve(rows, 2, 1);
    const r = r11 * r13 * r15 * r17 * r21;

    std.debug.warn("Part 1:\n\tr11: {}\n\tr13: {}\n\tr15: {}\n\tr17: {}\n\tr21: {}\n", .{ r11, r13, r15, r17, r21 });
    std.debug.warn("Part 2: {}\n", .{r});
}

pub fn solve(rows: std.ArrayList([]const u8), row_skip: u32, col_skip: u32) u32 {
    var counter: u32 = 0;

    var col_index: usize = 0;
    var row_index: usize = 0;
    while (row_index < rows.items.len) : (row_index += row_skip) {
        const curr_row = rows.items[row_index];
        if (col_index >= curr_row.len) {
            col_index -= curr_row.len;
        }
        if (curr_row[col_index] == '#') {
            counter += 1;
        }
        col_index += col_skip;
    }
    return counter;
}
