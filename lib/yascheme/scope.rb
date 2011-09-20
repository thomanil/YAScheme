class Scope

  attr_accessor :symbol_table_stack
  
  def initialize(outer_scope=nil)
    if outer_scope.nil?
      @is_global = true
      @symbol_table_stack = []
      @symbol_table_stack.push({})
    else
      @is_global = false
      @symbol_table_stack = []
      outer_scope.symbol_table_stack.each do |symbol_table_map|
        @symbol_table_stack.push symbol_table_map
      end
      @symbol_table_stack.push({})
    end
  end
  
  def is_global?
    @is_global
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
  
end   
