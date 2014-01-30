# -*- coding: utf-8 -*-
#
# LVと経験値の相互変換の際の曖昧さを無くす小数点補正
#
#   curve = Equation::ParabolaCurve.create(1..99, 0..9999)
#   curve.exp_by_lv(10)           # => 85
#   curve.lv_by_exp(85)           # => 10
#
#   LV10になるために必要な経験値は85
#   経験値を85にしたときのLVは10
#
module Equation::LevelSupport
  # X軸をLVとしたときY軸の経験値は繰り上げとする(次のLVまでに必要な経験値が1未満足りない事故が起きるため)
  # また経験値からLVを求めたときLVは切り捨てとする(必要経験値に到達していないのにLVが上がってしまうため)
  def exp_by_lv(*args); _y_by_x(*args).ceil;  end
  def lv_by_exp(*args); _x_by_y(*args).floor; end

  # LVから求める値が攻撃力などの場合はこっちのメソッドを使う
  alias value_by_lv exp_by_lv
  alias lv_by_value lv_by_exp

  # 指定LVから次のLVまでの経験値の範囲を返す
  def exp_range_by_lv(lv)
    exp_by_lv(lv) .. exp_by_lv(lv.next)
  end
end
