require File.dirname(__FILE__) + '/test_helper.rb'

class TestScope < Test::Unit::TestCase
  
  def setup
    @scope = Scope.new
  end

  def test_define_local_variable
    value = StringNode.new "1"
    @scope.define_local "foo", value 
    assert_equal value, @scope.local_symbol_table["foo"]
  end

  def test_define_global_variable
    value = StringNode.new "2"
    @scope.define_global "foo", value 
    assert_equal value, @scope.global_symbol_table["foo"]
  end
  
  def test_local_lookup
    assert_equal nil, @scope.lookup("foo")
    value = StringNode.new "3" 
    @scope.local_symbol_table["foo"] = value
    assert_equal value, @scope.lookup("foo")
  end

  def test_global_lookup
    assert_equal nil, @scope.lookup("foo")
    value = StringNode.new "4" 
    @scope.global_symbol_table["foo"] = value
    assert_equal value, @scope.lookup("foo")
  end
  
  def test_local_value_clobbers_global_value
    global = StringNode.new "100"
    local = StringNode.new "10"
    @scope.define_local "foo", local
    @scope.define_global "foo", global
    assert_equal local, @scope.lookup("foo")
  end

  def test_local_variable_only_visible_in_and_below_node_that_defined_them
    
  end

  def test_local_variable_disappear_after_defining_node_has_finished_executing

  end
 
  def test_lexical_scope_variable_are_visible_to_procedures_defined_in_same_block


  end
  
  
end
