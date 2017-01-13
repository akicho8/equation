#
# ベジェ曲線を使ったXYの相互変換
#
#   LV 1..9 が攻撃力 100...999 に対応する曲線を、晩成タイプにして指定レベルでの攻撃力を取得するには？
#
#     curve = BezierCurve._create(1..9, 100..999, :pull => -0.25)
#     curve.y_by_x(1)   # => 100.0
#     curve.y_by_x(2)   # => 141.86901485317503
#     curve.y_by_x(3)   # => 193.71957135293303
#     curve.y_by_x(7)   # => 565.6363239955792
#     curve.y_by_x(8)   # => 738.9970074265875
#     curve.y_by_x(9)   # => 999.0
#
#   逆に攻撃力からレベルを取得するには？
#
#     curve.x_by_y(100) # => 1.0
#     curve.x_by_y(200) # => 3.1079480104013744
#     curve.x_by_y(300) # => 4.558323219400728
#     curve.x_by_y(800) # => 8.280509771224626
#     curve.x_by_y(999) # => 9.0
#

require "equation/base"
require "matrix"

module Equation
  class BezierCurve < Base
    attr_reader :pull

    def initialize(*args, **options)
      super(*args)
      @pull = options[:pull]
    end

    def _y_by_x2(x)
      _x = Rational(x - x0, x_range.size - 1)
      y0 + curve.y_by_x(_x) * (y_range.size - 1)
    end

    def _x_by_y2(y)
      _y = Rational(y - y0, y_range.size - 1)
      x0 + curve.x_by_y(_y) * (x_range.size - 1)
    end

    def curve
      SimpleBezirCurve.new(pull)
    end

    class SimpleBezirCurve
      class V < Vector
        def x; self[0]; end
        def y; self[1]; end
      end

      def initialize(pull)
        pull ||= 0.0
        unless pull.kind_of? Array
          # 要素が一つだった場合、Y座標を中心に考えたとして、
          #   正 → 早熟 → 左上に上げる → [-x, +y]
          #   負 → 晩成 → 右下に下げる → [+x, -y]
          # とする
          pull = [-pull, pull]
        end
        @pull = V[*pull]
      end

      def y_by_x(x)
        return x if @pull.magnitude.zero?
        t = intersection!(*points, *line([x, 0.0], [x, 1.0]))
        bezier_curve(*points, t.first).y
      end

      def x_by_y(y)
        return y if @pull.magnitude.zero?
        t = intersection!(*points, *line([0.0, y], [1.0, y]))
        bezier_curve(*points, t.first).x
      end

      private

      def points
        [V[0.0, 0.0], V[0.5 + @pull.x, 0.5 + @pull.y], V[1.0, 1.0]]
      end

      def bezier_curve(p0, p1, p2, t)
        p0 * ((1 - t) * (1 - t)) + p1 * (2 * t * (1 - t)) + p2 * (t * t)
      end

      # ２点から直線の式の求め方 - Yahoo!知恵袋
      # http://detail.chiebukuro.yahoo.co.jp/qa/question_detail/q1255399312
      def line(s0, s1)
        s0 = V[*s0]
        s1 = V[*s1]
        a = s0.y - s1.y
        b = -(s0.x - s1.x)
        c = s0.x * s1.y - s1.x * s0.y
        [a, b, c]
      end

      def intersection!(*args)
        t = intersection(*args)
        if t.empty?
          raise ArgumentError, "直線と曲線の交点が見つかりません。pull が -0.3 か、指定した x y がそれぞれ x_range y_range の範囲に含まれていません"
        end
        t
      end

      # 二次ベジェ曲線と直線の交点
      # http://geom.web.fc2.com/geometry/bezier/qb-line-intersection.html
      # NUTSU » [as]ベジェ曲線と直線の交点
      # http://nutsu.com/blog/2007/101701_as_bezjesegment3.html
      def intersection(p0, p1, p2, a, b, c)
        l = a * (p2.x - 2.0 * p1.x + p0.x) + b * (p2.y - 2.0 * p1.y + p0.y)
        m = 2.0 * (a * (p1.x - p0.x) + b * (p1.y - p0.y))
        n = a * p0.x + b * p0.y + c
        d = m**2 - 4.0 * l * n
        t = []
        if d > 0
          s = Math.sqrt(d)
          t << Rational(-m + s, 2.0 * l)
          t << Rational(-m - s, 2.0 * l)
        elsif d.zero?
          t << Rational(-m, 2.0 * l)
        end
        t.find_all{|v|(0.0..1.0).include?(v)}
      end
    end
  end
