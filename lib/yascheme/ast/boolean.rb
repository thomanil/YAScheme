class BooleanNode < AstNode
  
  def eval(context={})
    return self
  end

  def to_s
    node_value
  end
  
end
