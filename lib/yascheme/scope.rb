class Scope

  attr_accessor :symbol_table_stack
  
  def initialize(outer_scope=nil)
    @symbol_table_stack = []
    if !outer_scope.nil?
      outer_scope.symbol_table_stack.each do |outer_symbol_table|
        @symbol_table_stack.push outer_symbol_table
      end
    end
    @symbol_table_stack.push({})
  end
  
  def define(variable_name, node)
    ensure_only_ast_nodes_are_bound node
    @symbol_table_stack.last[variable_name] = node
  end
  
  def lookup(name)
    looked_up = nil
    @symbol_table_stack.each do |symbol_table|
      current_scope_lookup = symbol_table[name]
      if !current_scope_lookup.nil?
        looked_up = current_scope_lookup
      end
    end
    return looked_up
  end
  
  def ensure_only_ast_nodes_are_bound node
    if !node.is_a? AstNode
      raise "Variable value not an AST node! #{variable_name} is a #{node.class}"
    end
  end

  def innermost_scoped_symbol_table
    @symbol_table_stack.last
  end
  
end   
