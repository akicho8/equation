# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'gnuplot'

level = 20..100
attack_base = 2000

patterns = []
patterns << {:pull =>  0.40, :attack => (attack_base..10000 - 1000 * 4)}
patterns << {:pull =>  0.20, :attack => (attack_base..10000 - 1000 * 3)}
patterns << {:pull =>  0.00, :attack => (attack_base..10000 - 1000 * 2)}
patterns << {:pull => -0.20, :attack => (attack_base..10000 - 1000 * 1)}
patterns << {:pull => -0.40, :attack => (attack_base..10000 - 1000 * 0)}

list = patterns.collect {|e| {:records => level.collect{|x| {:x => x, :y => Equation::LinearCurve.create(level, e[:attack]).y_by_x(x)} }}}
Equation::Base.output_file(list, :title => "Equation::LinearCurve", :filename => "linear_curve.png")

list = patterns.collect {|e| {:records => level.collect{|x| {:x => x, :y => Equation::ParabolaCurve.create(level, e[:attack]).y_by_x(x)} }}}
Equation::Base.output_file(list, :title => "Equation::ParabolaCurve", :filename => "parabola_curve.png")

list = patterns.collect{|e|{:records => level.collect{|x| {:x => x, :y => Equation::BezierCurve.create(level, e[:attack], e[:pull]).y_by_x(x)} }}}
Equation::Base.output_file(list, :title => "Equation::BezierCurve", :filename => "bezier_curve.png")
