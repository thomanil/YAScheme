class Interpreter
  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    # TODO load and eval "optional, library, extensions" scheme code from here
  end

  def evaluate(code)
    tokens = @lexer.tokenize(code)
    ast_tree = @parser.ast_tree(tokens)
    walk ast_tree
  end


  def walk(node, context={})
    type = node.node_type
    children = node.children
   
    if(type.eql?(:root))
      children.each { |child| @last_result = walk(child, context) }
      @last_result
    elsif(type.eql?(:list))
      function_name = children[0].node_value
      if(operator? function_name) # TODO do this for nonquoted list
        arguments = children[1..children.length]
        call_function(function_name, arguments, context)
      else # TODO Do this if list is quoted
        list = []
        children.each { |child| list.push(walk(child, context)) }
        list
      end
    elsif(type.eql?(:quote))
      # TODO supports (quote ...) form, also implement ' form as reader macro
      # TODO return quoted data
    elsif(type.eql?(:symbol))
      # TODO get value of referenced variable
      # TODO if quoted, just get the symbol name
      node.literal_value
    elsif(type.eql?(:string) || 
          type.eql?(:number))
      node.literal_value    
    else
      raise "Walking ast tree, encountered unknown node type '#{node.node_type}'"
    end
  end

  # TODO only used for testing until quoting works, remove!
  def operator?(symbol)
    symbol[/\A([\+\-\/\*])/]
  end

  # TODO support more built-in functions
  # TODO + actually find other functions in context
  def call_function(name, argument_atoms, context={})
    case name
    when "+"
      sum = argument_atoms.map {|atom| walk(atom)}.join("+")
      return Kernel.eval(sum)
    when "-"
      sum = argument_atoms.map {|atom| walk(atom)}.join("-")
      return Kernel.eval(sum)
    when "*"
      sum = argument_atoms.map {|atom| walk(atom)}.join("*")
      return Kernel.eval(sum)
    when "/"
      sum = argument_atoms.map {|atom| walk(atom)}.join("/")
      return Kernel.eval(sum)
    else
      raise "Function '#{name}' undefined"
    end
  end
   
end




