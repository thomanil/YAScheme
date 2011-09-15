class StringNode < AstNode
  
  def eval(context={})
    return "#{@node_value}"
  end
  
end
