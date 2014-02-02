require 'simplecov/formatter/shame'
require 'matron/code_change'
require 'matron/source_control'
require 'matron/configuration'

module Matron
  def self.configuration()
    @configuration ||= Configuration.new
  end

  def self.configure()
    yield configuration
  end

  def self.setup()
    require "simplecov"
    yield configuration if block_given?

    SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCov::Formatter::Shame
    ]
    SimpleCov.start
  end
end
