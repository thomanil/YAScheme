class LambdaNode < AstNode

  attr_accessor :expected_argument_names, :body_list_node

  def initialize(param_names_array, body)
    super()
    @expected_argument_names = param_names_array
    @body_list_node = body
  end
  
  def eval(context={})
    body_list_node.eval
  end

  def call_with_arguments(arguments)
    # TODO check number of args. Must be equal to expected arguments!

    # bind each argument locally with its matching expected names
    arguments.each_with_index do |argument_value, i|
      #puts "defining #{@expected_argument_names[i]} as: #{argument_value}"
      define_local(@expected_argument_names[i], argument_value)
    end

    # todo evals should take an ast as context, updatede everywhere?
    # looking up values should happen both in current and called context
    body_list_node.eval
  end

  def to_s
    "#<procedure>"
  end
  
end
