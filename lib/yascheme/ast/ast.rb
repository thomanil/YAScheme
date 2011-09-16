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
  
  def each
    self.walk { |node| yield(node) }
  end

  def walk(&block)
    block.call(self)
    if(!children.nil?)
      children.each{ |child| child.walk(&block) }
    end
  end

  def eval(context={})
    last_result = nil
    children.each { |child| last_result = child.eval(context) }
    return last_result
  end
  
  def next_sibling
    index_of_self = parent.index_of_child(self)
    next_sibling = parent.children[index_of_self+1]
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


  
end

