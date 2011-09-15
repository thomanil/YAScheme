class ListNode < AstNode

  def eval(context={})
    function_name = children[0].node_value
    arguments = children[1..children.length]
    call_function(function_name, arguments, context)
  end

  # TODO support more built-in functions
  # TODO + actually find other functions in context
  # TODO move arithmetic and other basis stuff to scheme library definition
  def call_function(name, argument_cells, context={})
    case name
    when "+"
      sum = argument_cells.map { |cell| cell.eval }.join("+")
    when "-"
      sum = argument_cells.map { |cell| cell.eval }.join("-")
    when "*"
      sum = argument_cells.map { |cell| cell.eval }.join("*")
    when "/"
      sum = argument_cells.map { |cell| cell.eval }.join("/")
    end

    return Kernel.eval("#{sum}")    
  end
  
  
end
