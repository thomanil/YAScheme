class ListNode < AstNode
  
  def eval(scope)
    arguments  = children[1..children.length]
    procedure = eval_first_element children[0], scope
    primitive_procedure_call procedure, arguments, scope
  end

  def eval_first_element(first_element, scope)
    if first_element.class == ListNode
      first_element = first_element.eval scope
    else
      first_element = first_element.node_value
    end
  end

  def primitive_procedure_call(name, argument_nodes, scope)
    procedures = PrimitiveProcedures.new
    if procedures.respond_to? "eval_#{name}"
      procedures.send "eval_#{name}", argument_nodes, scope
    else
      procedures.eval_call_lambda name, argument_nodes, scope
    end    
  end
  
  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
