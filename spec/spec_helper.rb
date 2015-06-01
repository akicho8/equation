$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'equation/level_support'

require "rain_table"
require "gnuplot"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
