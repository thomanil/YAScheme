class QuoteNode < AstNode

  def eval(context={})
    if children.count == 1
      return children[0]
    else
      list = ListNode.new
      self.children.each { |child| list.add child  }
      puts "Created list node: "+list.internal_structure
      return list
    end
  end

end
