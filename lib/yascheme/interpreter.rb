class Interpreter
  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    # TODO load and eval "optional, library, extensions" scheme code from here
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    ast_tree = @parser.ast_tree(tokens)
    dump_state tokens, ast_tree    
    last_value = ast_tree.eval
    last_value.to_s
  end

  def dump_state(tokens, tree)
    puts "----------------------"
    puts "PROGRAM DUMP START"
    puts "----------------------"
    puts "Lexed tokens:"
    puts "-------------"
    puts tokens.join(", ")
    puts "-------------"
    puts "Abstract Syntax Tree:"
    puts "----------------------"
    puts tree.internal_structure
    puts "----------------------"
    puts "PROGRAM DUMP END"
    puts "----------------------"
  end
  
  
end
