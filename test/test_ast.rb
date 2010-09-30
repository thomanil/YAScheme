require File.dirname(__FILE__) + '/test_helper.rb'

class TestAst < Test::Unit::TestCase

  def setup
  end
  
  def test_tree_structure
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

  def single_parent_two_children
    parent = AstNode.new
    parent.node_type = :parent
    child = AstNode.new
    child.node_type = :child1
    second_child = AstNode.new
    second_child.node_type = :child2
    parent.add child
    parent.add second_child
  end
  
  def test_tree_walk
    tree = single_parent_two_children
    node_count = 0
    tree.walk {|node| node_count += 1}
    assert_equal 3, node_count
  end

  def test_enumerable_mixin
    tree = single_parent_two_children
    assert_equal 3, tree.count
    assert tree.detect { |node| node.node_type.eql?(:parent) }
    assert_equal [:parent, :child1, :child2], tree.map { |node| node.node_type }
  end
  
  

  
end
