# frozen_string_literal: true

require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter

SimpleCov.start do
  enable_coverage :branch
  enable_for_subprocesses true
  # enable_coverage_for_eval

  # minimum coverage threshold
  minimum_coverage 90

  add_filter '/config/'
  add_filter '/spec/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Lib', 'lib'
end
