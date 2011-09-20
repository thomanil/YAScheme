require File.dirname(__FILE__) + '/test_helper.rb'

class TestInterpreter < Test::Unit::TestCase

  def setup
    @interpreter = Interpreter.new
  end

  def test_number_literal
    assert_equal "42",  @interpreter.run("42")
  end

  def test_string_literal
    assert_equal "\"this is a string\"",  @interpreter.run("\"this is a string\"")
  end  

  def test_boolean_literal
    assert_equal "#t",  @interpreter.run("#t")
  end
  
  def test_quoted_forms
    assert_equal "hello",  @interpreter.run("'hello")
    assert_equal "(1 2)",  @interpreter.run("'(1 2)")
    assert_equal "(identifier 1 \"string\")", @interpreter.run("'(identifier 1 \"string\")")
    assert_equal "(1 (2 3))",  @interpreter.run("'(1 (2 3))")
    assert_equal "(1 two \"three\")",  @interpreter.run("'(1 two \"three\")")
  end
  
  def test_load_library_file
    assert_raise(RuntimeError) { @interpreter.run("scheme-report-version") }
    @interpreter.load_libraries
    assert_equal "5", @interpreter.run("scheme-report-version")
  end
  
  def test_car
    assert_equal "1", @interpreter.run("(car '(1 2 3))")
  end

  def test_cdr
    assert_equal "(2 3)", @interpreter.run("(cdr '(1 2 3))")
  end

  def test_cons
    assert_equal "(2 3)", @interpreter.run("(cons 2 3)")
    assert_equal "(2 3)", @interpreter.run("(cons 2 '(3))")
    assert_equal "((1 2) 3)", @interpreter.run("(cons '(1 2) 3)")
    assert_equal "((1) 2 3)", @interpreter.run("(cons '(1) '(2 3))")
  end
  
  def test_set_expression
    assert_raise(RuntimeError) { @interpreter.run("foo") }

    set_then_resolve = <<CODE
 (set! 'foo 42)
 foo
CODE
    assert_equal "42",  @interpreter.run(set_then_resolve)
  end

  def test_define_expressions_essentially_same_as_set_exp
    assert_raise(RuntimeError) { @interpreter.run("foo") }

    define_then_resolve = <<CODE
(define 'foo 42)
foo
CODE
    assert_equal "42",  @interpreter.run(define_then_resolve)
  end
  
  def test_if_statement   
    assert_equal "42", @interpreter.run("(if #t 42 69)")
    assert_equal "69", @interpreter.run("(if #f 42 69)")
  end
  
  def test_state_preserved_between_each_interpreter_run
    @interpreter.run("(set! 'foo 42)")   
    assert_equal "42",  @interpreter.run("foo")    
  end

  def test_run_multiple_top_level_expressions
    definitions = <<CODE
(set! 'foo 42)
(set! 'bar 69)
CODE
    @interpreter.run(definitions)
    assert_equal "42",  @interpreter.run("foo")
    assert_equal "69",  @interpreter.run("bar")
  end
  
  def test_list_operator_should_also_be_evaluated
    @interpreter.run("(set! 'foo 'set!)")   
    @interpreter.run("((if #f + foo) bar 69)")
    assert_equal "69", @interpreter.run("bar")
  end

  def test_lambda_definition
    assert_equal "#<procedure>", @interpreter.run("(lambda()20)")
  end

  def test_inline_lambda_call
    assert_equal "20", @interpreter.run("((lambda()20))")
  end

  def test_inline_lambda_call_to_definition
    def_and_call = <<CODE
  (define baz 12)
  ((lambda () baz))
CODE
    assert_equal "12", @interpreter.run(def_and_call)
  end
  
  def test_inline_lambda_def_and_call_with_argument
    inline_call_with_argument  = "((lambda (l)(car l)) '(50 100))"
    assert_equal "50", @interpreter.run(inline_call_with_argument) 
  end
  
  def test_define_and_call_lambda
    defined_car_proxy_procedure = <<CODE
  (define car-proxy-no-params
    (lambda ()
      (car '(42 69))))

  (car-proxy-no-params)
CODE
    assert_equal "42", @interpreter.run(defined_car_proxy_procedure) 
  end

  def test_define_and_call_lambda_with_arguments
    defined_car_proxy_procedure = <<CODE
  (define car-proxy
    (lambda (l)
      (car l)))

  (car-proxy '(200 400))
CODE
    assert_equal "200", @interpreter.run(defined_car_proxy_procedure) 
  end

  def test_call_lambda_with_non_matching_params
    def_and_call = <<CODE
  (define one-param-proc
    (lambda (l)
      (car l)))
  (one-param-proc 3 4)
CODE
    assert_raise(RuntimeError) { @interpreter.run(def_and_call) }
  end

  def test_lambda_multiple_expr_in_body
    multiple_inner = <<CODE
  (define multiple
    (lambda ()
      (define foo 123)
      (define foo 345)
      foo))

  (multiple)
CODE
    assert_equal "345", @interpreter.run(multiple_inner) 
  end

 def test_define_and_call_inner_proc
    def_proc_with_inner_proc = <<CODE
  (define outer-proc
    (lambda ()
      (define inner-proc
        (lambda ()
          111))
        (inner-proc)))
  
  (outer-proc)
CODE
    assert_equal "111", @interpreter.run(def_proc_with_inner_proc)     
  end  
  
#   def test_inner_variables_shouldnt_visible_globally
#     def_proc_with_inner_variable = <<CODE
#   (define the-definer
#     (lambda ()
#       (define 'foo 42)
#       42))
  
#  (the-definer)
#  foo
# CODE
#     assert_raise(RuntimeError) { @interpreter.run(def_proc_with_inner_variable) }
#   end

  def test_local_variables_gone_after_surrounding_expression_finished
    
  end
  
 #  def test_inner_lambdas_should_not_be_visible_globally
#       def_proc_with_inner_proc = <<CODE
#        (define outer-proc
#         (lambda ()
#           (define inner-proc
#             (lambda ()
#               111))
#           (inner-proc)))
#       (outer-proc)
#       (inner-proc)
# CODE
#           assert_raise(RuntimeError) { @interpreter.run(def_proc_with_inner_proc) }
#   end


  def test_lexical_scope_inner_lambda_def_binds_surrounding_scope
    # Define and use variable in lexical scope using inner lambda
  end

  def test_lexical_scope_closures_preserve_bound_variables_after_surrounding_lambda_call
    # Use lambda and closure to create module with persistent state, keep
    # updating variable in closure.
  end
  
end
