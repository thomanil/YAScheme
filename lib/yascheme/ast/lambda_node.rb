class LambdaNode < AstNode
  
  def eval(context={})
    return self
  end

  def to_s
    "(lambda ()())"
  end

  
end
