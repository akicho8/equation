require "equation/version"

require "equation/base"
require "equation/bezier_curve"
require "equation/linear_curve"
require "equation/parabola_curve"

require "active_support/core_ext/string/inflections"

module Equation
  # Equation._create(:type => :linear, :x_range => 1..100, :y_range => 0..10000)
  def self.create(type:, **params)
    "equation/#{type}_curve".classify.constantize.create(params)
  end
end
