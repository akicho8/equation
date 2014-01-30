# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'equation/level_support'
Equation::Base.send(:include, Equation::LevelSupport)

curve = Equation::ParabolaCurve.create(1..99, 0..9999)
curve.lv_by_exp(1000)           # => 31
curve.exp_by_lv(31)             # => 938
curve.lv_by_exp(938)            # => 31
