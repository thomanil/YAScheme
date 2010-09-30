class Parser

  def ast_tree(tokens)
    tree = into_tree(tokens)
    tree = expand_reader_macros!(tree)
  end

  def into_tree(tokens)
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

    end

    return root
  end

  def expand_reader_macros!(tree)
    expand_quotes(tree)
    # TODO others?  ( ) [ ] { } " , ' ` ; # | \
    return tree
  end

  def expand_quotes(tree)
     while(quote_node = find_unexpanded_quote_macro(tree))       
       quote_node.node_type = :quote      
       quote_child = quote_node.next_sibling
       quote_child.parent.remove_child(quote_child)
       quote_node.add quote_child
    end
  end

  def find_unexpanded_quote_macro(tree) 
    tree.find { |node| node.node_type.eql?(:quote_tick) }
  end

  


end
