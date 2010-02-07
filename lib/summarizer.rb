$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

module Summarizer
  VERSION = '0.1.2'
end

require 'summarizer/base'
require 'summarizer/add_it_up'
require 'summarizer/static'
