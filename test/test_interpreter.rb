require File.dirname(__FILE__) + '/test_helper.rb'

class TestInterpreter < Test::Unit::TestCase

  def setup
    @interpreter = Interpreter.new
  end


 def test_eval_boolean

 end

 def test_eval_symbol
    assert_equal :symbol,  @interpreter.evaluate("symbol")
 end   

 def test_eval_number
    assert_equal 42,  @interpreter.evaluate("42")
 end  

 def test_eval_string
  assert_equal "this is a string",  @interpreter.evaluate("\"this is a string\"")
 end  

 def test_eval_list
   assert_equal [1, 2],  @interpreter.evaluate("(1 2)")
   assert_equal [1, :two, "three"],  @interpreter.evaluate("(1 two \"three\")")
 end  

 def test_eval_nested_list
   assert_equal [1, [2, 3]],  @interpreter.evaluate("(1 (2 3))")
 end

 def test_eval_arithmetic_functions
   assert_equal 2,  @interpreter.evaluate("(+ 1 1)")
   assert_equal 3,  @interpreter.evaluate("(+ 1 1 1)")
   assert_equal 4,  @interpreter.evaluate("(+ (+ 1 1) (+ 1 1))")

   assert_equal 1,  @interpreter.evaluate("(- 4 3)")
   assert_equal 6,  @interpreter.evaluate("(* 2 3)")
   assert_equal 5,  @interpreter.evaluate("(/ 15 3)")
 end




end
