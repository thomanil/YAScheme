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
  
  def test_traverse_down
    tree = single_parent_two_children
    node_count = 0
    tree.traverse_down {|node| node_count += 1}
    assert_equal 3, node_count
  end

  def test_enumerable_mixed_in
    tree = single_parent_two_children    
    assert_equal 3, tree.count
    assert_equal 3, (tree.count { |node| node.class == AstNode })
    assert_equal ["AstNode", "AstNode", "AstNode"], tree.map { |node| node.class.to_s }
  end

  def test_tostring
    expected =
<<TREE
Ast
  Ast
  Ast
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

  def test_replace_child
    tree = single_parent_two_children
    unwanted = tree[0]
    replacement = AstNode.new
    tree.replace_child unwanted, replacement
    assert_equal tree[0], replacement
  end
  
  def test_only_ast_nodes_allowed_as_values
    tree = single_parent_two_children
    assert_raise(RuntimeError) { tree.define_local "bad-var", "not an ast node"  }
  end
  
  def test_define_local_variable
    tree = single_parent_two_children
    string_node = StringNode.new("42")
    tree.define_local "foo", string_node 
    assert_equal string_node, tree.symbol_table["foo"]
  end

  def test_define_global_variable
    tree = single_parent_two_children
    child = tree[0]
    string_node = StringNode.new("42")
    child.define_global "foo", string_node
    assert_equal nil, child.symbol_table["foo"]
    assert_equal string_node, tree.symbol_table["foo"]
  end
  
  def test_local_lookup
    tree = single_parent_two_children
    child = tree[0]
    string_node = StringNode.new("42")
    child.symbol_table["foo"] = string_node
    assert_equal nil, tree.lookup("foo")
    assert_equal string_node, child.lookup("foo")
  end

  def test_global_lookup
    tree = single_parent_two_children
    child = tree[0]
    string_node = StringNode.new("42")
    tree.symbol_table["foo"] = string_node
    assert_equal string_node, tree.lookup("foo")
    assert_equal string_node, child.lookup("foo")
  end

  def test_boolean_ast_truthiness
    assert_equal true, BooleanNode.new("#t").true?
    assert_equal false, BooleanNode.new("#f").true?
    assert_raise(RuntimeError) { BooleanNode.new("invalid").true? }              
  end  
  
end
