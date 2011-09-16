class IdentifierNode < AstNode
  
  def eval(context={})
    # TODO resolve identifier
      raise "Unresolved identifier '#{@node_value}'"
  end

  def to_s
    node_value
  end
  
end
