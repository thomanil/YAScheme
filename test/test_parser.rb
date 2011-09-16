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
    tokens = [[:open_paren],[:symbol, "one"],[:symbol, "two"],[:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    expected =
<<TREE
AstNode
  ListNode
    SymbolNode one
    SymbolNode two
TREE
    assert_equal expected, ast_node.internal_structure
  end

  def test_nested_list
    tokens = [[:open_paren],
              [:symbol, "outer"],[:symbol, "another"],
              [:open_paren],
              [:symbol, "\"innermost string\""],
              [:close_paren],
              [:close_paren]]
    ast_node = @parser.ast_tree(tokens)
    expected =
<<TREE
AstNode
  ListNode
    SymbolNode outer
    SymbolNode another
    ListNode
      SymbolNode "innermost string"
TREE
    assert_equal expected, ast_node.internal_structure
  end

  def test_quote_macro_expansion
    tokens = [[:quote_tick],[:symbol, "one"]]
    ast = @parser.into_tree(tokens) 
    expected =
<<TREE
AstNode
  AstNode '
  SymbolNode one
TREE
    assert_equal expected, ast.internal_structure

    expanded_ast = @parser.expand_reader_macros!(ast)
    expected_expanded =
<<TREE
AstNode
  QuoteNode
    SymbolNode one
TREE

    assert_equal expected_expanded, expanded_ast.internal_structure
  end


end
