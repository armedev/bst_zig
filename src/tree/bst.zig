const std = @import("std");
const Allocator = std.mem.Allocator;

pub const Node = struct {
    val: i32,
    count: i32,
    left: ?*Node,
    right: ?*Node,
    height: u8,

    pub fn init(allocator: Allocator, val: i32) !*Node {
        var node = try allocator.create(Node);
        errdefer allocator.destroy(node);

        node.val = val;
        node.count = 1;
        node.left = null;
        node.right = null;
        node.height = 1;

        return node;
    }

    pub fn deinit(self: *Node, allocator: Allocator) void {
        allocator.destroy(self);
    }
};

pub const Tree = struct {
    root: *Node,
    allocator: Allocator,

    pub fn init(allocator: Allocator, val: i32) !*Tree {
        const node = try Node.init(allocator, val);

        var tree = try allocator.create(Tree);
        errdefer allocator.destroy(tree);

        tree.root = node;
        tree.allocator = allocator;

        return tree;
    }

    fn traverseAndDeinit(oNode: ?*Node, allocator: Allocator) void {
        if (oNode) |node| {
            if (node.left) |left| traverseAndDeinit(left, allocator);
            if (node.right) |right| traverseAndDeinit(right, allocator);
            node.deinit(allocator);
        } else {
            return;
        }
    }

    pub fn deinit(self: *Tree) void {
        const allocator = self.allocator;
        traverseAndDeinit(self.root, allocator);
        allocator.destroy(self);
    }

    pub fn insert(self: *Tree, val: i32) !void {
        self.root = try self.insertRecursive(self.root, val);
    }

    fn insertRecursive(self: *Tree, node: ?*Node, val: i32) !*Node {
        if (node == null) {
            return try Node.init(self.allocator, val);
        }

        const current = node.?;

        if (val < current.val) {
            current.left = try self.insertRecursive(current.left, val);
        } else if (val > current.val) {
            current.right = try self.insertRecursive(current.right, val);
        } else {
            current.val += 1;
            return current;
        }

        updateHeight(current);

        return current;
    }

    fn updateHeight(node: *Node) void {
        const left_height = if (node.left) |left| left.height else 0;
        const right_height = if (node.right) |right| right.height else 0;
        node.height = @max(left_height, right_height) + 1;
    }

    pub fn inorder(self: *Tree) void {
        self.inorderRecursive(self.root);
    }

    fn inorderRecursive(self: *Tree, oNode: ?*Node) void {
        if (oNode) |node| {
            self.inorderRecursive(node.left);
            std.log.info("{} - {}", .{ node.val, node.height });
            self.inorderRecursive(node.right);
        }
    }
};
