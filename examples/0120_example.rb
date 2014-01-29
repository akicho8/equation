# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'

# 「あとどれだけ経験値を足せば次のレベルになるか」を調べるときはまりがちな例
curve = Equation::ParabolaCurve.create(1..99, 0..9999)

# まず現在がレベル2でレベル3に移行したいのでそれぞれの必要経験値を調べる
curve.y_by_x(2)                 # => 1.0411286963765098
curve.y_by_x(3)                 # => 4.164514785506039

# 両方をroundしてみると
a = curve.y_by_x(2).round       # => 1
b = curve.y_by_x(3).round       # => 4
diff = b - a                    # => 3
(curve.y_by_x(2) + diff)        # => 4.04112869637651
# 4.04 はレベル3のときの 4.16 を越えていない
# なお、truncate しても ceil しても diff が3になる時点でダメ。
# 同じメソッドで小数を削ってしまうのがダメ。

# 正しい方法1
a = curve.y_by_x(2).floor       # => 1
b = curve.y_by_x(3).ceil        # => 5
diff = b - a                    # => 4
(curve.y_by_x(2) + diff)        # => 5.04112869637651

# 正しい方法2
a = curve.y_by_x(2)             # => 1.0411286963765098
b = curve.y_by_x(3)             # => 4.164514785506039
diff = (b - a).ceil             # => 4
(curve.y_by_x(2) + diff)        # => 5.04112869637651


# 現在の経験値だとレベルはいくつか？の間違いやすい例
curve = Equation::ParabolaCurve.create(1..99, 0..9999)

# 現在の経験値は1000に対応するのはレベル32
curve.x_by_y(1000).round        # => 32
# レベル32から経験値を確認すると
curve.y_by_x(32)                # => 1000.5246772178259
# 現在の経験値 1000 が 1000.52 を越えていない。

# 経験値 1000 の場合のレベルは？
curve.x_by_y(1000)              # => 31.991870701926988
curve.x_by_y(1000).truncate     # => 31
curve.y_by_x(31)                # => 937.0158267388588

