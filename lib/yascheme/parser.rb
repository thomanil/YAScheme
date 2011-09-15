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
        new_list = ListNode.new
        new_list.node_type = :list
        current_node.add new_list
        current_node = new_list
      when :close_paren
        current_node = current_node.parent
      when :string
        new_node = StringNode.new
        new_node.node_type = type
        new_node.node_value = value
        current_node.add new_node
      when :number
        new_node = NumberNode.new
        new_node.node_type = type
        new_node.node_value = value
        current_node.add new_node
      when :boolean
        new_node = BooleanNode.new
        new_node.node_type = type
        new_node.node_value = value
        current_node.add new_node
      when :identifier
        new_node = IdentifierNode.new
        new_node.node_type = type
        new_node.node_value = value
        current_node.add new_node
      when :quote
        new_node = QuoteNode.new
        new_node.node_type = type
        new_node.node_value = value
        current_node.add new_node
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
    quote_nodes = tree.select { |node| node.node_type.eql?(:quote_tick) }
    quote_nodes.each do |node| 
      node.node_type = :quote      
      child = node.next_sibling
      child.parent.remove_child(child)
      node.add child
    end
  end

end
