$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "yascheme/primitive_procedures"
require "yascheme/lexer"
require "yascheme/parser"
require "yascheme/interpreter"

require "yascheme/ast/ast_node"
require "yascheme/ast/list_node"
require "yascheme/ast/quote_node"
require "yascheme/ast/string_node"
require "yascheme/ast/number_node"
require "yascheme/ast/boolean_node"
require "yascheme/ast/symbol_node"

module Yascheme
  VERSION = '0.0.1'
  
  

end
