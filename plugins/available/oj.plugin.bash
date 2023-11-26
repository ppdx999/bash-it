# shellcheck shell=bash
about-plugin 'Bash plugin for oj'

function oj_d {
  about "download a problem"
  group "oj"

  contest=basename $(dirname $(pwd))
  task=basename $(pwd)

  url="https://atcoder.jp/contests/${contest}/tasks/${task}"

  oj d "${url}"
}

function oj_p_zig {
  about "prepare a problem"
  group "oj"

  cat <<EOF > main.zig
const std = @import("std");
const stdin = std.io.getStdIn().reader();
const stdout = std.io.getStdOut().writer();

fn nextToken(reader: anytype, buffer: []u8) []const u8 {
    return reader.readUntilDelimiter(buffer, ' ') catch unreachable;
}

fn nextLine(reader: anytype, buffer: []u8) []const u8 {
    return reader.readUntilDelimiterOrEof(buffer, '\n') catch unreachable orelse unreachable;
}

fn parseInt(comptime T: type, buf: []const u8) T {
    return std.fmt.parseInt(T, buf, 10) catch unreachable;
}

fn readLine(reader: anytype, buffer: []u8) void  {
    _ = buffer;
    _ = reader;
}

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alc = arena.allocator();

    var buf_reader = std.io.bufferedReader(stdin);
    var reader = buf_reader.reader();

    var buffer: [1024]u8 = undefined;

    const N = parseInt(u64, nextLine(reader, &buffer));

    const ans = try solve(alc, N, jobs);
    try stdout.print("{d}\n", .{ans});
}
EOF

  contest=$(basename $(dirname $(pwd)))
  task=$(basename $(pwd))

  url="https://atcoder.jp/contests/${contest}/tasks/${task}"

  oj d "${url}"
}

function oj_p_c {
  about "prepare a problem"
  group "oj"

  cat <<EOF > Makefile
COMP = gcc
SRC = main.c
BIN = main

all: test

\$(BIN): \$(SRC)
	\$(COMP) -o \$(BIN) \$(SRC)

.PHONY: run
run: \$(BIN)
	./\$(BIN)

.PHONY: test
test: \$(BIN)
	oj t -c "./\$(BIN)" -d test -N

.PHONY: clean
clean:
	rm -f \$(BIN)
EOF

  cat <<EOF > main.c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
};
EOF

  contest=$(basename $(dirname $(pwd)))
  task=$(basename $(pwd))

  url="https://atcoder.jp/contests/${contest}/tasks/${task}"

  oj d "${url}"
}

function oj_t_zig {
  about "test a problem"
  group "oj"

  oj t -c "zig run main.zig" -N
}
