class Parser

  def ast_tree(tokens)
    root = AstNode.new
    root.node_type = :root
    current_node = root
  
    tokens.each do |token| 
      type = token[0]
      value = token[1]
      
      case type
      when :open_paren
        new_list = AstNode.new
        new_list.node_type = :list
        current_node.add new_list
        current_node = new_list
      when :close_paren
        current_node = current_node.parent
      else
        new_atom = AstNode.new
        new_atom.node_type = type
        new_atom.node_value = value
        current_node.add new_atom
      end

      # TODO implement reader-macros and other special characters:
      # whitespace ( ) [ ] { } " , ' ` ; # | \
      # quoted forms, and comments. other? (lists, strings..)

    end
    
    return root
  end

end
