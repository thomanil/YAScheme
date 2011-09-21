class LambdaNode < AstNode

  attr_accessor :expected_argument_names, :body_list_node

  def initialize(param_names_array, body, scope)
    super()
    @expected_argument_names = param_names_array
    @body_list_node = body
    @lexical_scope = scope
  end
  
  def eval(scope)
    self
  end

  def call_with_arguments(arguments, scope)
    validate_calling_arguments arguments
    bind_parameters arguments, scope
    bind_lexical_scoped_variables scope
    last_result = nil
    body_list_node.each { |expression| last_result = expression.eval scope}
    return last_result
  end

  def validate_calling_arguments(arguments)
    if arguments.count != @expected_argument_names.count
      raise "Expected #{@expected_argument_names.count} args, received #{arguments.count} args"
    end
  end

  def bind_parameters(arguments, scope)
    arguments.each_with_index do |argument_value, i|
      evaluated_argument = argument_value.eval scope
      scope.define(@expected_argument_names[i], evaluated_argument)
    end
  end

  def bind_lexical_scoped_variables(scope)
    @lexical_scope.innermost_scoped_symbol_table.each do |variable_name, ast_node|
      scope.define(variable_name, ast_node)
    end
  end

  def to_s
    "#<procedure>"
  end
  
end


