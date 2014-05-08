# -*- coding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'equation'
require 'equation/level_support'
Equation::Base.send(:include, Equation::LevelSupport)

Equation::LinearCurve._create(15..15, 100..200).exp_by_lv(15) rescue $! # => #<ZeroDivisionError: divided by 0>
