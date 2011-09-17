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

  def test_library_file_loaded
    assert_equal "5", @interpreter.run("scheme-report-version")
  end

end
