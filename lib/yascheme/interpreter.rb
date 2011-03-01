class Interpreter
  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    # TODO load and eval "optional, library, extensions" scheme code from here
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    ast_tree = @parser.ast_tree(tokens)
    eval ast_tree
  end

  def eval(node, context={})
    type = node.node_type
    children = node.children
   
    if(type.eql?(:root))
      children.each { |child| @last_result = eval(child, context) }
      @last_result
    elsif(type.eql?(:list))
      function_name = children[0].node_value
      arguments = children[1..children.length]
      call_function(function_name, arguments, context)
    elsif(type.eql?(:quote))
      # TODO if list, return list as data
      #  list = []
      #  children.each { |child| list.push(eval(child, context)) }
      #  list
      # TODO else if atom, return atom name
    elsif(type.eql?(:symbol))
      # TODO resolve variable binding
      node.literal_value
    elsif(type.eql?(:string) || 
          type.eql?(:number))
      node.literal_value    
    else
      raise "Evaling ast tree, encountered unknown node type '#{node.node_type}'"
    end
  end

  # TODO support more built-in functions
  # TODO + actually find other functions in context
  # TODO move arithmetic and other basis stuff to scheme library definition
  def call_function(name, argument_atoms, context={})
    case name
    when "+"
      sum = argument_atoms.map {|atom| eval(atom)}.join("+")
      return Kernel.eval(sum)
    when "-"
      sum = argument_atoms.map {|atom| eval(atom)}.join("-")
      return Kernel.eval(sum)
    when "*"
      sum = argument_atoms.map {|atom| eval(atom)}.join("*")
      return Kernel.eval(sum)
    when "/"
      sum = argument_atoms.map {|atom| eval(atom)}.join("/")
      return Kernel.eval(sum)
    else
      raise "Function '#{name}' undefined"
    end
  end
   
end
