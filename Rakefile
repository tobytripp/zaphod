# -*- mode: ruby -*-

require "rake"
require "rdoc/task"

begin
  require 'bundler/setup'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts "Bundler not available. Install it with: gem install bundler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new( :spec )

task test: :spec
