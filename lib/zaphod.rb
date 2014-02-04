require 'simplecov/formatter/zaphod_formatter'
require 'zaphod/code_change'
require 'zaphod/source_control'
require 'zaphod/configuration'

module Zaphod
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
      SimpleCov::Formatter::ZaphodFormatter
    ]
    SimpleCov.start
  end
end
