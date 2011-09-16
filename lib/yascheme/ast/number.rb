class NumberNode < AstNode
  
  def eval(context={})
    return "#{@node_value}"
  end

  def to_s
    node_value
  end
  
end
