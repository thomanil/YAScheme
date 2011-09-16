class Interpreter
  attr_accessor :node_value

  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    @current_ast = nil
    # TODO load and eval "optional, library, extensions" scheme code from here
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    @current_ast  = @parser.ast_tree(tokens)
    #dump_state tokens, ast_tree
    last_value = @current_ast.eval
    last_value.to_s
  end

  def dump_state
    puts "----------------------"
    puts "PROGRAM DUMP START"
    puts "----------------------"
    puts "Abstract Syntax Tree:"
    puts "----------------------"
    puts @current_ast.internal_structure
    puts "----------------------"
    puts "PROGRAM DUMP END"
    puts "----------------------"
  end
end
