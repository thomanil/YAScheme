class StringNode < AstNode
  
  def eval(scope)
    self
  end

  def to_s
    node_value
  end

end
