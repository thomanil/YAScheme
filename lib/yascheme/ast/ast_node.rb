class AstNode
  include Enumerable

  attr_accessor :parent, :children
  attr_accessor :node_value

  def initialize(value = nil)
    @node_value = value
    @children = []
  end
  
  def add(child)
    @children.push child
    child.parent = self
  end
  
  def [](index)
    @children[index]
  end
  
  def to_s
    children_s = children.map{|child| child.to_s}
    children.join " "
  end

  def internal_structure(indentation=0)
    node_descr = ""
    indentation.times { node_descr.concat "  " }
    description = self.class.to_s.gsub("Node", "")
    node_descr.concat "#{description}"
    if(!@node_value.nil?)
        node_descr.concat " #{@node_value}"
    end
    node_descr.concat "\n"
    if (!children.nil?)
      children.each do |child| 
        node_descr.concat("#{child.internal_structure(indentation+1)}")
      end
    end
    return node_descr
  end

  # Iterate over current node and all its descendants
  def each
    self.traverse_down { |node| yield(node) }
  end

  # Run block on current node and all its descendants recursively
  def traverse_down(&block)
    block.call(self)
    if(!children.nil?)
      children.each{ |child| child.traverse_down(&block) }
    end
  end
  
  def eval(scope=Scope.new)
    last_result = nil    
    children.each do |child|
      last_result = child.eval(scope)
    end
    return last_result
  end
  
  def next_sibling
    if !root?
      index_of_self = parent.index_of_child(self)
      next_sibling = parent[index_of_self+1]
    end
  end

  def index_of_child(node)
    index_of_child = 0
    children.each_with_index do |sibling, i| 
      if(node.eql?(sibling))
        index_of_child = i
      end
    end
    index_of_child
  end

  def remove_child(node)
    orphan_index = index_of_child(node)
    children.slice!(orphan_index)
  end

  def replace_child(unwanted, new)
    unwanted_pos = index_of_child unwanted
    children[unwanted_pos] = new
  end

  def root?
    self.parent.nil?
  end  
end