end

if $0 == __FILE__
  require "bundler/setup"
  # require "stylet/vector"
  # require "pp"
  require "rain_table"
  require "gnuplot"

  # 開始レベルが1で最終レベルが9、開始レベルのときの攻撃力が100で最終レベル時の攻撃力が999になる場合で、左下0.0と右上1.0を結ぶ二次ベジェ曲線の中央の制御点 X, Y をそれぞれを左上に 0.25 ひっぱったものを早熟、ひっぱらなかったものを普通、右下にひっぱったものを晩成としたときの、指定レベルでの攻撃力を求める例。

  # 早熟
  curve1 = Equation::BezierCurve._create(1..9, 100..999, :pull => 0.25)
  curve1.y_by_x(1)   # => 100.0
  curve1.y_by_x(2)   # => 360.00299257341254
  curve1.y_by_x(3)   # => 533.3636760044205
  curve1.y_by_x(7)   # => 905.280428647067
  curve1.y_by_x(8)   # => 957.1309851468249
  curve1.y_by_x(9)   # => 999.0

  # 普通
  curve2 = Equation::BezierCurve._create(1..9, 100..999)
  curve2.y_by_x(1)   # => 100.0
  curve2.y_by_x(2)   # => 212.375
  curve2.y_by_x(3)   # => 324.75
  curve2.y_by_x(7)   # => 774.25
  curve2.y_by_x(8)   # => 886.625
  curve2.y_by_x(9)   # => 999.0

  # 晩成
  curve3 = Equation::BezierCurve._create(1..9, 100..999, :pull => -0.25)
  curve3.y_by_x(1)   # => 100.0
  curve3.y_by_x(2)   # => 141.86901485317503
  curve3.y_by_x(3)   # => 193.71957135293303
  curve3.y_by_x(7)   # => 565.6363239955792
  curve3.y_by_x(8)   # => 738.9970074265875
  curve3.y_by_x(9)   # => 999.0

  # 晩成タイプで攻撃力からレベルを取得する例
  curve3.x_by_y(100) # => 1.0
  curve3.x_by_y(200) # => 3.1079480104013744
  curve3.x_by_y(300) # => 4.558323219400728
  curve3.x_by_y(800) # => 8.280509771224626
  curve3.x_by_y(999) # => 9.0

  # ひっぱる大きさを5パターンにし、レベル幅1..50で、最初の攻撃力は1000で、それぞれの成長タイプに合わせて最終攻撃力を1000ずつずらしたときのグラフ

  patterns = []
  patterns << {:name => "超早熟", :pull =>  0.40, :level => 1..50, :attack => (1000..10000 - 1000 * 4)}
  patterns << {:name => "早熟",   :pull =>  0.20, :level => 1..50, :attack => (1000..10000 - 1000 * 3)}
  patterns << {:name => "普通",   :pull =>  0.00, :level => 1..50, :attack => (1000..10000 - 1000 * 2)}
  patterns << {:name => "晩成",   :pull => -0.20, :level => 1..50, :attack => (1000..10000 - 1000 * 1)}
  patterns << {:name => "超晩成", :pull => -0.40, :level => 1..50, :attack => (1000..10000 - 1000 * 0)}

  records = (0..50).collect do |level|
    attrs = {}
    attrs[:level] = level
    patterns.each do |e|
      if e[:level].include?(level)
        attrs[e[:name]] = Equation::BezierCurve._create(e[:level], e[:attack], e).y_by_x(level)
      end
    end
    attrs
  end
  tt records

  # patterns.each do |e|
  #   e[:level].collect{|x| {:level => x, e[:name] => Equation::BezierCurve._create(e[:level], e[:attack], e).y_by_x(x)} }
  # end

  Gnuplot.open do |gp|
    Gnuplot::Plot.new(gp) do |plot|
      plot.terminal "png font 'Ricty-Bold.ttf'"
      plot.output "_bezier_curve_all.png"
      plot.title  "成長曲線"
      plot.ylabel "攻撃力"
      plot.xlabel "Level"
      plot.key "right bottom"
      plot.data = patterns.collect do |e|
        x = e[:level].to_a
        y = e[:level].collect{|level| Equation::BezierCurve._create(e[:level], e[:attack], e).y_by_x(level) }
        Gnuplot::DataSet.new([x, y]) do |ds|
          ds.with = "linespoints pointtype 7 pointsize 1.2"
          # ds.notitle
          ds.title = e[:name]
        end
      end
    end
  end
  `open _bezier_curve.png`
