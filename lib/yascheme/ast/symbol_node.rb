class SymbolNode < AstNode
  
  def eval(context=self)
    value = context.lookup node_value
    if value.nil?
      raise "Unresolved identifier '#{@node_value}'"  
    else
      return value
    end  
  end

  def to_s
    node_value
  end
  
end
