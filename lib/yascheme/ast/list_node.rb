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
    # TODO ugly: sometimes name is really an evaluated symbol object,
    # so we explicitly cast .to_s. Can this be done more elegantly?
    if procedures.procedure_defined? name.to_s
      procedures.call_procedure name.to_s, argument_nodes, scope
    else
      # TODO sometimes "name" is really an anonymous procedure
      # object which we pass along and is specially ahandled in
      # call_lambda_in_scope.
      # Make this more straight forward!
      procedures.call_lambda_in_scope name, argument_nodes, scope      
    end
  end

  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
