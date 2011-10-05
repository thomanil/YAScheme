# These are the procedures/forms that cannot be expressed in Scheme
# itself. The rest of the language is what the R5RS spec calls
# "library" syntax/procedures, and can be defined/self-hosted in the
# scheme language itself given these underlying primitive procedures.
# (YAScheme defines the rest of itself in  ./scheme_code/library_procedures.scm)
class PrimitiveProcedures

  def initialize
    define_core_syntax_procedures
    define_number_procedures
    define_list_procedures

    #...
  end

  # Invoke a procedure which has been previously been defined as a lambda expr in the
  # syntax tree.
  def call_lambda_in_scope(proc, argument_nodes, scope)     
    if proc.class != LambdaNode
      proc = lookup_procedure_in_scope proc, Scope.new(scope)
    end
    proc.call_with_arguments argument_nodes, Scope.new(scope)
  end
  
  def lookup_procedure_in_scope proc_name, scope
    lookedup_lambda = scope.lookup proc_name
    if lookedup_lambda.nil?
      raise "Procedure '#{proc_name}' not defined in scope"
    end
    return lookedup_lambda
  end

  # DSL for creating and invoking each primitive procedure, as well as
  # for validating expected procedure params.
  # Main benefit is that list_node eval can dispatch based on method
  # name. We can define procedures with any string name as
  # opposed to regular ruby method names (Ruby barfs on hyphens etc in
  # method name). Also avoids conflicts with Ruby methods (+,-, or, and....)
  
  def procedure(name, &proc_block)
    internal_proc_name = "proc"+rand(1000000).to_s
    @procedures ||= {}
    @procedures[name] = internal_proc_name
    self.class.send(:define_method, internal_proc_name, &proc_block)
  end

  def call_procedure(name, argument_nodes, scope)
    if scope.nil?
      raise "Scope argument cannot be nil!"
    end
    @procedures ||= {}
    if !procedure_defined? name
      raise "No primitive procedure called '#{name}' is defined!"
    end
    internal_proc_name = @procedures[name]
    self.send(internal_proc_name.to_sym, argument_nodes, scope)
  end
  
  def procedure_defined? name
    !@procedures[name].nil?
  end
  
  def expects actual, expected
    argument_nodes = actual.children
    if expected.count != argument_nodes.count
      raise "Expected #{expected.count}, received #{argument_nodes.count}"
    end
    argument_nodes.each_with_index do |argument_node, i|
      if argument_node.class != expected[i]
        raise "Expected #{expected[i]} in arg #{i}, received #{argument_node.class}"
      end
    end
    true
  end

  # CORE SYNTAX

  def define_core_syntax_procedures
    
    # Set variable value
    procedure "set!" do |argument_nodes, scope|
      variable_name = argument_nodes[0].to_s
      value = argument_nodes[1].eval scope
      scope.define variable_name, value
    end

    # Equvivalent with set!
    procedure "define" do |argument_nodes, scope|
      call_procedure "set!", argument_nodes, scope
    end

    # If first argument is true, eval second argument. Otherwise eval
    # third argument.
    procedure "if" do |argument_nodes, scope|        
      test_result = argument_nodes[0]
      if test_result.true?
        return argument_nodes[1].eval scope
      else
        return argument_nodes[2].eval scope
      end
    end

    # Creates and returns lambda expression
    procedure "lambda" do |argument_nodes, scope|
      param_node_list = argument_nodes[0]
      param_names = param_node_list.map { |node| node.node_value }
      param_names = param_names.reject { |name| name.nil? }
      body_node_list = argument_nodes[1..argument_nodes.length]
      LambdaNode.new param_names, body_node_list, scope
    end
    
    
    procedure "let_syntax" do |argument_nodes, scope|
      
    end

    procedure "letrec_syntax" do |argument_nodes, scope|
      
    end

  end

  
  # QUASIQUOTATION
  # quasiquote
  
  # EQUIVALENCE PREDICATES
  # eqv?
  # eq?
  
  # NUMBERS
  # number?
  # complex?
  # real?
  # rational?
  # integer?
  # exact?
  # inexact?
  # =
  # <
  # >
  # <=
  # >=

  def define_number_procedures

    procedure "+" do |argument_nodes, scope|
      a, b = arithmetic_argument_values argument_nodes, scope
      NumberNode.new(a+b)
    end
    
    procedure "-" do |argument_nodes, scope|
      a, b = arithmetic_argument_values argument_nodes, scope
      NumberNode.new(a-b)
    end

    procedure "*" do |argument_nodes, scope|
      a, b = arithmetic_argument_values argument_nodes, scope
      NumberNode.new(a*b)
    end

    procedure "/" do |argument_nodes, scope|
      a, b = arithmetic_argument_values argument_nodes, scope
      NumberNode.new(a/b)
    end
  end
  
  def arithmetic_argument_values(argument_nodes, scope)
    a = argument_nodes[0].eval(scope).node_value.to_i
    b = argument_nodes[1].eval(scope).node_value.to_i
    return a, b
  end
  
  
  # *
  # - a b
  # - a
  # / a b
  # / a
  # quotient
  # remainder
  # modulo
  # numerator
  # denominator
  # floor
  # ceiling
  # truncate
  # round
  # sqrt
  # expt
  # make-rectangular
  # make-polar
  # real-part
  # imag-part
  # magnitude
  # angle
  # exact->inexact
  # inexact->exact
  # number->string a
  # number->string a radix
  # string->number a
  # string->number a radix

  # BOOLEANS
  # (only library procedures) 
  
  # LISTS AND PAIRS

  # pair?

  def define_list_procedures
    
    procedure "car" do |argument_nodes, scope|
      argument_nodes[0].eval(Scope.new(scope)).children.first
    end

    procedure "cdr" do |argument_nodes, scope|
      evaluated_args = argument_nodes[0].eval(Scope.new(scope))
      rest = evaluated_args.children[1..evaluated_args.children.length]
      new_list = ListNode.new
      rest.each { |item| new_list.add item }
      return new_list
    end

    procedure "cons" do |argument_nodes, scope|
      arg1 = argument_nodes[0].eval(Scope.new(scope))
      arg2 = argument_nodes[1].eval(Scope.new(scope))
      if arg2.class == ListNode
        consed_list = arg2
        arg2.children.insert(0, arg1)
        return consed_list
      else
        consed_list = ListNode.new
        consed_list.add arg1
        consed_list.add arg2
        return consed_list
      end
    end

  end

  # set-cat!
  # set-cdr!

  
  # SYMBOLS
  # symbol?
  # symbol->string
  # string->symbol

  # CHARACTERS
  # char?
  # char=?
  # char<?
  # char>?
  # char>=?
  # char<=?
  # char->integer
  # integer->char
  
  # STRINGS
  # string?
  # make-string k
  # make-string k char
  # string-length
  # string-ref
  # string-set!

  # VECTORS
  # vector?
  # make-vector k 
  # make-vector k fill
  # vector-length
  # vector-ref

  # CONTROL FEATURES
  # procedure?
  # apply
  # call-with-current-continuation
  # values
  # call-with-values
  # dynamic-wind

  # EVAL
  # eval
  # null-environment

  # INPUT AND OUTPUT
  # call-with-input-file
  # call-with-output-file
  # input-port?
  # output-port?
  # current-input-port
  # current-output-port
  # open-input-file
  # open-output-file
  # close-input-port
  # close-output-port
  # read-char
  # read-char port
  # peek-char
  # peek-char port
  # eof-object?
  # char-ready?
  # char-ready? port
  # write-char char
  # write-char char port
  # load-filename

  
end
