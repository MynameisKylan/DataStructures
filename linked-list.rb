class LinkedList
  def initialize(head=Node.new)
    @head = head
    @tail = head
  end

  def append(value)
    node = Node.new(value)
    @tail.next_node = node
    @tail = node
  end

  def prepend(value)
    old_head = @head
    @head = Node.new(value)
    @head.next_node = old_head
  end

  def size
    count = 0
    node = @head
    while node.next_node
      count += 1
      node = node.next_node
    end
    count
  end

  def head
    @head
  end
  
  def tail
    @tail
  end

  def at(index)
    node = @head
    while index > 0
      node = node.next_node
      index -= 1
    end
    node
  end

  def pop
    node = @head
    until node.next_node == @tail
      node = node.next_node
    end
    old_tail = node.next_node
    node.next_node = nil
    @tail = node
    old_tail
  end

  def contains?(value)
    node = @head
    while node
      return true if node.value == value
      node = node.next_node
    end
    false
  end

  def find(value)
    i = 0
    node = @head
    while node
      return i if node.value == value
      i += 1
      node = node.next_node
    end
    nil
  end

  def to_s
    str = ""
    node = @head
    while node
      str += "( #{node.value} ) => "
      node = node.next_node
    end
    str += "nil"
  end

  def insert_at(value, index)
    this_node = @head
    while index > 1
      this_node = this_node.next_node
      index -= 1
    end
    next_node = this_node.next_node
    new_node = Node.new(value)
    new_node.next_node = next_node
    this_node.next_node = new_node
  end

  def remove_at(index)
    this_node = @head
    while index > 1
      this_node = this_node.next_node
      index -= 1
    end
    this_node.next_node = this_node.next_node.next_node
  end
end

class Node
  attr_accessor :value, :next_node
  def initialize(value=nil, next_node=nil)
    @value = value
    @next_node = next_node
  end

  def to_s
    "Node: {value: #{value}, next: #{next_node}}"
  end
end

n1 = Node.new(1)
list = LinkedList.new(n1)
list.append(2)
list.append(3)
list.append(4)
list.prepend(0)
p 'size: ' + list.size.to_s
p 'head: ' + list.head.to_s
p 'tail: ' + list.tail.to_s
p 'at(2): ' + list.at(2).to_s
list.pop
puts 'popped'
p 'tail: ' + list.tail.to_s
p 'contains 2?: ' + list.contains?(2).to_s
p 'contains 1?: ' + list.contains?(1).to_s
p 'find 1: ' + list.find(1).to_s
p 'find 2: ' + list.find(2).to_s
puts list

list.insert_at('hi', 2)
puts list
list.remove_at(2)
puts list