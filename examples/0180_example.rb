# max...min 状態になっているとエラーを特定するのが難しいため引数チェックを入れた
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'

params = {x_range: 1..0, y_range: 1..0, type: :linear}
Equation.create(params).y_by_x(1)  rescue $! # => #<ArgumentError: Equation::LinearCurve._create(1..0, 1..0, [{:x_range=>1..0, :y_range=>1..0}]) の呼び方になっているため正しい範囲が取得できません>
