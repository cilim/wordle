require 'pastel'
require 'pry'

Dir['lib/**/*.rb'].sort.each { |path| require File.expand_path("../#{path}", __dir__) }
