class NumberNode < AstNode
  
  def eval(context=self)
    self
  end

  def to_s
    node_value
  end
  
end
