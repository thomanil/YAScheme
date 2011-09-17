class Interpreter
  attr_accessor :node_value

  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    @global_env = AstNode.new
    load_libraries
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

  def load_libraries
    filepath = File.dirname(__FILE__) + '/libraries/libraries.scm'
    filebody = IO.read(filepath)
    run(filebody)
  end
end
