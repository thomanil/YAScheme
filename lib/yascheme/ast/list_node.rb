class ListNode < AstNode
  include PrimitiveProcedures  

  # List eval = "run this list as a function"
  def eval(context=self)
    procedure_name = eval_first_element children[0], context
    argument_nodes =  children[1..children.length] #rest
    primitive_procedure_call procedure_name, argument_nodes, context
  end

  def primitive_procedure_call(name, argument_nodes, context)
    if self.respond_to? "eval_#{name}"
      self.send "eval_#{name}", argument_nodes, context
    else
      eval_call_lambda name, argument_nodes, context
    end    
  end

  def eval_first_element(first_element, context)
    if first_element.class == ListNode
      first_element = first_element.eval context
    else
      first_element = first_element.node_value
    end
    procedure_name = first_element
  end
  
  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
  
end
