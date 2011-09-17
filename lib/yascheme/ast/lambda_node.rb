class LambdaNode < AstNode

  attr_accessor :argument_list_node, :body_list_node

  def initialize(arguments, body)
    super()
    @argument_list_node = arguments
    @body_list_node = body
  end
  
  def eval(context={})
    body_list_node.eval
  end

  def to_s
    "#<procedure>"
  end
  
end
