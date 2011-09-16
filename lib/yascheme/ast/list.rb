class ListNode < AstNode

  # List eval = "run this list as a function"
  def eval(context={})
    procedure_name = children.first.node_value
    args = children[1..children.length]
    evaluated_args = args.map { |argument| argument.eval  }
        
    case procedure_name
    when "car"
      # todo check # and type of arguments
      # argument must be a list
      list_argument = evaluated_args
      return list_argument[0].children.first
    when "cdr"
      raise "not impl yet"
    when "cons"
      raise "not impl yet"
    when "lambda"
      # (lambda (formal params)(body))
      raise "not impl yet"
    when "if"
      raise "not impl yet"
    else
      # TODO call actual function definiton in scope
      raise "Function '#{function_name}' undefined"
    end
  end

  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
    
end
