# frozen_string_literal: true

require 'simplecov'

SimpleCov.start do
  enable_coverage :branch
  enable_for_subprocesses true
  # enable_coverage_for_eval

  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Lib', 'lib'
end
