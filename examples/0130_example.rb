# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'

@curve = Equation::ParabolaCurve.create(1..99, 0..9999, :cast_method => :to_f)
def exp(lv); @curve.y_by_x(lv).ceil; end
def lv(exp); @curve.x_by_y(exp).floor; end

a = exp(2)                      # => 2
b = exp(3)                      # => 5

diff = b - a                    # => 3
(exp(2) + diff)                 # => 5

v = lv(1000)                    # => 31
v = exp(v)                      # => 938
v < 1000                        # => true

v = exp(30)                     # => 876
lv(v)                           # => 30
