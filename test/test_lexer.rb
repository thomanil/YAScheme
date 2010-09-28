require File.dirname(__FILE__) + '/test_helper.rb'

class TestLexer < Test::Unit::TestCase
  
  def setup
    @lexer = Lexer.new
  end
  
  def test_syntax_error
    assert_raise(RuntimeError) { @lexer.syntax_error("Some error") }
  end
  
  def test_unbalanced_parens
    assert !@lexer.unbalanced_quots?(" \"  \" ")
    assert @lexer.unbalanced_quots?(" \" ")
    assert @lexer.unbalanced_quots?(" \"  \"  \" ") 
    assert_raise(RuntimeError) { @lexer.tokenize(" \" ") }
  end
  
  def test_unbalanced_quotations
    assert !@lexer.unbalanced_parens?(" (  ) ")
    assert @lexer.unbalanced_parens?(" ( ")
    assert @lexer.unbalanced_parens?(" ) ")
    assert @lexer.unbalanced_parens?(" ( (")
    assert @lexer.unbalanced_parens?(" ( ) ) ")
    assert_raise(RuntimeError) { @lexer.tokenize(" ( ") }
  end
  
  def test_empty
    assert_equal [], @lexer.tokenize("")
    assert_equal [], @lexer.tokenize("  ")
  end
  
  def test_empty_list
    assert_equal [[:open_paren],[:close_paren]], 
                 @lexer.tokenize("()")
    assert_equal [[:open_paren],[:close_paren]], 
                 @lexer.tokenize("( )")
    assert_equal [[:open_paren],[:close_paren]], 
                 @lexer.tokenize(" (   ) ")
  end

  def test_multiline_list
      assert_equal [[:open_paren],[:close_paren]], 
                 @lexer.tokenize(" ( \n  \n  ) ")
  end
  
  def test_atoms
    assert_equal [[:symbol, ":symbol"]], @lexer.tokenize("symbol")
    assert_equal [[:string, "\"string\""]], @lexer.tokenize("\"string\"")
    assert_equal [[:number, "123"]], @lexer.tokenize("123")
    assert_equal [[:symbol, ":two"],[:symbol, ":symbols"]], @lexer.tokenize("two symbols")
    assert_equal [[:operator, "+"]], @lexer.tokenize("+")
    assert_equal [[:operator, "-"]], @lexer.tokenize("-")
    assert_equal [[:operator, "/"]], @lexer.tokenize("/")
    assert_equal [[:operator, "*"]], @lexer.tokenize("*")
  end
  
  def test_list
    assert_equal [[:open_paren], 
                  [:symbol, ":one"],
                  [:symbol, ":two"],
                  [:string, "\"three\""],
                  [:number, "42"],
                  [:close_paren]], 
    @lexer.tokenize("(one two \"three\" 42)")
  end
  
  def test_string
    assert_equal [[:string, "\"one\""]], @lexer.tokenize("\"one\"")
    assert_equal [[:string, "\"one two quot\""]], @lexer.tokenize("\"one two quot\"")
  end
 
  #TODO quot ticks
  #TODO error handling report back line and pos
  #TODO escape characters within strings
 
end
