class Scope
   
  def initialize
    @@global_symbol_table = {}
    @local_symbol_table = {}      
  end

  def global_symbol_table
    @@global_symbol_table
  end

  def local_symbol_table
    @local_symbol_table
  end
  
  def define_local(variable_name, node)
    ensure_only_ast_nodes_are_bound node
    @local_symbol_table[variable_name] = node
  end
  
  def define_global(variable_name, node)
    ensure_only_ast_nodes_are_bound node
    @@global_symbol_table[variable_name] = node
  end

  def ensure_only_ast_nodes_are_bound node
    if !node.is_a? AstNode
      raise "Only Ast nodes can be bound as values! #{variable_name} is a #{node.class}"
    end
  end
    
  def lookup(name)
    global = @@global_symbol_table[name]
    local = @local_symbol_table[name]
    lookedup = global
    if !local.nil?
      lookedup = local
    end
    return lookedup
  end

end   
