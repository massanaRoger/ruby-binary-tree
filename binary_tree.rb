# frozen_string_literal: true

# Node of the tree
class Node
  include Comparable
  attr_accessor :value, :left, :right

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end

  def <=>(other)
    @value <=> other.value
  end
end

# Main tree class
class Tree
  attr_reader :root

  def initialize(arr)
    @root = build_tree(arr)
  end

  def insert(value)
    insert_rec(@root, value)
  end

  def find(value)
    search(@root, value)
  end

  def delete(value)
    delete_rec(@root, value)
  end

  def search(root, value)
    return root if root.nil? || root.value == value
    return search(root.right, value) if root.value < value
    search(root.left, value)
  end

  def level_order
    return if @root.nil?
    root = @root
    queue = []
    queue.push(root)
    final_arr = []
    until queue.empty?
      current = queue.shift
      if block_given?
        current.value=(yield(current.value))
      else
        final_arr.push(current.value)
      end
      queue.push(current.left) unless current.left.nil?
      queue.push(current.right) unless current.right.nil?
    end
    return final_arr unless block_given?
  end

  def in_order(&block)
    arr = []
    self.in_order_rec(root, arr, &block)
    return arr unless block_given?
  end

  def pre_order(&block)
    arr = []
    self.pre_order_rec(root, arr, &block)
    return arr unless block_given?
  end

  def post_order(&block)
    arr = []
    self.post_order_rec(root, arr, &block)
    return arr unless block_given?
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def height_tree
    height_rec(@root)
  end
  
  def depth(node)
    depth_rec(@root, node)
  end

  def balanced?
    balanced_rec?(@root)
  end

  def rebalance
    @root = build_tree(in_order)
  end
  private

  def insert_rec(root, value)
    if root.nil?
      root = Node.new(value)
      return root
    end
    root.left = insert_rec(root.left, value) if value < root.value
    root.right = insert_rec(root.right, value) if value > root.value
    root
  end

  def build_tree(arr)
    arr = arr.uniq.sort
    arr_to_BST(arr, 0, arr.length - 1)
  end

  def arr_to_BST(arr, start, fin)
    return if start > fin

    mid = (start + fin) / 2
    node = Node.new(arr[mid])
    node.left = (arr_to_BST(arr, start, mid - 1))
    node.right = (arr_to_BST(arr, mid + 1, fin))
    node
  end

  def delete_rec(root, value)
    return root if root.nil?

    if value < root.value
      root.left = (delete_rec(root.left, value))
    elsif value > root.value
      root.right = (delete_rec(root.right, value))
    else
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      root.value = min_value(root.right)
      root.right = delete_rec(root.right, root.value)
    end
    root
  end

  def min_value(root)
    minv = root.value
    until root.left.nil?
      minv = root.left.value
      root = root.left
    end
    minv
  end

  def in_order_rec(node, arr, &block)
    return if node.nil?
    in_order_rec(node.left, arr, &block)
    if block_given?
      node.value = block.call(node.value)
    else
      arr.push(node.value)
    end
    in_order_rec(node.right, arr, &block)
  end

  def pre_order_rec(node, arr, &block)
    return if node.nil?
    if block_given?
      node.value = block.call(node.value)
    else
      arr.push(node.value)
    end
    in_order_rec(node.left, arr, &block)
    in_order_rec(node.right, arr, &block)
  end

  def post_order_rec(node, arr, &block)
    return if node.nil?
    in_order_rec(node.left, arr, &block)
    in_order_rec(node.right, arr, &block)
    if block_given?
      node.value = block.call(node.value)
    else
      arr.push(node.value)
    end
  end

  def height_rec(root)
    return 0 if root.nil?
    h_left = height_rec(root.left)
    h_right = height_rec(root.right)
    h_left > h_right ? h_left + 1 : h_right + 1
  end

  def depth_rec(root, x)
    return -1 if root.nil?
    dist = -1
    if (root.value == x ||
      (dist = depth_rec(root.left, x)) >= 0 ||
      (dist = depth_rec(root.right, x)) >= 0)
      dist += 1
    end
    dist
  end
  
  def balanced_rec?(node)
    return true if node.nil?
    lh = height_rec(node.left)
    rh = height_rec(node.right)
    return true if ((lh - rh).abs <= 1 && balanced_rec?(node.left) && balanced_rec?(node.right))
    false
  end
end

arr = Array.new(15) { rand(1..100) }
tree = Tree.new(arr)
p tree.in_order
p tree.pre_order
p tree.post_order
for el in 0..100
  tree.insert(rand(1..100))
end
puts tree.balanced?
tree.rebalance
puts tree.balanced?
p tree.in_order
p tree.pre_order
p tree.post_order
