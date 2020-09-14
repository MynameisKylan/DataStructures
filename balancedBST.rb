class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data, left=nil, right=nil)
    @data = data
    @left = left
    @right = right
  end

  def is_leaf?
    !(left || right)
  end
end

class Tree
  def initialize(arr)
    @root = build_tree(arr.uniq.sort)
  end

  private def build_tree(arr)
    if arr.empty?
      return nil
    end
    mid = arr.length / 2
    root = Node.new(arr[mid])

    puts 'building left'
    root.left = build_tree(arr[0...mid])
    puts 'building right'
    root.right = build_tree(arr[mid+1..-1])

    root
  end

  def insert(value)
    node = @root
    while node
      return if value == node.data
      if value > node.data && !node.right
        node.right = Node.new(value)
        # puts "#{value} inserted"
        break
      elsif value < node.data && !node.left
        node.left = Node.new(value)
        # puts "#{value} inserted"
        break
      else
        node = (value > node.data) ? node.right : node.left
        # puts "traversing to node with data: #{node.data}"
      end
    end
  end

  def delete(value)
    node = @root
    # traverse to node with data == value
    while node
      if node.left && value == node.left.data
        to_delete = node.left
        break
      elsif node.right && value == node.right.data
        to_delete = node.right
        break
      else
        node = (value > node.data) ? node.right : node.left
      end
    end
    # case: leaf node
    if !to_delete.left && !to_delete.right
      node.right = nil if node.right == to_delete
      node.left = nil if node.left == to_delete
      puts 'leaf node deleted'
    # case: node has two children
    elsif to_delete.left && to_delete.right
      
    # case: node has one child
    else
      if to_delete.right
        node.right = to_delete.right if node.right == to_delete
        node.left = to_delete.right if node.left == to_delete
      else
        node.right = to_delete.left if node.right == to_delete
        node.left = to_delete.left if node.left == to_delete
      end
    end
    'Value does not exist'
  end

  def find(value)
    node = @root
    while node
      return node if value == node.data
      node = (value > node.data) ? node.right : node.left
    end
    node
  end

  # BFS
  def level_order(root = @root, queue = [root], result = [])
    # iterative
    # queue << root if root
    # while !queue.empty?
    #   root = queue.shift
    #   result << root.data
    #   queue << root.left if root.left
    #   queue << root.right if root.right
    # end
    
    # recursive
    if queue.empty?
      return result
    end
    root = queue.shift
    result << root
    queue << root.left if root.left
    queue << root.right if root.right
    level_order(root, queue, result)

    result #.map { |node| node.data }
  end

  def inorder(root = @root, result = [])
    return if !root
    inorder(root.left, result)
    result << root.data
    inorder(root.right, result)
    result
  end
  
  def preorder(root = @root, result = [])
    return if !root
    result << root.data
    preorder(root.left, result)
    preorder(root.right, result)
    result
  end

  def postorder(root = @root, result = [])
    return if !root
    postorder(root.left, result)
    postorder(root.right, result)
    result << root.data
    result
  end

  def height(node, max_height = 0)
    if !node
      return 0
    elsif node.is_leaf?
      return max_height
    else
      [height(node.left, max_height + 1), height(node.right, max_height + 1)].max
    end
  end

  def depth(node, root = @root, depth = 0)
    if !find(node.data) || !root
      return nil
    elsif root == node
      return depth
    else
      left = depth(node, root.left, depth + 1)
      right = depth(node, root.right, depth + 1)
      (left) ? left : right
    end
  end

  def balanced?(root = @root, height = Height.new)
    if !root
      return true
    end
    lh = Height.new
    rh = Height.new
    left = balanced?(root.left, lh)
    right = balanced?(root.right, rh)

    height.height = [lh.height, rh.height].max + 1

    if (lh.height - rh.height).abs <= 1
      return left && right
    else
      return false
    end
  end

  def rebalance
    nodes = level_order
    @root = build_tree(nodes.map { |node| node.data })
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

class Height
  attr_accessor :height
  def initialize
    # nil children of leaf nodes start at height -1
    @height = -1
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
p tree.balanced?
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
tree.insert(90)
tree.insert(60)
tree.insert(70)
tree.insert(80)
tree.insert(110)
tree.insert(50)
tree.pretty_print
tree.delete(50)
tree.pretty_print
p tree.balanced?
tree.rebalance
tree.balanced?
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
tree.pretty_print