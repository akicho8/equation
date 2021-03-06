require 'spec_helper'

RSpec.describe Equation do
  it 'should have a version number' do
    Equation::VERSION.should_not be_nil
  end

  describe Equation::LinearCurve do
    it do
      curve = Equation::LinearCurve._create(0.1..0.5, 100..150)
      ys = curve.x_range.step(0.1).collect{|x|curve.y_by_x(x)}
      ys.should == [100.0, 112.5, 125.00000000000001, 137.5, 150.0]
      xs = ys.collect{|y| curve.x_by_y(y) }
      xs.should == [0.1, 0.2, 0.30000000000000016, 0.4, 0.5]
    end
  end

  describe Equation::ParabolaCurve do
    it do
      curve = Equation::ParabolaCurve._create(0.1..0.5, 100..150)
      ys = curve.x_range.step(0.1).collect{|x|curve.y_by_x(x)}
      ys.should == [100.0, 103.125, 112.5, 128.125, 150.0]
      xs = ys.collect {|y| curve.x_by_y(y) }
      xs.should == [0.1, 0.2, 0.30000000000000004, 0.4, 0.5]
    end
  end

  describe Equation::BezierCurve do
    it do
      # 早熟
      curve = Equation::BezierCurve._create(1..9, 100..999, :pull => 0.25)
      curve.y_by_x(1).should == 100.0
      curve.y_by_x(2).should == 360.00299257341254
      curve.y_by_x(3).should == 533.3636760044205
      curve.y_by_x(7).should == 905.280428647067
      curve.y_by_x(8).should == 957.1309851468249
      curve.y_by_x(9).should == 999.0

      # 普通
      curve = Equation::BezierCurve._create(1..9, 100..999)
      curve.y_by_x(1).should == 100.0
      curve.y_by_x(2).should == 212.375
      curve.y_by_x(3).should == 324.75
      curve.y_by_x(7).should == 774.25
      curve.y_by_x(8).should == 886.625
      curve.y_by_x(9).should == 999.0

      # 晩成
      curve = Equation::BezierCurve._create(1..9, 100..999, :pull => -0.25)
      curve.y_by_x(1).should == 100.0
      curve.y_by_x(2).should == 141.86901485317503
      curve.y_by_x(3).should == 193.71957135293303
      curve.y_by_x(7).should == 565.6363239955792
      curve.y_by_x(8).should == 738.9970074265875
      curve.y_by_x(9).should == 999.0

      # 晩成タイプで攻撃力からレベルを取得する例
      curve.x_by_y(100).should == 1.0
      curve.x_by_y(200).should == 3.1079480104013744
      curve.x_by_y(300).should == 4.558323219400728
      curve.x_by_y(800).should == 8.280509771224626
      curve.x_by_y(999).should == 9.0
    end

    # ruby 2.2.3p173 (2015-08-18 revision 51636) [x86_64-darwin13] より前だとなぜか交点が取得できずにエラーになっていた
    it "エラーにならない" do
      curve = Equation::BezierCurve._create(0..10, 0..10, :pull => -0.3)
      curve.y_by_x(5).should == 2.2301603505156646
    end
  end

  describe Equation::LevelSupport do
    it do
      klass = Class.new(Equation::ParabolaCurve) { include Equation::LevelSupport }

      curve = klass._create(1..99, 0..9999)
      curve.exp_by_lv(30).should == 876
      curve.lv_by_exp(876).should == 30

      curve.lv_by_exp(950).should == 31
      curve.exp_by_lv(31).should == 938
      curve.exp_by_lv(32).should == 1001

      curve.exp_range_by_lv(8).should == (52..67)
      curve.exp_range_by_lv(9).should == (67..85)
    end
  end

  it "範囲の端の値は自明" do
    params = {x_range: 1..100, y_range: 2000..6000, type: :bezier, pull: 0.40005}
    Equation.create(params).y_by_x(1).should == 2000.0
    Equation.create(params).y_by_x(100).should == 6000.0
    Equation.create(params).x_by_y(2000).should == 1.0
    Equation.create(params).x_by_y(6000).should == 100.0
  end

  it "max...min 状態は早めにエラー" do
    params = {x_range: 1..0, y_range: 1..0, type: :linear}
    proc { Equation.create(params).y_by_x(1) }.should raise_error(ArgumentError)
  end
end
