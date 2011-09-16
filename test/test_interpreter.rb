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

 #def test_eval_boolean
 #  assert_equal "#t",  @interpreter.run("#t")
 #end
 
 def test_eval_undefined_identifier
   assert_raise(RuntimeError) { @interpreter.run("non_existant_id") }
 end   

 def test_eval_quoted_forms
   assert_equal "hello",  @interpreter.run("'hello")
   assert_equal "(1 2)",  @interpreter.run("'(1 2)")
   assert_equal "(identifier 1 \"string\")", @interpreter.run("'(identifier 1 \"string\")")
   assert_equal "(1 (2 3))",  @interpreter.run("'(1 (2 3))")
   assert_equal "(1 two \"three\")",  @interpreter.run("'(1 two \"three\")")
 end

 def test_invalid_quoted_forms
   # todo
 end

 def test_valid_car
   assert_equal "1", @interpreter.run("(car '(1 2 3))")
 end

 def test_invalid_car
   #todo
 end

 def test_valid_cdr
   #assert_equal "(2 3)", @interpreter.run("(cdr '(1 2 3))")
 end

 def test_invalid_cdr
   #todo
 end

 def test_valid_cons
   #assert_equal "1", @interpreter.run("(cons 1 '(2 3))")
 end

 def test_invalid_cons
   #todo
 end



 

end
