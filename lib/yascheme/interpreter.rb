class Interpreter
  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    # TODO load and eval "optional, library, extensions" scheme code from here
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    ast_tree = @parser.ast_tree(tokens)
    ast_tree.eval
  end
  
end
