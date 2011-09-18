class SymbolNode < AstNode
  
  def eval(scope=Scope.new)
    value = scope.lookup node_value
    if value.nil?
      raise "Unresolved identifier '#{node_value}', no such thing in scope!"  
    else
      return value
    end  
  end

  def to_s
    node_value
  end
  
end
