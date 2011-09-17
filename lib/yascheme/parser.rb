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
        current_node.add BooleanNode.new(value)
      when :symbol
        current_node.add SymbolNode.new(value)
      when :quote
        current_node.add QuoteNode.new
      when :comment
         # Filtering out comments
      when :quote_tick
        current_node.add AstNode.new("'")
      else
        raise "Unknown token '#{type}', aborting parsing."
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
    tick_nodes = tree.select { |node| node.node_value == "'"  }
    tick_nodes.each do |tick|
      parent = tick.parent 
      expanded_node = QuoteNode.new
      quoted_element = tick.next_sibling
      expanded_node.add quoted_element
      parent.remove_child quoted_element
      parent.replace_child tick, expanded_node
    end
  end

end
