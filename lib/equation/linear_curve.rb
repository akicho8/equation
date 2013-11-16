# -*- coding: utf-8 -*-
#
# 一次関数を使ったXYの相互変換
#
#   レベル1..99が何か0..9999に対応する一次関数でレベル30のときの何か？ またその逆は？
#
#     curve = LinearCurve.create(1..99, 0..9999)
#     v = curve.y_by_x(30)        # => 875.5892336526448
#     curve.x_by_y(v)             # => 30.0
#

require "equation/base"

module Equation
  class LinearCurve < Base
    def _y_by_x(x)
      Rational((y1 - y0) * (x - x0), x1 - x0) + y0
    end

    def _x_by_y(y)
      Rational((y - y0) * (x1 - x0), y1 - y0) + x0
    end
  end
end

if $0 == __FILE__
  require "bundler/setup"
  require "rain_table"
  require "gnuplot"

  def output_file(records, filename)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.terminal "png font 'Ricty-Bold.ttf'"
        plot.output filename
        # plot.title "レベルに比例する何か"
        plot.xlabel "Level"
        # plot.xtics 1
        plot.ylabel "何か"
        # plot.xrange "[0:*]"
        # plot.yrange "[0:*]"
        records.each.with_index{|e, i|
          plot.label "#{i.next} center at first #{e[:lv]}, #{e[:exp]} '#{e[:exp]}'"
        }
        plot.data << Gnuplot::DataSet.new([records.collect{|e|e[:lv]}, records.collect{|e|e[:exp]}]) do |ds|
          ds.with = "linespoints pointtype 7 pointsize 0.5"
          ds.notitle
        end
      end
    end
  end

  curve = Equation::LinearCurve.create(1..20, 300..2400)
  y = curve.y_by_x(15)                # => 1847.3684210526317
  curve.x_by_y(y)                     # => 15.0

  records = (1..20).collect do |level|
    {:lv => level, :exp => curve.y_by_x(level).round(2)}
  end

  output_file(records, "_linear_curve.png")

  curve = Equation::LinearCurve.create(1..99, 1..3)
  tt (1..99).collect {|level| {:lv => level, :exp => curve.y_by_x(level).to_f} }
