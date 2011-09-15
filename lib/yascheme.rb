$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "yascheme/lexer"
require "yascheme/parser"
require "yascheme/interpreter"
require "yascheme/repl"

require "yascheme/ast/ast"
require "yascheme/ast/string"
require "yascheme/ast/number"
require "yascheme/ast/boolean"
require "yascheme/ast/identifier"
require "yascheme/ast/list"
require "yascheme/ast/quote"
require "yascheme/ast/quotetick"


module Yascheme
  VERSION = '0.0.1'


end
