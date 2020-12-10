const std = @import("std");

const input = @embedFile("../input.txt");

const required_fields = [_][]const u8{ "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
const min_byr: u32 = 1920;
const max_byr: u32 = 2002;

const min_iyr: u32 = 2010;
const max_iyr: u32 = 2020;

const min_eyr: u32 = 2020;
const max_eyr: u32 = 2030;

const min_hgt_cm: u32 = 150;
const max_hgt_cm: u32 = 193;
const min_hgt_in: u32 = 59;
const max_hgt_in: u32 = 76;

const ecl_values = [_][]const u8{ "amb", "blu", "brn", "gry", "grn", "hzl", "oth" };

pub fn main() anyerror!void {
    var iterator = std.mem.split(input, "\n\n");
    var part1_valids: u32 = 0;
    var part2_valids: u32 = 0;

    while (iterator.next()) |data| {
        if (hasAllRequiredFields(data)) {
            part1_valids += 1;

            const field = std.mem.replaceOwned(u8, std.heap.page_allocator, data, "\n", " ") catch continue;
            var fields_iterator = std.mem.tokenize(field, " ");

            var all_values_valid = true;
            while (fields_iterator.next()) |e| {
                var colon = std.mem.indexOf(u8, e, ":") orelse break;
                var code = e[0..colon];
                var value = e[colon + 1 ..];
                std.debug.warn("{}, {}\n", .{ code, value });
                if (!isValueValid(code, value)) {
                    all_values_valid = false;
                    break;
                }
            }
            if (all_values_valid)
                part2_valids += 1;
        }
    }
    std.debug.warn("Part 1: {}\nPart 2: {}\n", .{ part1_valids, part2_valids });
}

pub fn hasAllRequiredFields(data: []const u8) bool {
    for (required_fields) |field| {
        if (std.mem.indexOf(u8, data, field) == null) {
            return false;
        }
    }
    return true;
}

pub fn isValueValid(field: []const u8, value: []const u8) bool {
    if (std.mem.eql(u8, field, "byr")) {
        var parsed_value = std.fmt.parseUnsigned(u32, value, 10) catch return false;
        if (inRange(parsed_value, min_byr, max_byr))
            return true;
    } else if (std.mem.eql(u8, field, "iyr")) {
        var parsed_value = std.fmt.parseUnsigned(u32, value, 10) catch return false;
        if (inRange(parsed_value, min_iyr, max_iyr))
            return true;
    } else if (std.mem.eql(u8, field, "eyr")) {
        var parsed_value = std.fmt.parseUnsigned(u32, value, 10) catch return false;
        if (inRange(parsed_value, min_eyr, max_eyr))
            return true;
    } else if (std.mem.eql(u8, field, "hgt")) {
        const hgt = std.fmt.parseUnsigned(u32, value[0 .. value.len - 2], 10) catch return false;
        if (std.mem.eql(u8, value[value.len - 2 ..], "cm"))
            return inRange(hgt, min_hgt_cm, max_hgt_cm);
        if (std.mem.eql(u8, value[value.len - 2 ..], "in"))
            return inRange(hgt, min_hgt_in, max_hgt_in);
    } else if (std.mem.eql(u8, field, "hcl")) {
        if (value[0] != '#') return false;
        if (value.len != 7) return false;
        var code = value[1..];
        for (code) |c| {
            if ((c < '0' or c > '9') and (c < 'a' or c > 'f'))
                return false;
        }
        return true;
    } else if (std.mem.eql(u8, field, "ecl")) {
        for (ecl_values) |v| {
            if (std.mem.eql(u8, v, value))
                return true;
        }
    } else if (std.mem.eql(u8, field, "pid")) {
        if (value.len != 9) return false;
        for (value) |c| {
            if (c < '0' or c > '9')
                return false;
        }
        return true;
    } else if (std.mem.eql(u8, field, "cid")) {
        return true;
    }
    return false;
}

pub fn inRange(val: u32, min: u32, max: u32) bool {
    return val >= min and val <= max;
}
