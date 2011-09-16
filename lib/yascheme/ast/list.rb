class ListNode < AstNode

  # List eval = "run this list as a function"
  def eval(context={})
    procedure_name = children[0].node_value #first
    argument_nodes =  children[1..children.length] #rest
    delegated_method = "eval_#{procedure_name}"
    if self.respond_to? delegated_method
      self.send delegated_method, argument_nodes
    else
      eval_procedure_invocation procedure_name, argument_nodes
    end
  end

  def eval_car(argument_nodes)
    return argument_nodes[0].eval.children.first
  end

  def eval_cdr(argument_nodes)
    rest = argument_nodes[0].eval.children[1..children.length]
    new_list = ListNode.new
    rest.each { |item| new_list.add item }
    return new_list
  end

  def eval_cons(argument_nodes)
    arg1 = argument_nodes[0].eval
    arg2 = argument_nodes[1].eval
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
  end

  def eval_set!(argument_nodes)
    variable_name = argument_nodes[0].to_s
    value = argument_nodes[1].eval
    define_global variable_name, value
  end

  def eval_lambda(argument_nodes)
    # (lambda (formal params)(body))
    raise "not impl yet"
  end

  def eval_if(argument_nodes)
    test_result = argument_nodes[0].eval
    if test_result.true?
      return argument_nodes[1].eval
    else
      return argument_nodes[2].eval
    end
  end

  def eval_procedure_invocation(argument_nodes)
       # TODO call actual function definiton in scope
      raise "Function '#{procedure_name}' undefined"
  end
  
  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
