class QuoteNode < AstNode

  def eval(context={})
    quoted_children = ""
    children.map { |node| node.node_value }.join("")
  end
  
end
