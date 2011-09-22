require File.dirname(__FILE__) + '/test_helper.rb'

class TestPrimitiveProcedures < Test::Unit::TestCase

  def setup
    @procedures = PrimitiveProcedures.new
  end

  def test_module_include
    assert @procedures.respond_to? "procedure"
    assert @procedures.respond_to? "call_procedure"
  end

  def test_call_non_exisiting_proc
    assert_raise(RuntimeError) { @procedures.call_procedure "not_exisiting_proc", nil, nil}
  end
  
  def test_proc_definition_adds_method_to_procedures
    orig_method_count = @procedures.public_methods.count
    def @procedures.add_procedure
      procedure "new-procedure" do |argument_list, scope|
        # ... 
      end
    end
    @procedures.add_procedure
    assert_equal((orig_method_count+2), @procedures.public_methods.count)
  end

  def test_define_and_call_proc
     def @procedures.add_procedure
       procedure "returns-ten" do |argument_list, scope|
         return 10
       end
     end;
     @procedures.add_procedure
     assert_equal 10, @procedures.call_procedure("returns-ten", nil, Scope.new)
   end

   def test_proc_must_be_called_with_scope
     def @procedures.add_procedure
       procedure "expects-scope" do |argument_list, scope|
         # ...
       end
     end
     @procedures.add_procedure

     assert_raise(RuntimeError) { @procedures.call_procedure "expects-scope", nil, nil}
   end
   
   def test_proc_argument_type_checks
     def @procedures.add_procedure
       procedure "expects-two-numbers" do |argument_list, scope|
         expects argument_list, [NumberNode, NumberNode]
         99
       end
     end
     @procedures.add_procedure

     arguments = ListNode.new
     assert_raise(RuntimeError) { @procedures.call_procedure "expects-two-numbers", arguments, Scope.new}

     arguments.add(NumberNode.new)
     assert_raise(RuntimeError) { @procedures.call_procedure "expects-two-numbers", arguments, Scope.new}

     arguments.add(NumberNode.new)
     assert_equal 99, @procedures.call_procedure("expects-two-numbers", arguments, Scope.new)

     arguments.add(NumberNode.new)
     assert_raise(RuntimeError) { @procedures.call_procedure "expects-two-numbers", arguments, Scope.new}
   end

   def test_argument_type_check
     numberArgument = ListNode.new
     numberArgument.add(NumberNode.new)
     stringArgument = ListNode.new
     stringArgument.add(StringNode.new)
     
     assert_raise(RuntimeError) { @procedures.expects numberArgument, [StringNode]}
     assert @procedures.expects stringArgument, [StringNode]
   end

end   
