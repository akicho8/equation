# 範囲の端の値は自明
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'

params = {x_range: 1..100, y_range: 2000..6000,  type: :bezier, pull:  0.40005 }
Equation.create(params).y_by_x(1)     # => 2000.0
Equation.create(params).y_by_x(100)   # => 6000.0
Equation.create(params).x_by_y(2000)  # => 1.0
Equation.create(params).x_by_y(6000)  # => 100.0
