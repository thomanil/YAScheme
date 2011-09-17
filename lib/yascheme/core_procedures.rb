# These are the procedures/forms that are cannot be expressed in Scheme
# itself. The rest of the language is what the R5RS spec calls
# "library" syntax/procedures, and can be defined/self-hosted in the
# scheme language itself given these core underlying procedures.
# (YAScheme defines the rest of itself in  ./scheme_code/libraries.scm)
module CoreProcedures

  def eval_set!(argument_nodes)
    variable_name = argument_nodes[0].to_s
    value = argument_nodes[1].eval
    define_global variable_name, value
  end

  def eval_define(argument_nodes)
    eval_set! argument_nodes
  end

  def eval_if(argument_nodes)
    test_result = argument_nodes[0].eval
    if test_result.true?
      return argument_nodes[1].eval
    else
      return argument_nodes[2].eval
    end
  end

  def eval_lambda(argument_nodes)
    # (lambda (formal params)(body))
    raise "not impl yet"
  end

  def eval_procedure_invocation(procedure_name, argument_nodes)
    # TODO call actual function definiton in scope
    raise "Function '#{procedure_name}' undefined"
  end

  def eval_let_syntax
    
  end

  def eval_letrec_syntax

  end


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

  def eval_car(argument_nodes)
    argument_nodes[0].eval.children.first
  end

  def eval_cdr(argument_nodes)
    rest = argument_nodes[0].eval.children[1..children.length]
    new_list = ListNode.new
    rest.each { |item| new_list.add item }
    return new_list
  end

  def eval_cons(argument_nodes)
    arg1 = argument_nodes[0].eval
    arg2 = argument_nodes[1].eval
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
