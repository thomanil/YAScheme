require File.dirname(__FILE__) + '/test_helper.rb'

class TestInterpreter < Test::Unit::TestCase

  def setup
    @interpreter = Interpreter.new
  end

 def test_eval_number
    assert_equal "42",  @interpreter.run("42")
 end  

 def test_eval_string
  assert_equal "\"this is a string\"",  @interpreter.run("\"this is a string\"")
 end  

 def test_eval_undefined_identifier
   assert_raise(RuntimeError) { @interpreter.run("non_existant_id") }
 end   

 def test_eval_boolean
   
 end

 def test_eval_quoted_list
#   assert_equal "(1 2)",  @interpreter.run("'(1 2)")
#   assert_equal "(1 two \"three\")",  @interpreter.run("'(1 two \"three\")")
 end  

 def test_eval_quoted_identifier
 #  assert_equal "hello",  @interpreter.run("'hello")
 end  
 
 def test_eval_quoted_nested_list
   #assert_equal [1, [2, 3]],  @interpreter.run("'(1 (2 3))")
 end

 def test_eval_arithmetic_functions
   assert_equal 2,  @interpreter.run("(+ 1 1)")
   assert_equal 3,  @interpreter.run("(+ 1 1 1)")
   assert_equal 4,  @interpreter.run("(+ (+ 1 1) (+ 1 1))")
   assert_equal 1,  @interpreter.run("(- 4 3)")
   assert_equal 6,  @interpreter.run("(* 2 3)")
   assert_equal 5,  @interpreter.run("(/ 15 3)")
 end




end
