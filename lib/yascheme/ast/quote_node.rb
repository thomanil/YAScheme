class QuoteNode < AstNode

  def eval(scope = Scope.new)
    quoted_literal = children[0]
  end

end