end
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "_linear_curve.png"
# >> set xlabel "Level"
# >> set ylabel "何か"
# >> set label 1 center at first 1, 300.0 '300.0'
# >> set label 2 center at first 2, 410.53 '410.53'
# >> set label 3 center at first 3, 521.05 '521.05'
# >> set label 4 center at first 4, 631.58 '631.58'
# >> set label 5 center at first 5, 742.11 '742.11'
# >> set label 6 center at first 6, 852.63 '852.63'
# >> set label 7 center at first 7, 963.16 '963.16'
# >> set label 8 center at first 8, 1073.68 '1073.68'
# >> set label 9 center at first 9, 1184.21 '1184.21'
# >> set label 10 center at first 10, 1294.74 '1294.74'
# >> set label 11 center at first 11, 1405.26 '1405.26'
# >> set label 12 center at first 12, 1515.79 '1515.79'
# >> set label 13 center at first 13, 1626.32 '1626.32'
# >> set label 14 center at first 14, 1736.84 '1736.84'
# >> set label 15 center at first 15, 1847.37 '1847.37'
# >> set label 16 center at first 16, 1957.89 '1957.89'
# >> set label 17 center at first 17, 2068.42 '2068.42'
# >> set label 18 center at first 18, 2178.95 '2178.95'
# >> set label 19 center at first 19, 2289.47 '2289.47'
# >> set label 20 center at first 20, 2400.0 '2400.0'
# >>
# >> +----+--------------------+
# >> | lv | exp                |
# >> +----+--------------------+
# >> |  1 |                1.0 |
# >> |  2 | 1.0204081632653061 |
# >> |  3 | 1.0408163265306123 |
# >> |  4 | 1.0612244897959184 |
# >> |  5 | 1.0816326530612246 |
# >> |  6 | 1.1020408163265305 |
# >> |  7 | 1.1224489795918366 |
# >> |  8 | 1.1428571428571428 |
# >> |  9 |  1.163265306122449 |
# >> | 10 |  1.183673469387755 |
# >> | 11 | 1.2040816326530612 |
# >> | 12 | 1.2244897959183674 |
# >> | 13 | 1.2448979591836735 |
# >> | 14 | 1.2653061224489797 |
# >> | 15 | 1.2857142857142858 |
# >> | 16 | 1.3061224489795917 |
# >> | 17 | 1.3265306122448979 |
# >> | 18 |  1.346938775510204 |
# >> | 19 | 1.3673469387755102 |
# >> | 20 | 1.3877551020408163 |
# >> | 21 | 1.4081632653061225 |
# >> | 22 | 1.4285714285714286 |
# >> | 23 | 1.4489795918367347 |
# >> | 24 |  1.469387755102041 |
# >> | 25 |  1.489795918367347 |
# >> | 26 |  1.510204081632653 |
# >> | 27 |  1.530612244897959 |
# >> | 28 | 1.5510204081632653 |
# >> | 29 | 1.5714285714285714 |
# >> | 30 | 1.5918367346938775 |
# >> | 31 | 1.6122448979591837 |
# >> | 32 | 1.6326530612244898 |
# >> | 33 |  1.653061224489796 |
# >> | 34 | 1.6734693877551021 |
# >> | 35 | 1.6938775510204083 |
# >> | 36 | 1.7142857142857142 |
# >> | 37 | 1.7346938775510203 |
# >> | 38 | 1.7551020408163265 |
# >> | 39 | 1.7755102040816326 |
# >> | 40 | 1.7959183673469388 |
# >> | 41 |  1.816326530612245 |
# >> | 42 |  1.836734693877551 |
# >> | 43 | 1.8571428571428572 |
# >> | 44 | 1.8775510204081634 |
# >> | 45 | 1.8979591836734695 |
# >> | 46 | 1.9183673469387754 |
# >> | 47 | 1.9387755102040816 |
# >> | 48 | 1.9591836734693877 |
# >> | 49 | 1.9795918367346939 |
# >> | 50 |                2.0 |
# >> | 51 |  2.020408163265306 |
# >> | 52 | 2.0408163265306123 |
# >> | 53 |  2.061224489795918 |
# >> | 54 | 2.0816326530612246 |
# >> | 55 | 2.1020408163265305 |
# >> | 56 |  2.122448979591837 |
# >> | 57 |  2.142857142857143 |
# >> | 58 |  2.163265306122449 |
# >> | 59 |  2.183673469387755 |
# >> | 60 |  2.204081632653061 |
# >> | 61 | 2.2244897959183674 |
# >> | 62 | 2.2448979591836733 |
# >> | 63 | 2.2653061224489797 |
# >> | 64 | 2.2857142857142856 |
# >> | 65 |  2.306122448979592 |
# >> | 66 |  2.326530612244898 |
# >> | 67 | 2.3469387755102042 |
# >> | 68 |   2.36734693877551 |
# >> | 69 | 2.3877551020408165 |
# >> | 70 | 2.4081632653061225 |
# >> | 71 | 2.4285714285714284 |
# >> | 72 | 2.4489795918367347 |
# >> | 73 | 2.4693877551020407 |
# >> | 74 |  2.489795918367347 |
# >> | 75 |  2.510204081632653 |
# >> | 76 | 2.5306122448979593 |
# >> | 77 | 2.5510204081632653 |
# >> | 78 | 2.5714285714285716 |
# >> | 79 | 2.5918367346938775 |
# >> | 80 | 2.6122448979591835 |
# >> | 81 |   2.63265306122449 |
# >> | 82 | 2.6530612244897958 |
# >> | 83 |  2.673469387755102 |
# >> | 84 |  2.693877551020408 |
# >> | 85 | 2.7142857142857144 |
# >> | 86 | 2.7346938775510203 |
# >> | 87 | 2.7551020408163267 |
# >> | 88 | 2.7755102040816326 |
# >> | 89 |  2.795918367346939 |
# >> | 90 |  2.816326530612245 |
# >> | 91 |  2.836734693877551 |
# >> | 92 |  2.857142857142857 |
# >> | 93 |  2.877551020408163 |
# >> | 94 | 2.8979591836734695 |
# >> | 95 | 2.9183673469387754 |
# >> | 96 |  2.938775510204082 |
# >> | 97 | 2.9591836734693877 |
# >> | 98 |  2.979591836734694 |
# >> | 99 |                3.0 |
# >> +----+--------------------+
