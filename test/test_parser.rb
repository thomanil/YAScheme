require File.dirname(__FILE__) + '/test_helper.rb'

class TestParser < Test::Unit::TestCase

  def setup
    @parser = Parser.new
  end
  
  def test_empty_list
    tokens = [[:open_paren],[:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    assert_equal(:root, ast_node.node_type)
    list = ast_node[0]
    assert_equal(:list, list.node_type)
  end
  
  def test_flat_list
    tokens = [[:open_paren],[:atom, "one"],[:atom, "two"],[:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    
    assert_equal(:root, ast_node.node_type)
    list = ast_node[0]
    assert_equal(:list, list.node_type)
    assert_equal(2, list.children.size)
  end

  def test_nested_list
    tokens = [[:open_paren],
              [:atom, "outer atom"],[:atom, "another atom"],
              [:open_paren],
              [:atom, "\"innermost string\""],
              [:close_paren],
              [:close_paren]]

    ast_node = @parser.ast_tree(tokens)
    assert_equal(:root, ast_node.node_type)
    outer_list = ast_node[0]
    assert_equal(:list, outer_list.node_type)
    assert_equal(3, outer_list.children.size)
    inner_list = outer_list[2]
    assert_equal(:list, inner_list.node_type)
    assert_equal(1, inner_list.children.size)
  end


end
