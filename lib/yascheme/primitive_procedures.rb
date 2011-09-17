# These are the procedures/forms that are cannot be expressed in Scheme
# itself. The rest of the language is what the R5RS spec calls
# "library" syntax/procedures, and can be defined/self-hosted in the
# scheme language itself given these underlying primitive procedures.
# (YAScheme defines the rest of itself in  ./scheme_code/library_procedures.scm)
module PrimitiveProcedures

  # Define variable
  def eval_set!(argument_nodes, context)
    variable_name = argument_nodes[0].to_s
    value = argument_nodes[1].eval
    define_global variable_name, value
  end

  # Equvivalent with set!
  def eval_define(argument_nodes, context)
    eval_set! argument_nodes, context
  end

  # If first argument is true, eval second argument. Otherwise eval
  # third argument.
  def eval_if(argument_nodes, context)
    test_result = argument_nodes[0].eval
    if test_result.true?
      return argument_nodes[1].eval
    else
      return argument_nodes[2].eval
    end
  end

  # Creates and returns lambda expression
  def eval_lambda(argument_nodes, context)
    param_node_list = argument_nodes[0]
    param_names = param_node_list.map { |node| node.node_value }
    param_names = param_names.reject { |name| name.nil? }
    body_node_list = argument_nodes[1..argument_nodes.length]
    LambdaNode.new param_names, body_node_list
  end

  # Finds named procedure in scope and executes it with given arguments 
  def eval_call_lambda(proc_name, argument_nodes, context)     
    proc_name = proc_name
    lookedup_lambda = context.lookup proc_name
    if lookedup_lambda.nil?
      raise "Proc_Name '#{proc_name}' undefined"
    else
      lookedup_lambda.call_with_arguments argument_nodes, context
    end
  end

  def eval_let_syntax
    
  end

  def eval_letrec_syntax

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
  # +
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

  def eval_car(argument_nodes, context)
    argument_nodes[0].eval(context).children.first
  end

  def eval_cdr(argument_nodes, context)
    rest = argument_nodes[0].eval(context).children[1..children.length]
    new_list = ListNode.new
    rest.each { |item| new_list.add item }
    return new_list
  end

  def eval_cons(argument_nodes, context)
    arg1 = argument_nodes[0].eval(context)
    arg2 = argument_nodes[1].eval(context)
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
