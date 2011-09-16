class ListNode < AstNode

  # List eval = "run this list as a function"
  def eval(context={})
    procedure_name = first(children).node_value
    args = rest(children)
    evaluated_args = args.map { |argument| argument.eval  }

    # TODO Move these into separate module for core procedures
    
    
    case procedure_name
    when "car"
      return first(evaluated_args[0].children)
    when "cdr"
      rest = rest(evaluated_args[0].children)
      new_list = ListNode.new
      rest.each { |item|  new_list.add item }
      return new_list
    when "cons"
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
    when "set!"
      variable_name = args[0].to_s
      value = evaluated_args[1]
      define_global variable_name, value
    when "lambda"
      # (lambda (formal params)(body))
      raise "not impl yet"
    when "if"
      raise "not impl yet"
    else
      # TODO call actual function definiton in scope
      raise "Function '#{procedure_name}' undefined"
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
