class BooleanNode < AstNode
  
  def eval(scope=Scope.new)
    return self
  end

  def to_s
    node_value
  end

  def true?
    if node_value == "#t"
      return true
    elsif node_value == "#f"
      return false
    else
      raise "Error - #{node_value} is not a valid boolean literal"
    end
  end
  
end
