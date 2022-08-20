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
end

# tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree = Tree.new([7, 9])
tree.insert(2)
tree.insert(3)
tree.insert(15)
tree.insert(7)
tree.delete(15)
p tree.root
