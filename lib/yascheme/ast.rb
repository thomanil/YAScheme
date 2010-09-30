class AstNode
  attr_accessor :parent, :children
  attr_accessor :node_type, :node_value
 
  def initialize
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
    node_to_s
  end
  
  def node_to_s(indentation=0)
    node_descr = ""
    indentation.times { node_descr.concat "  " }
    node_descr.concat "#{@node_type}"
    node_descr.concat " '#{@node_value}'" if @node_value
    children.each do |child| 
      node_descr.concat("\n#{child.node_to_s(indentation+1)}")
    end
    return node_descr
  end

  def literal_value
    eval(@node_value)
  end

  def walk(&block)
    block.call(self)
    children.each{ |child| child.walk(&block) }
  end

end

