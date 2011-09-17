class QuoteNode < AstNode

  def eval(context=self)
    quoted_literal = children[0]
  end

end
