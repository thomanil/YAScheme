class ListNode < AstNode
  include PrimitiveProcedures  

  # List eval = "run this list as a function"
  def eval(context=self)
    first_element = children[0]
    if first_element.class == ListNode
      first_element = first_element.eval context
    else
      first_element = first_element.node_value
    end
    
    procedure_name = first_element
    argument_nodes =  children[1..children.length] #rest
    
    delegated_method = "eval_#{procedure_name}"
    
    if self.respond_to? delegated_method # Primitive procedure
      self.send delegated_method, argument_nodes, context
    else # regular lambda invocation
      eval_lambda_invocation procedure_name, argument_nodes, context
    end
  end
  
  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
