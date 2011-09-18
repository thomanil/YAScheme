class Interpreter
  attr_accessor :node_value

  def initialize  
    @lexer = Lexer.new
    @parser = Parser.new
    @environment = Scope.new
  end

  def run(code)
    tokens = @lexer.tokenize(code)
    @new_ast_branch  = @parser.ast_tree(tokens) 
    last_value = @new_ast_branch.eval @environment
    last_value.to_s
  end

  def dump_state
    puts "----------------------"
    puts "PROGRAM DUMP START"
    puts "----------------------"
    puts "Environment:"
    puts "----------------------"
    puts @environment
    puts "----------------------"
    puts "PROGRAM DUMP END"
    puts "----------------------"
  end

  def load_libraries
    filepath = File.dirname(__FILE__) + '/scheme_code/library_procedures.scm'
    filebody = IO.read(filepath)
    run(filebody)
  end
end
