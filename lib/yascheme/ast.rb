class AstNode
  include Enumerable

  attr_accessor :parent, :children
  attr_accessor :node_type, :node_value
 
  def initialize
    @children = []
    @node_value = ""
    @last_result = nil
  end

  def add(child)
     @children.push child
    child.parent = self
  end
  
  def [](index)
    @children[index]
  end

  def to_s
    tree_structure_to_s
  end
  
  def tree_structure_to_s(indentation=0)
    node_descr = ""
    indentation.times { node_descr.concat "  " }
    node_descr.concat "#{@node_type}"
    node_descr.concat " #{@node_value}\n"
    children.each do |child| 
      node_descr.concat("#{child.tree_structure_to_s(indentation+1)}")
    end
    return node_descr
  end
  
  def each
    self.walk { |node| yield(node) }
  end

  def walk(&block)
    block.call(self)
    children.each{ |child| child.walk(&block) }
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
  
  def eval(context={})
    children.each { |child| @last_result = child.eval(context) }
    return @last_result
  end



  
end

