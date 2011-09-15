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
    assert_equal [[:identifier, "symbol"]], @lexer.tokenize("symbol")
    assert_equal [[:string, "\"string\""]], @lexer.tokenize("\"string\"")
    assert_equal [[:number, "123"]], @lexer.tokenize("123")
    assert_equal [[:identifier, "two"],[:identifier, "symbols"]], @lexer.tokenize("two symbols")
    assert_equal [[:identifier, "+"]], @lexer.tokenize("+")
    assert_equal [[:identifier, "-"]], @lexer.tokenize("-")
    assert_equal [[:identifier, "/"]], @lexer.tokenize("/")
    assert_equal [[:identifier, "*"]], @lexer.tokenize("*")
  end
  
  def test_list
    assert_equal [[:open_paren], 
                  [:identifier, "one"],
                  [:identifier, "two"],
                  [:string, "\"three\""],
                  [:number, "42"],
                  [:close_paren]], @lexer.tokenize("(one two \"three\" 42)")
  end
  
  def test_string
    assert_equal [[:string, "\"one\""]], @lexer.tokenize("\"one\"")
    assert_equal [[:string, "\"one two quot\""]], @lexer.tokenize("\"one two quot\"")
  end

  def test_quote_tick
    assert_equal [[:quote_tick]], @lexer.tokenize("'")
    assert_equal [[:quote_tick],
                  [:open_paren],
                  [:identifier, "quoted"],
                  [:close_paren]], @lexer.tokenize("'(quoted)")
  end

  def test_quoted_regular
    assert_equal [[:quote_tick]], @lexer.tokenize("'")
    assert_equal [[:open_paren],
                  [:identifier, "quote"],
                  [:open_paren],
                  [:identifier, "quoted"],
                  [:close_paren],
                  [:close_paren]],  @lexer.tokenize("(quote(quoted))")
  end

  def test_comment
    assert_equal [[:comment, ";comment"]], @lexer.tokenize(";comment")
    assert_equal [[:identifier, "before"],
                  [:comment, ";comment after"]], @lexer.tokenize("before;comment after")
    assert_equal [[:identifier, "before"],
                  [:comment, ";comment"],
                  [:identifier, "nextline"]], @lexer.tokenize("before;comment\n nextline")
  end
 
  #TODO error handling report back line and pos
  #TODO string escape characters
 
end
