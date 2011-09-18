class NumberNode < AstNode
  
  def eval(scope=Scope.new)
    self
  end

  def to_s
    node_value
  end
  
end
