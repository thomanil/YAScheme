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
    validate_calling_arguments arguments
    body_list_node.eval context
  end

  def validate_calling_arguments(arguments)
    if arguments.count != @expected_argument_names.count
      raise "Expected #{@expected_argument_names.count} args, received #{arguments.count} args"
    end
  end

  def bind_parameters(arguments)
    arguments.each_with_index do |argument_value, i|
      define_local(@expected_argument_names[i], argument_value)
    end
  end

  def to_s
    "#<procedure>"
  end
  
end


