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
    child = AstNode.new
    second_child = AstNode.new
    parent.add child
    parent.add second_child
  end
  
  def test_tree_walk
    tree = single_parent_two_children
    node_count = 0
    tree.walk {|node| node_count += 1}
    assert_equal 3, node_count
  end

  def test_enumerable_mixed_in
    tree = single_parent_two_children    
    assert_equal 3, tree.count
    assert_equal 3, (tree.count { |node| node.class == AstNode })
    assert_equal ["AstNode", "AstNode", "AstNode"], tree.map { |node| node.class.to_s }
  end

  def test_tree_tostring
    expected =
<<TREE
AstNode 
  AstNode 
  AstNode 
TREE
    assert_equal expected, single_parent_two_children.internal_structure
  end

  def test_next_sibling
    tree = single_parent_two_children
    child1 = tree[0]
    child2 = tree[1]
    assert_equal child2, child1.next_sibling
  end
  
  def test_remove_child
    tree = single_parent_two_children
    child1 = tree[0]
    child2 = tree[1]
    assert_equal tree[0], child1
    tree.remove_child(child1)
    assert_equal tree[0], child2
    assert_equal 1, tree.children.count
  end
  
end
