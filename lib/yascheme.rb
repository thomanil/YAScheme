$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require "yascheme/lexer"
require "yascheme/ast"
require "yascheme/parser"
require "yascheme/interpreter"
require "yascheme/repl"


module Yascheme
  VERSION = '0.0.1'


end
