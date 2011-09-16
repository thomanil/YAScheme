class SymbolNode < AstNode
  
  def eval(context={})
    # TODO resolve identifier binding
      raise "Unresolved identifier '#{@node_value}'"
  end

  def to_s
    node_value
  end
  
end
