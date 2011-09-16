class ListNode < AstNode

  # List eval = "run this list as a function"
  def eval(context={})
    procedure_name = children[0].node_value
    arguments =  children[1..children.length]

    # TODO Move these into separate module for core procedures
    # TODO Use respond_to? and send() to dispatch to module
    
    case procedure_name
    when "car"
      return arguments[0].eval.children.first
    when "cdr"
      rest = arguments[0].eval.children[1..children.length]
      new_list = ListNode.new
      rest.each { |item|  new_list.add item }
      return new_list
    when "cons"
      arg1 = arguments[0].eval
      arg2 = arguments[1].eval
      if arg2.class == ListNode
        consed_list = arg2
        arg2.children.insert(0, arg1)
        return consed_list
      else
        consed_list = ListNode.new
        consed_list.add arg1
        consed_list.add arg2
        return consed_list
      end
    when "set!"
      variable_name = arguments[0].to_s
      value = arguments[1].eval
      define_global variable_name, value
    when "lambda"
      # (lambda (formal params)(body))
      raise "not impl yet"
    when "if"
      test_result = arguments[0].eval
      if test_result.true?
        return arguments[1].eval
      else
        return arguments[2].eval
      end
    else
      # TODO call actual function definiton in scope
      raise "Function '#{procedure_name}' undefined"
    end
  end

  def to_s
    child_strings = children.map { |child| child.to_s}.join " "
    "(#{child_strings})" 
  end
    
end
