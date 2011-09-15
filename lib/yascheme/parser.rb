class Parser

  def ast_tree(tokens)
    tree = into_tree(tokens)
    tree = expand_reader_macros!(tree)
  end

  def into_tree(tokens)
    root = AstNode.new(nil, :root)
    current_node = root
    
    tokens.each do |token| 
      type = token[0]
      value = token[1]

      case type
      when :open_paren
        new_list = ListNode.new(value, :list)
        current_node.add new_list
        current_node = new_list
      when :close_paren
        current_node = current_node.parent
      when :string
        current_node.add(StringNode.new(value, type))
      when :number
        current_node.add(NumberNode.new(value, type))
      when :boolean
        current_node.add(BooleanNode.new(value, type))
      when :identifier
        current_node.add(IdentifierNode.new(value, type))
      when :quote
        current_node.add(QuoteNode.new(value, type))
      else
        current_node.add(AstNode.new(value, type))
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
    quote_nodes.each do |tick|
      expanded_node = QuoteNode.new(nil, :quote)
      expanded_node.add(tick.next_sibling)
      parent = tick.parent
      parent.remove_child(tick.next_sibling)
      parent.remove_child(tick)
      parent.add(expanded_node)
    end
  end

end
