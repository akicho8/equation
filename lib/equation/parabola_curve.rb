# -*- coding: utf-8 -*-
#
# 二次関数を使ったXYの相互変換
#
#   レベル1..99が経験値0..9999に対応する二次関数でレベル30のときの経験値は？ またその逆は？
#
#     curve = ParabolaCurve.create(1..99, 0..9999)
#     exp = curve.y_by_x(30)        # => 875.5892336526448
#     curve.x_by_y(exp)             # => 30.0
#
#   レベル1のとき経験値0で、99のとき9999になる曲線で── と考えるとき用
#
#     curve = ParabolaCurve.new(1, 0, 99, 9999)
#
#   方程式
#
#     y = a * (x - p)**2 + q
#     x = Math.sqrt(((exp-q).to_f / a).abs) + p
#     a = (y - q).to_f / ((x - p) ** 2)
#
#     開始 (p, q) 終端 (x, y) を入れると a が求まる
#     x か y を入れたら片方が求まる
#
#   参照
#
#     高等学校数学I/二次関数 - Wikibooks
#     http://ja.wikibooks.org/wiki/%E9%AB%98%E7%AD%89%E5%AD%A6%E6%A0%A1%E6%95%B0%E5%AD%A6I/%E4%BA%8C%E6%AC%A1%E9%96%A2%E6%95%B0
#
require "equation/base"

module Equation
  class ParabolaCurve < Base
    def _y_by_x(x)
      a * (x - x0) ** 2 + y0
    end

    def _x_by_y(y)
      Math.sqrt(((y - y0).to_f / a).abs) + x0
    end

    def a
      Rational(y1 - y0, (x1 - x0) ** 2)
    end
  end
end

if $0 == __FILE__
  require "bundler/setup"
  require "rain_table"
  require "gnuplot"

  class Equation::ParabolaCurve
    def level_elems
      (x0..x1).collect {|level| {:lv => level, :exp => y_by_x(level)} }
    end

    def exp_elems
      (y0..y1).step(250).collect {|exp| {:lv => x_by_y(exp).round(2), :exp => exp} }
    end
  end

  def output_file(records, filename)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.terminal "png font 'Ricty-Bold.ttf'"
        plot.output filename
        plot.title "経験値曲線"
        plot.xlabel "Level"
        plot.xtics 1
        plot.ylabel "累計経験値"
        plot.xrange "[0:*]"
        plot.yrange "[0:*]"
        records.each.with_index{|e, i|
          plot.label "#{i.next} center at first #{e[:lv]}, #{e[:exp]} '#{e[:exp]}'"
        }
        plot.data << Gnuplot::DataSet.new([records.collect{|e|e[:lv]}, records.collect{|e|e[:exp]}]) do |ds|
          ds.with = "linespoints pointtype 7 pointsize 0.0"
          ds.notitle
        end
      end
    end
  end

  # x_range = 55..74
  # y_range = 3..59
  # v = Equation::ParabolaCurve.create(x_range, y_range).y_by_x(74)
  # exit

  # レベル1..20で経験値0..999のときと考える場合
  curve = Equation::ParabolaCurve.create(1..20, 0..999)
  exp = curve.y_by_x(15)           # => 542.393351800554
  curve.x_by_y(exp)                # => 15.0

  # 経験値 540 のときのレベルは？

  curve.x_by_y(542)           # => 14.994922574200181

  # グラフ化

  records = (1..20).collect do |level| # !> assigned but unused variable - id
    {:lv => level, :exp => curve.y_by_x(level)}
  end
  tt records

  tt curve.level_elems

  output_file(records, "_exp_curve1.png")

  # レベル2のときに経験値10にするには？

  curve = Equation::ParabolaCurve.create(2..20, 10..999)
  curve.y_by_x(2)           # => 10.0

  # レベル 21..25 は崖っ縁にしたい場合は？

  curve = Equation::ParabolaCurve.create(20..25, 999..10000)
  curve.y_by_x(20)          # => 999.0
  curve.y_by_x(21)          # => 1359.04
  curve.y_by_x(22)          # => 2439.16
  curve.y_by_x(23)          # => 4239.36
  curve.y_by_x(24)          # => 6759.64
  curve.y_by_x(25)          # => 10000.0

  records += (21..25).collect do |level|
    {:lv => level, :exp => curve.y_by_x(level)}
  end

  output_file(records, "_exp_curve2.png")

  tt curve.level_elems
  tt curve.exp_elems

  # x_range.max のとき y_range.max になることのテスト
  hash = Hash.new(0)
  1000.times do
    x_range = Range.new(*[rand(10), rand(10)].sort)
    y_range = Range.new(*[rand(10), rand(10)].sort)
    if x_range.size <= 1 || y_range.size <= 1
      next
    end
    v = Equation::ParabolaCurve.create(x_range, y_range).y_by_x(x_range.max)
    if v != y_range.max
      p [x_range, y_range, v]
    end
    hash[(v == y_range.max)] += 1
  end
  p hash

