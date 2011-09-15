require File.dirname(__FILE__) + '/test_helper.rb'

class TestParser < Test::Unit::TestCase

  def setup
    @parser = Parser.new
  end
  
  def test_empty_list
    tokens = [[:open_paren],[:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    expected =
<<TREE
root 
  list 
TREE
    assert_equal expected, ast_node.tree_structure_to_s
  end
  
  def test_flat_list
    tokens = [[:open_paren],[:identifier, "one"],[:identifier, "two"],[:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    expected =
<<TREE
root 
  list 
    identifier one
    identifier two
TREE
    assert_equal expected, ast_node.tree_structure_to_s
  end

  def test_nested_list
    tokens = [[:open_paren],
              [:identifier, "outer"],[:identifier, "another"],
              [:open_paren],
              [:identifier, "\"innermost string\""],
              [:close_paren],
              [:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    expected =
<<TREE
root 
  list 
    identifier outer
    identifier another
    list 
      identifier "innermost string"
TREE
    assert_equal expected, ast_node.tree_structure_to_s
  end

  def test_quote_macro_expansion
    tokens = [[:quote_tick],[:identifier, "one"]]
    ast = @parser.into_tree(tokens) 
    expected =
<<TREE
root 
  quote_tick 
  identifier one
TREE
    assert_equal expected, ast.tree_structure_to_s

    expanded_ast = @parser.expand_reader_macros!(ast)
    expected_expanded =
<<TREE
root 
  quote 
    identifier one
TREE

    assert_equal expected_expanded, expanded_ast.tree_structure_to_s
  end


end
