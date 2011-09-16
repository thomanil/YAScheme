class QuoteNode < AstNode

  def eval(context={})
    children[0]
  end

end
