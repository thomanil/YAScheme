class Parser

  def ast_tree(tokens)
    tree = into_tree(tokens)
    tree = expand_reader_macros!(tree)
  end

  def into_tree(tokens)
    root = AstNode.new
    current_node = root
    
    tokens.each do |token| 
      type = token[0]
      value = token[1]

      case type
      when :open_paren
        new_list = ListNode.new 
        current_node.add new_list
        current_node = new_list
      when :close_paren
        current_node = current_node.parent
      when :string
        current_node.add StringNode.new(value)
      when :number
        current_node.add NumberNode.new(value)
      when :boolean
        current_node.add BooleanNode.new
      when :identifier
        current_node.add IdentifierNode.new(value)
      when :quote
        current_node.add QuoteNode.new
      else
        current_node.add QuoteTickNode.new
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
    quote_nodes = tree.select { |node| node.class == QuoteTickNode  }
    quote_nodes.each do |tick|
      expanded_node = QuoteNode.new
      expanded_node.add(tick.next_sibling)
      parent = tick.parent
      parent.remove_child(tick.next_sibling)
      parent.remove_child(tick)
      parent.add(expanded_node)
    end
  end

end
