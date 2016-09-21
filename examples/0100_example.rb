$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'gnuplot'

level = 20..100
attack_base = 2000

patterns = []
patterns << {:pull =>  0.4, :attack => (attack_base..10000 - 1000 * 4)}
patterns << {:pull =>  0.2, :attack => (attack_base..10000 - 1000 * 3)}
patterns << {:pull =>  0.0, :attack => (attack_base..10000 - 1000 * 2)}
patterns << {:pull => -0.2, :attack => (attack_base..10000 - 1000 * 1)}
patterns << {:pull => -0.4, :attack => (attack_base..10000 - 1000 * 0)}

list = patterns.collect {|e| {:records => level.collect{|x| {:x => x, :y => Equation::LinearCurve._create(level, e[:attack], e).y_by_x(x)} }}}
Equation::Base.file_output(list, :title => "linear", :filename => "linear_curve.png")

list = patterns.collect {|e| {:records => level.collect{|x| {:x => x, :y => Equation::ParabolaCurve._create(level, e[:attack], e).y_by_x(x)} }}}
Equation::Base.file_output(list, :title => "parabola", :filename => "parabola_curve.png")

list = patterns.collect{|e|{:name => e[:pull], :records => level.collect{|x| {:x => x, :y => Equation::BezierCurve._create(level, e[:attack], e).y_by_x(x)} }}}
Equation::Base.file_output(list, :title => "bezier", :filename => "bezier_curve.png")
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
