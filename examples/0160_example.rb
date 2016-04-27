# 組み合わせる例
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'equation'
require 'gnuplot'

x_range = 1..100
patitions = []
patitions << {x_range: 1..30,   y_range: 0..1500,     type: :bezier, pull: 0.2}
patitions << {x_range: 30..90,  y_range: 1500..4000,  type: :bezier, pull: -0.3}
patitions << {x_range: 90..100, y_range: 4000..10000, type: :bezier, pull: -0.2}

list = patitions.collect do |e|
  {
    :name => "#{e[:x_range]} => #{e[:pull]}",
    :records => x_range.collect{|x|
      if e[:x_range].include?(x)
        {:x => x, :y => Equation.create(e).y_by_x(x)}
      end
    }.compact
  }
end
Equation::Base.output_file(list, :title => "Equation::BezierCurve", :filename => "mix_curve.png")
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "mix_curve.png"
# >> set title "Equation::BezierCurve"
# >> set xlabel ""
# >> set ylabel ""
# >> set key right bottom
# >> 
