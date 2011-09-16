class ListNode < AstNode

  # List eval = "run this list as a function"
  def eval(context={})
    procedure_name = first(children).node_value
    args = rest(children)
    evaluated_args = args.map { |argument| argument.eval  }

    # TODO Move these into separate module for core procedures
    
    
    case procedure_name
    when "car"
      # todo check # and type of arguments
      # argument must be a list
      return first(evaluated_args[0].children)
    when "cdr"
      # todo check # and type of arguments
      # argument must be a list
      rest = rest(evaluated_args[0].children)
      new_list = ListNode.new
      rest.each { |item|  new_list.add item }
      return new_list
    when "cons"
      # todo check # and type of arguments
      # argument must be a list
      arg1 = evaluated_args[0]
      arg2 = evaluated_args[1]
   
      if arg2.class == ListNode
        consed_list = arg2
        arg2.children.insert(0, arg1)
        return consed_list
      else
        consed_list = ListNode.new
        consed_list.add arg1
        consed_list.add arg2
        return consed_list
      end
    when "lambda"
      # (lambda (formal params)(body))
      raise "not impl yet"
    when "if"
      raise "not impl yet"
    when "set!"
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

  def first(array)
    array.first
  end
  
  def rest(array)
    array[1..array.length]
  end
  
end