end
# >> +----+--------------------+
# >> | lv | exp                |
# >> +----+--------------------+
# >> |  1 |                0.0 |
# >> |  2 | 2.7673130193905817 |
# >> |  3 | 11.069252077562327 |
# >> |  4 | 24.905817174515235 |
# >> |  5 |  44.27700831024931 |
# >> |  6 |  69.18282548476455 |
# >> |  7 |  99.62326869806094 |
# >> |  8 |  135.5983379501385 |
# >> |  9 | 177.10803324099723 |
# >> | 10 | 224.15235457063713 |
# >> | 11 |  276.7313019390582 |
# >> | 12 |  334.8448753462604 |
# >> | 13 | 398.49307479224376 |
# >> | 14 | 467.67590027700834 |
# >> | 15 |   542.393351800554 |
# >> | 16 |  622.6454293628809 |
# >> | 17 |  708.4321329639889 |
# >> | 18 |  799.7534626038781 |
# >> | 19 |  896.6094182825485 |
# >> | 20 |              999.0 |
# >> +----+--------------------+
# >> +----+--------------------+
# >> | lv | exp                |
# >> +----+--------------------+
# >> |  1 |                0.0 |
# >> |  2 | 2.7673130193905817 |
# >> |  3 | 11.069252077562327 |
# >> |  4 | 24.905817174515235 |
# >> |  5 |  44.27700831024931 |
# >> |  6 |  69.18282548476455 |
# >> |  7 |  99.62326869806094 |
# >> |  8 |  135.5983379501385 |
# >> |  9 | 177.10803324099723 |
# >> | 10 | 224.15235457063713 |
# >> | 11 |  276.7313019390582 |
# >> | 12 |  334.8448753462604 |
# >> | 13 | 398.49307479224376 |
# >> | 14 | 467.67590027700834 |
# >> | 15 |   542.393351800554 |
# >> | 16 |  622.6454293628809 |
# >> | 17 |  708.4321329639889 |
# >> | 18 |  799.7534626038781 |
# >> | 19 |  896.6094182825485 |
# >> | 20 |              999.0 |
# >> +----+--------------------+
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "_exp_curve1.png"
# >> set title "経験値曲線"
# >> set xlabel "Level"
# >> set xtics 1
# >> set ylabel "累計経験値"
# >> set xrange [0:*]
# >> set yrange [0:*]
# >> set label 1 center at first 1, 0.0 '0.0'
# >> set label 2 center at first 2, 2.7673130193905817 '2.7673130193905817'
# >> set label 3 center at first 3, 11.069252077562327 '11.069252077562327'
# >> set label 4 center at first 4, 24.905817174515235 '24.905817174515235'
# >> set label 5 center at first 5, 44.27700831024931 '44.27700831024931'
# >> set label 6 center at first 6, 69.18282548476455 '69.18282548476455'
# >> set label 7 center at first 7, 99.62326869806094 '99.62326869806094'
# >> set label 8 center at first 8, 135.5983379501385 '135.5983379501385'
# >> set label 9 center at first 9, 177.10803324099723 '177.10803324099723'
# >> set label 10 center at first 10, 224.15235457063713 '224.15235457063713'
# >> set label 11 center at first 11, 276.7313019390582 '276.7313019390582'
# >> set label 12 center at first 12, 334.8448753462604 '334.8448753462604'
# >> set label 13 center at first 13, 398.49307479224376 '398.49307479224376'
# >> set label 14 center at first 14, 467.67590027700834 '467.67590027700834'
# >> set label 15 center at first 15, 542.393351800554 '542.393351800554'
# >> set label 16 center at first 16, 622.6454293628809 '622.6454293628809'
# >> set label 17 center at first 17, 708.4321329639889 '708.4321329639889'
# >> set label 18 center at first 18, 799.7534626038781 '799.7534626038781'
# >> set label 19 center at first 19, 896.6094182825485 '896.6094182825485'
# >> set label 20 center at first 20, 999.0 '999.0'
# >>
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "_exp_curve2.png"
# >> set title "経験値曲線"
# >> set xlabel "Level"
# >> set xtics 1
# >> set ylabel "累計経験値"
# >> set xrange [0:*]
# >> set yrange [0:*]
# >> set label 1 center at first 1, 0.0 '0.0'
# >> set label 2 center at first 2, 2.7673130193905817 '2.7673130193905817'
# >> set label 3 center at first 3, 11.069252077562327 '11.069252077562327'
# >> set label 4 center at first 4, 24.905817174515235 '24.905817174515235'
# >> set label 5 center at first 5, 44.27700831024931 '44.27700831024931'
# >> set label 6 center at first 6, 69.18282548476455 '69.18282548476455'
# >> set label 7 center at first 7, 99.62326869806094 '99.62326869806094'
# >> set label 8 center at first 8, 135.5983379501385 '135.5983379501385'
# >> set label 9 center at first 9, 177.10803324099723 '177.10803324099723'
# >> set label 10 center at first 10, 224.15235457063713 '224.15235457063713'
# >> set label 11 center at first 11, 276.7313019390582 '276.7313019390582'
# >> set label 12 center at first 12, 334.8448753462604 '334.8448753462604'
# >> set label 13 center at first 13, 398.49307479224376 '398.49307479224376'
# >> set label 14 center at first 14, 467.67590027700834 '467.67590027700834'
# >> set label 15 center at first 15, 542.393351800554 '542.393351800554'
# >> set label 16 center at first 16, 622.6454293628809 '622.6454293628809'
# >> set label 17 center at first 17, 708.4321329639889 '708.4321329639889'
# >> set label 18 center at first 18, 799.7534626038781 '799.7534626038781'
# >> set label 19 center at first 19, 896.6094182825485 '896.6094182825485'
# >> set label 20 center at first 20, 999.0 '999.0'
# >> set label 21 center at first 21, 1359.04 '1359.04'
# >> set label 22 center at first 22, 2439.16 '2439.16'
# >> set label 23 center at first 23, 4239.36 '4239.36'
# >> set label 24 center at first 24, 6759.64 '6759.64'
# >> set label 25 center at first 25, 10000.0 '10000.0'
# >>
# >> +----+---------+
# >> | lv | exp     |
# >> +----+---------+
# >> | 20 |   999.0 |
# >> | 21 | 1359.04 |
# >> | 22 | 2439.16 |
# >> | 23 | 4239.36 |
# >> | 24 | 6759.64 |
# >> | 25 | 10000.0 |
# >> +----+---------+
# >> +-------+------+
# >> | lv    | exp  |
# >> +-------+------+
# >> |  20.0 |  999 |
# >> | 20.83 | 1249 |
# >> | 21.18 | 1499 |
# >> | 21.44 | 1749 |
# >> | 21.67 | 1999 |
# >> | 21.86 | 2249 |
# >> | 22.04 | 2499 |
# >> |  22.2 | 2749 |
# >> | 22.36 | 2999 |
# >> |  22.5 | 3249 |
# >> | 22.64 | 3499 |
# >> | 22.76 | 3749 |
# >> | 22.89 | 3999 |
# >> |  23.0 | 4249 |
# >> | 23.12 | 4499 |
# >> | 23.23 | 4749 |
# >> | 23.33 | 4999 |
# >> | 23.44 | 5249 |
# >> | 23.54 | 5499 |
# >> | 23.63 | 5749 |
# >> | 23.73 | 5999 |
# >> | 23.82 | 6249 |
# >> | 23.91 | 6499 |
# >> |  24.0 | 6749 |
# >> | 24.08 | 6999 |
# >> | 24.17 | 7249 |
# >> | 24.25 | 7499 |
# >> | 24.33 | 7749 |
# >> | 24.41 | 7999 |
# >> | 24.49 | 8249 |
# >> | 24.56 | 8499 |
# >> | 24.64 | 8749 |
# >> | 24.71 | 8999 |
# >> | 24.79 | 9249 |
# >> | 24.86 | 9499 |
# >> | 24.93 | 9749 |
# >> |  25.0 | 9999 |
# >> +-------+------+
# >> {true=>818}
