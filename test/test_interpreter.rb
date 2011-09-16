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

  #def test_boolean
  #  assert_equal "#t",  @interpreter.run("#t")
  #end

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
    assert_equal "((1) (2 3))", @interpreter.run("(cons '(1) '(2 3))")
  end

  def test_operator_should_also_be_evaluated
    #todo
    #assert_equal "12",  @interpreter.run("((if #f + *) 3 4)") 
  end

  def test_bound_indentifier
    # todo
  end
  
  def test_undefined_identifier
    assert_raise(RuntimeError) { @interpreter.run("non_existant_id") }
  end   

  

  

end
