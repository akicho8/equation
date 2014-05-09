# -*- coding: utf-8 -*-
# ベジェの場合のみ交点が見つからない事故がある
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'

params = {:x_range => 0..1, :y_range => 0..10}
Equation.create(params.merge(:type => :linear)).y_by_x(2)                         # => 20.0
Equation.create(params.merge(:type => :parabola)).y_by_x(2)                       # => 40.0
Equation.create(params.merge(:type => :bezier, :pull => 0.1)).y_by_x(2) rescue $! # => #<ArgumentError: 直線と曲線の交点が見つかりません。pull が 3.0 か、指定した x y がそれぞれ x_range y_range の範囲に含まれていません>
