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
AstNode 
  ListNode 
TREE
    assert_equal expected, ast_node.internal_structure
  end
  
  def test_flat_list
    tokens = [[:open_paren],[:identifier, "one"],[:identifier, "two"],[:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    expected =
<<TREE
AstNode 
  ListNode 
    IdentifierNode one
    IdentifierNode two
TREE
    assert_equal expected, ast_node.internal_structure
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
AstNode 
  ListNode 
    IdentifierNode outer
    IdentifierNode another
    ListNode 
      IdentifierNode "innermost string"
TREE
    assert_equal expected, ast_node.internal_structure
  end

  def test_quote_macro_expansion
    tokens = [[:quote_tick],[:identifier, "one"]]
    ast = @parser.into_tree(tokens) 
    expected =
<<TREE
AstNode 
  QuoteTickNode 
  IdentifierNode one
TREE
    assert_equal expected, ast.internal_structure

    expanded_ast = @parser.expand_reader_macros!(ast)
    expected_expanded =
<<TREE
AstNode 
  QuoteNode 
    IdentifierNode one
TREE

    assert_equal expected_expanded, expanded_ast.internal_structure
  end


end
