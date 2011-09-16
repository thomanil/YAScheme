class ListNode < AstNode

  # List eval is always "run this list as a function"
  def eval(context={})
    function_name = children[0].node_value
    args = children[1..children.length]
    evaluated_args = args.map { |argument| argument.eval  }
    
    
    case function_name
    when "car"
      # todo check # and type of arguments
      # argument must be a list
      list_argument = evaluated_args
      return list_argument[0].children.first 
    else
      raise "Function '#{function_name}' undefined"
    end

    
    # TODO call actual function definiton in scope
  end

  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
    
end
