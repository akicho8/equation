# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'

# レベルの範囲が1..99で運の強さが0..9999の範囲を取るとき、直線の関係にある場合の、レベル30のときの運の強さは？ またその値からレベルを求めるには？

curve = Equation::LinearCurve.create(1..99, 0..9999)
v = curve.y_by_x(30)        # => 2958.887755102041
curve.x_by_y(v)             # => 30.0

# レベルの範囲が1..99で経験値が0..9999の範囲を取るとき、放物線の関係にある場合の、レベル30のときの経験値は？ またその値からレベルを求めるには？

curve = Equation::ParabolaCurve.create(1..99, 0..9999)
v = curve.y_by_x(30)        # => 875.5892336526447
curve.x_by_y(v)             # => 29.999999999999996

# レベルの範囲が1..99で攻撃力が0..9999の範囲を取るとき、左下0.0右上1.0を結ぶ斜めのベジェ曲線の中央の制御点を左上に0.25移動させた曲線の関係にある場合の、レベル30のときの攻撃力は？ またその値からレベルを求めるには？

curve = Equation::BezierCurve.create(1..99, 0..9999, 0.25)
v = curve.y_by_x(30)        # => 6958.219471218414
curve.x_by_y(v)             # => 29.99999999999998
