require 'spec_helper'
require 'matron/code_set'

describe Matron::CodeSet do
  describe "construction" do
    it "accepts a path" do
      set = Matron::CodeSet.new "./lib/matron/spike.rb"
      set.path.should == "./lib/matron/spike.rb"
    end

    it "accepts a list of source lines" do
      source = ["require 'foo'", "puts 'bar'"]
      set = Matron::CodeSet.new "./lib/matron/spike.rb", source
      set.source.should == source
    end
  end
end
