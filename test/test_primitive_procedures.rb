require File.dirname(__FILE__) + '/test_helper.rb'

class TestInterpreter < Test::Unit::TestCase
  include PrimitiveProcedures

  def test_module_include    
    assert self.respond_to? "procedure"
    assert self.respond_to? "call_procedure"
  end

  def test_proc_definition_adds_method_to_self
    orig_method_count = self.public_methods.count
        
    procedure "letrec" do |argument_nodes, scope|
      # procedure body
    end
    
    assert_equal((orig_method_count+1), self.public_methods.count)
  end

  def test_call_proc
    procedure "dummy" do |argument_nodes, scope|
      # procedure body
    end
  end

  def test_call_non_exisiting_proc
    assert_raise(RuntimeError) { self.call_procedure "not_exisiting_proc", nil, nil}
  end

end   
