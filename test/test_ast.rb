require File.dirname(__FILE__) + '/test_helper.rb'

class TestAst < Test::Unit::TestCase

  def setup
  end
  
  def test_ast_node
    string_node = AstNode.new 
    string_node.node_type = :string
    string_node.node_value = "test"
  end

  def test_ast_tree
    parent = AstNode.new
    child = AstNode.new
    second_child = AstNode.new

    parent.add child
    parent.add second_child
    
    assert_equal(parent, child.parent)
    assert_equal(parent, second_child.parent)
    
    assert_equal(child, parent[0])
    assert_equal(second_child, parent[1])
  end

end
