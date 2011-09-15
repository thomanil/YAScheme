class AstNode
  include Enumerable

  attr_accessor :parent, :children
  attr_accessor :node_value
  
  def initialize(*options)
    @node_value = options[0]
    @node_type = options[1]
    @children = []
  end

  def node_type
    @node_type
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
    if (!children.nil?)
      children.each do |child| 
        node_descr.concat("#{child.tree_structure_to_s(indentation+1)}")
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
    if(@node_type.eql?(:root))
      children.each { |child| @last_result = child.eval(context) }
      @last_result
    elsif(@node_type.eql?(:list)) #unquoted lists are always procedure calls
      function_name = children[0].node_value
      arguments = children[1..children.length]
      call_function(function_name, arguments, context)
    elsif(@node_type.eql?(:quote))
      # TODO if list, return list as data
      #  list = []
      #  children.each { |child| list.push(eval(child, context)) }
      #  list
      # TODO else if atom, return atom name
    elsif(@node_type.eql?(:symbol))
      # TODO resolve identifier
      raise "Unresolved identifier '#{@node_value}'"
    elsif(@node_type.eql?(:string) || 
          @node_type.eql?(:number))
      Kernel.eval("#{@node_value}")
    end
  end

  # TODO support more built-in functions
  # TODO + actually find other functions in context
  # TODO move arithmetic and other basis stuff to scheme library definition
  def call_function(name, argument_atoms, context={})
    case name
    when "+"
      sum = argument_atoms.map {|atom| atom.node_value}.join("+")
    when "-"
      sum = argument_atoms.map {|atom| atom.node_value}.join("-")
    when "*"
      sum = argument_atoms.map {|atom| atom.node_value}.join("*")
    when "/"
      sum = argument_atoms.map {|atom| atom.node_value}.join("/")
    end

    return Kernel.eval("#{sum}")    
  end


  
end

