class LambdaNode < AstNode

  attr_accessor :expected_argument_names, :body_list_node

  def initialize(param_names_array, body)
    super()
    @expected_argument_names = param_names_array
    @body_list_node = body
  end
  
  def eval(context=self)
    self
  end

  def call_with_arguments(arguments, context)
    self.parent = context # Hooking this node into global context
    validate_calling_arguments arguments
    bind_parameters arguments, self # Sending lambda as context
    last_result = nil
    body_list_node.each { |expression| last_result = expression.eval self}
    return last_result
  end

  def validate_calling_arguments(arguments)
    if arguments.count != @expected_argument_names.count
      raise "Expected #{@expected_argument_names.count} args, received #{arguments.count} args"
    end
  end

  def bind_parameters(arguments, context)
    arguments.each_with_index do |argument_value, i|
      evaluated_argument = argument_value.eval context
      context.define_local(@expected_argument_names[i], evaluated_argument)
    end
  end

  def to_s
    "#<procedure>"
  end
  
end


