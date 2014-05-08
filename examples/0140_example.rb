# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'gnuplot'

x_range = 20..100
attack_base = 2000

patterns = []
patterns << {:pull => [-0.5,  -0.0], :y_range => (attack_base..10000 - 1000 * 0)}
patterns << {:pull => [+0.5,   0.0], :y_range => (attack_base..10000 - 1000 * 0)}
patterns << {:pull => [0.001, -0.5], :y_range => (attack_base..10000 - 1000 * 0)}
patterns << {:pull => [0.001,  0.5], :y_range => (attack_base..10000 - 1000 * 0)}
patterns << {:pull => [-0.25, -0.5], :y_range => (attack_base..10000 - 1000 * 0)}
patterns << {:pull => [ 0.25,  0.5], :y_range => (attack_base..10000 - 1000 * 0)}

list = patterns.collect{|e|{:name => e[:pull], :records => x_range.collect{|x| {:x => x, :y => Equation::BezierCurve.create(x_range, e[:y_range], e).y_by_x(x)} }}}
Equation::Base.output_file(list, :title => "Equation::BezierCurve", :filename => "bezier_curve_pull2.png")
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "bezier_curve2.png"
# >> set title "Equation::BezierCurve"
# >> set xlabel ""
# >> set ylabel ""
# >> set key right bottom
# >> 
