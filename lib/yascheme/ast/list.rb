class ListNode < AstNode

  # List eval is always "run this list as a function"
  def eval(context={})
    function_name = children[0].node_value
    arguments = children[1..children.length]
    # TODO call actual function definiton in scope
  end

  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
    
end
