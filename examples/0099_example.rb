$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'gnuplot'

x_range = 0..100
y_range = 0..10000

list = []
list << {:name => "直線(liner)",      :records => x_range.collect { |x| {:x => x, :y => Equation::LinearCurve._create(x_range, y_range).y_by_x(x)}}}
list << {:name => "放物線(parabola)", :records => x_range.collect { |x| {:x => x, :y => Equation::ParabolaCurve._create(x_range, y_range).y_by_x(x)}}}
list << {:name => "ベジェ(bezier) -0.5", :records => x_range.collect { |x| {:x => x, :y => Equation::BezierCurve._create(x_range, y_range, :pull => -0.5).y_by_x(x)}}}
list << {:name => "ベジェ(bezier) +0.5", :records => x_range.collect { |x| {:x => x, :y => Equation::BezierCurve._create(x_range, y_range, :pull => +0.5).y_by_x(x)}}}
Equation::Base.file_output(list, :title => "3種類の特徴", :filename => "all_curve.png")

# list = patterns.collect {|e| {:records => x_range.collect{|x| {:x => x, :y => Equation::LinearCurve._create(x_range, e[:y_range], e).y_by_x(x)} }}}
# Equation::Base.file_output(list, :title => "linear", :filename => "linear_curve.png")
# 
# list = patterns.collect {|e| {:records => x_range.collect{|x| {:x => x, :y => Equation::ParabolaCurve._create(x_range, e[:y_range], e).y_by_x(x)} }}}
# Equation::Base.file_output(list, :title => "parabola", :filename => "parabola_curve.png")
# 
# list = patterns.collect{|e|{:name => e[:pull], :records => x_range.collect{|x| {:x => x, :y => Equation::BezierCurve._create(x_range, e[:y_range], e).y_by_x(x)} }}}
# Equation::Base.file_output(list, :title => "bezier", :filename => "bezier_curve.png")
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "linear_curve.png"
# >> set title "Equation::LinearCurve"
# >> set xlabel ""
# >> set ylabel ""
# >> set key right bottom
# >> 
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "parabola_curve.png"
# >> set title "Equation::ParabolaCurve"
# >> set xlabel ""
# >> set ylabel ""
# >> set key right bottom
# >> 
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "bezier_curve.png"
# >> set title "Equation::BezierCurve"
# >> set xlabel ""
# >> set ylabel ""
# >> set key right bottom
# >> 
