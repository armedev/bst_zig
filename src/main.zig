const std = @import("std");
const bst = @import("./tree/bst.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var tree = try bst.Tree.init(allocator, 32);
    defer tree.deinit();

    try tree.insert(99);
    try tree.insert(90);
    try tree.insert(80);
    try tree.insert(70);
    try tree.insert(60);
    try tree.insert(50);
    try tree.insert(30);

    // std.log.debug("{}", .{tree.root});
    tree.inorder();
}
