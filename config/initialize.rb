require 'pastel'
require 'pry'
require 'pry-nav'

Dir['lib/**/*.rb'].sort.reverse.each { |path| require File.expand_path("../#{path}", __dir__) }
