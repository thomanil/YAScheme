class ListNode < AstNode
  include PrimitiveProcedures

  # List eval = "run this list as a function"
  def eval(context={})
    procedure_name = children[0]

    # Procedure name can itself be a list/procedure
    if procedure_name.class == ListNode
      procedure_name = procedure_name.eval.node_value
    else
      procedure_name = procedure_name.node_value
    end
    
    argument_nodes =  children[1..children.length] #rest
    delegated_method = "eval_#{procedure_name}"
    if self.respond_to? delegated_method
      self.send delegated_method, argument_nodes
    else
      eval_procedure_invocation procedure_name, argument_nodes
    end
  end
  
  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