end
# >> +-------+--------------------+--------------------+--------------------+--------------------+--------------------+
# >> | level | 超早熟             | 早熟               | 普通               | 晩成               | 超晩成             |
# >> +-------+--------------------+--------------------+--------------------+--------------------+--------------------+
# >> |     0 |                    |                    |                    |                    |                    |
# >> |     1 |             1000.0 |             1000.0 |             1000.0 |             1000.0 |             1000.0 |
# >> |     2 | 1676.1407357449957 | 1276.8562487487247 |  1142.857142857143 | 1070.9504350059128 | 1021.4470378951329 |
# >> |     3 |   2127.49556284711 | 1537.4267926848934 | 1285.7142857142858 |   1143.89345530732 | 1045.0149015265958 |
# >> |     4 |  2479.591836734694 | 1783.5553032190705 | 1428.5714285714287 | 1218.8807987536743 |  1070.770767986988 |
# >> |     5 | 2772.0818618900466 | 2016.7618006023072 | 1571.4285714285713 |  1295.966481693919 |  1098.785437470322 |
# >> |     6 | 3023.6566505846845 | 2238.3170173312415 | 1714.2857142857142 |  1375.206941982268 | 1129.1336128905646 |
# >> |     7 | 3244.8979591836733 |  2449.296137334598 |  1857.142857142857 | 1456.6611937351129 | 1161.8942078732937 |
# >> |     8 |  3442.486671161809 | 2650.6184989407584 |             2000.0 | 1540.3909950412462 | 1197.1506867207147 |
# >> |     9 | 3620.9608795330005 | 2843.0774982370663 | 2142.8571428571427 | 1626.4610299757376 | 1234.9914405029722 |
# >> |    10 | 3783.5700187262414 | 3027.3634963176746 |  2285.714285714286 | 1714.9391064373485 | 1275.5102040816328 |
# >> |    11 |  3932.735509710932 | 3204.0816326530617 | 2428.5714285714284 | 1805.8963715240336 | 1318.8065196455732 |
# >> |    12 | 4070.3191111682236 | 3373.7658641947933 | 2571.4285714285716 | 1899.4075463850277 | 1364.9862532615111 |
# >> |    13 |  4197.788837748987 | 3536.8901638924035 |  2714.285714285714 | 1995.5511827464684 | 1414.1621720437538 |
# >> |    14 |  4316.326530612245 | 3693.8775510204086 | 2857.1428571428573 |  2094.409943606517 | 1466.4545908715727 |
# >> |    15 |  4426.900356170985 | 3845.1074453340343 |             3000.0 | 2196.0709109429326 | 1521.9920991796193 |
# >> |    16 |  4530.315271913573 |  3990.921710323887 | 3142.8571428571427 | 2300.6259236798996 |  1580.912380282842 |
# >> |    17 |  4627.249129332004 |  4131.629660336552 |  3285.714285714286 | 2408.1719496324895 | 1643.3631380562679 |
# >> |    18 |  4718.279114993072 |  4267.512240752952 | 3428.5714285714284 |  2518.811495699464 | 1709.5031486797047 |
# >> |    19 |  4803.901513827712 |  4398.825542261928 | 3571.4285714285716 | 2632.6530612244915 | 1779.5034587173482 |
# >> |    20 |  4884.546747059618 |  4525.803774466635 |  3714.285714285714 |  2749.811640211648 | 1853.5487552144245 |
# >> |    21 |  4960.590996414728 |  4648.661797142011 | 3857.1428571428573 | 2870.4092789880983 | 1931.8389389960953 |
# >> |    22 |  5032.365316532782 | 4767.5972870056685 |             4000.0 | 2994.5756969846725 | 2014.5909392641174 |
# >> |    23 |  5100.162868722304 |  4882.792602167804 |  4142.857142857143 |  3122.448979591838 |   2102.04081632653 |
# >> |    24 |  5164.244728811486 |  4994.416394270655 |  4285.714285714285 |  3254.176353590693 | 2194.4462104339254 |
# >> |    25 |  5224.844598282476 |  5102.625008835547 |  4428.571428571428 |   3389.91505751573 | 2292.0892090072375 |
# >> |    26 |  5282.172661662646 |  5207.563706863201 |  4571.428571428572 | 3529.8333215526027 |  2395.279723091543 |
# >> |    27 |  5336.418771981152 |   5309.36773480698 |  4714.285714285715 |  3674.111474305793 | 2504.3594881393265 |
# >> |    28 |  5387.755102040816 |  5408.163265306121 |  4857.142857142857 | 3822.9431971095946 | 2619.7068362998507 |
# >> |    29 |  5436.338367075489 |  5504.068227261495 |             5000.0 | 3976.5369506591087 | 2741.7424302409913 |
# >> |    30 |  5482.311700557724 |  5597.193040758926 |  5142.857142857143 |  4135.117603810652 |  2870.936206453489 |
# >> |    31 |  5525.806247103097 |  5687.641269841264 |  5285.714285714285 | 4298.9283007111535 | 3007.8158552926875 |
# >> |    32 |  5566.942522934806 |  5775.510204081633 |  5428.571428571428 |   4468.23261031743 | 3152.9772751101177 |
# >> |    33 |   5605.83158406683 |  5860.891378225401 |  5571.428571428572 |  4643.317012329395 |  3307.097593012468 |
# >> |    34 |  5642.576034413184 |  5943.871037775632 |  5714.285714285715 |  4824.493786217931 |  3470.951567202391 |
# >> |    35 |  5677.270899842864 |  6024.530557240076 |  5857.142857142857 |  5012.104386234818 | 3645.4325105555668 |
# >> |    36 | 5710.0043893446555 |  6102.946816792801 |             6000.0 |  5206.523406221287 | 3831.5793588922265 |
# >> |    37 |  5740.858560626903 |  6179.192542295113 |  6142.857142857143 |  5408.163265306124 | 4030.6122448979595 |
# >> |    38 |  5769.909904420137 |  6253.336612940148 |  6285.714285714285 |  5617.479781476794 |  4243.980092051824 |
# >> |    39 |   5797.22985929916 |  6325.444340211227 |  6428.571428571428 |  5834.978847740275 |  4473.425599897195 |
# >> |    40 |   5822.88526686357 |  6395.577721356974 |  6571.428571428572 |  6061.224489795919 |  4721.076082520323 |
# >> |    41 |  5846.938775510203 |  6463.795670171989 |  6714.285714285715 |  6296.848671576434 |  4989.573966292764 |
# >> |    42 |  5869.449199720571 | 6530.1542275181955 |  6857.142857142857 |  6542.563335683913 |  5282.270416840599 |
# >> |    43 |  5890.471840710714 |  6594.706753719064 |             7000.0 |  6799.175334745653 |  5603.523991908743 |
# >> |    44 |  5910.058773403724 |  6657.504104698664 |  7142.857142857143 |  7067.605150220536 |  5959.183673469387 |
# >> |    45 |  5928.259103949686 |  6718.594793513299 |  7285.714285714285 |  7348.910643558345 |  6357.418028947566 |
# >> |    46 |  5945.119201405376 |   6778.02513872956 |  7428.571428571428 |  7644.317599196924 |  6810.252648597914 |
# >> |    47 |  5960.682906673896 |  6835.839400934744 |  7571.428571428572 |  7955.259595707907 |  7336.734693877551 |
# >> |    48 |  5974.991721374113 | 6892.0799085195085 |  7714.285714285715 |  8283.430943086809 |  7970.507986875198 |
# >> |    49 |  5988.084978947149 |  6946.787173745564 |  7857.142857142857 |  8630.858335001702 |  8782.946675659008 |
# >> |    50 |             6000.0 |  6999.999999999999 |             8000.0 |             9000.0 |  9999.999999999996 |
# >> +-------+--------------------+--------------------+--------------------+--------------------+--------------------+
# >> writing this to gnuplot:
# >> set terminal png font 'Ricty-Bold.ttf'
# >> set output "_bezier_curve_all.png"
# >> set title "成長曲線"
# >> set ylabel "攻撃力"
# >> set xlabel "Level"
# >> set key right bottom
# >> 
