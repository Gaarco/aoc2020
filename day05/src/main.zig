const std = @import("std");

const input = @embedFile("../input.txt");

const Seat = struct {
    row: u32,
    col: u32,
    id: u32,
    pub fn lessThan(self: *Seat, seat: Seat) bool {
        return self.id < seat.id;
    }
};

pub fn main() anyerror!void {
    var lines_iterator = std.mem.tokenize(input, "\n");
    var seats = std.ArrayList(Seat).init(std.heap.page_allocator);
    var max_seat_id: u32 = 0;

    while (lines_iterator.next()) |l| {
        var row = l[0..7];
        var col = l[7..];

        var row_seat: u32 = findRow(row).?;
        var col_seat: u32 = findCol(col).?;
        var seat_id = row_seat * 8 + col_seat;
        if (seat_id > max_seat_id)
            max_seat_id = seat_id;

        seats.append(Seat{
            .row = row_seat,
            .col = col_seat,
            .id = seat_id,
        }) catch continue;
    }
    sort(seats);
    var my_seat = findEmpty(seats);

    std.debug.warn("{}, {}\n", .{ max_seat_id, my_seat });
}

fn findRow(row: []const u8) ?u32 {
    var max_row_seat: f32 = 127;
    var min_row_seat: f32 = 0;
    for (row) |c| {
        switch (c) {
            'F' => {
                if (max_row_seat - min_row_seat == 1) return @floatToInt(u32, min_row_seat);
                max_row_seat = std.math.floor((max_row_seat + min_row_seat) / 2.0);
            },
            'B' => {
                if (max_row_seat - min_row_seat == 1) return @floatToInt(u32, max_row_seat);
                min_row_seat = std.math.ceil((min_row_seat + max_row_seat) / 2.0);
            },
            else => {
                std.debug.warn("ERR", .{});
            },
        }
    }
    return null;
}

fn findCol(col: []const u8) ?u32 {
    var max_col_seat: f32 = 7;
    var min_col_seat: f32 = 0;
    for (col) |c| {
        switch (c) {
            'R' => {
                if (max_col_seat - min_col_seat == 1) return @floatToInt(u32, max_col_seat);
                min_col_seat = std.math.ceil((min_col_seat + max_col_seat) / 2.0);
            },
            'L' => {
                if (max_col_seat - min_col_seat == 1) return @floatToInt(u32, min_col_seat);
                max_col_seat = std.math.floor((max_col_seat + min_col_seat) / 2.0);
            },
            else => {
                std.debug.warn("ERR", .{});
            },
        }
    }
    return null;
}

fn sort(list: std.ArrayList(Seat)) void {
    var tmp: u32 = undefined;
    for (list.items) |_, i| {
        for (list.items[0 .. list.items.len - i]) |_, k| {
            if (list.items[k].id > list.items[std.math.min(k + 1, list.items.len - 1)].id) {
                tmp = list.items[k].id;
                list.items[k].id = list.items[std.math.min(k + 1, list.items.len - 1)].id;
                list.items[std.math.min(k + 1, list.items.len - 1)].id = tmp;
            }
        }
    }
}

fn findEmpty(seats: std.ArrayList(Seat)) ?u32 {
    for (seats.items) |s, i| {
        if (seats.items[i + 1].id - s.id > 1)
            return s.id + 1;
    }
    return null;
}
