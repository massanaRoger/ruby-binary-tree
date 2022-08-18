class Node
  include Comparable
  attr_accessor :value, :left, :right
  def initialize
    @value = nil
    @left = nil
    @right = nil
  end
  def <=> (other)
    @value <=> other.value
  end
    
end

node1 = Node.new
node1.value = 3
node2 = Node.new
node2.value = 5
p node1 < node2
