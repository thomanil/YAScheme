require 'strscan'

class Lexer

  def tokenize(code)
    if(unbalanced_parens? code) then syntax_error("Unbalanced parens") end
    if(unbalanced_quots? code) then syntax_error("Unmatched quotation marks") end
        
    @scanner = StringScanner.new(code)
    tokens = []
    pos = 0

    while(!finished_tokenizing)
      remaining = code[@scanner.pos, code.length]
      
      if(whitespace = remaining[/\A(\s+)/])
        skip_ahead whitespace.length
      elsif(open_paren = remaining[/\A\(/])
        tokens.push [:open_paren]
        skip_ahead open_paren.length
      elsif(close_paren = remaining[/\A\)/])
        tokens.push [:close_paren]
        skip_ahead close_paren.length
      elsif(quote_tick = remaining[/\A\'/])
        tokens.push([:quote_tick])
        skip_ahead quote_tick.length
      elsif(comment = remaining[/\A(;.*)$/])
        tokens.push([:comment, comment])
        skip_ahead comment.length
      elsif(operator = remaining[/\A([\+\-\/\*])/]) #TMP only, remove later
        tokens.push([:symbol, operator])
        skip_ahead operator.length
      elsif(number = remaining[/\A(\d+)/])
        tokens.push([:number, number])
        skip_ahead number.length
      elsif(symbol = remaining[/\A(\w+\!?\??)/])
        tokens.push([:symbol, symbol])
        skip_ahead symbol.length
      elsif(string = remaining[/\A([\"].*?[\"])/])
        tokens.push([:string, string])
        skip_ahead string.length
      else
        skip_ahead 1
      end
      
    end
    
    return tokens
  end
  
  def skip_ahead(distance)
    @scanner.pos += distance
  end
  
  def finished_tokenizing
    @scanner.eos?
  end
  
  def unbalanced_quots?(code)
    quots = code.scan(/[\"]/)
    return (quots.size > 0 && quots.size.odd?)
  end

  def unbalanced_parens?(code)
    open_parens = code.scan(/\(/)
    close_parens = code.scan(/\)/)
    return (open_parens.size != close_parens.size);
  end

  def syntax_error(msg)
    raise "SYNTAX ERROR: #{msg}"
  end

end
