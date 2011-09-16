class Interpreter
  attr_accessor :node_value

  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    @global_env = AstNode.new
    # TODO load and eval "library, optional" bits of scheme code from here
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    @new_ast_branch  = @parser.ast_tree(tokens)
    @global_env.add @new_ast_branch
    last_value = @new_ast_branch.eval
    last_value.to_s
  end

  def dump_state
    puts "----------------------"
    puts "PROGRAM DUMP START"
    puts "----------------------"
    puts "Abstract Syntax Tree:"
    puts "----------------------"
    puts @global_env.internal_structure
    puts "----------------------"
    puts "PROGRAM DUMP END"
    puts "----------------------"
  end
end
