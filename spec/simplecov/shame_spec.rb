require "spec_helper"

require 'simplecov/formatter/shame'

describe SimpleCov::Formatter::Shame do
  let( :result ) do
    SimpleCov::Result.new(
      File.expand_path( "./lib/matron/spike.rb" ) => [1, 1, 1, 0, nil, nil, nil]
      )
  end

  describe "#format( result )" do

    it "gets the current changes from git"
    it "compares the changes to the uncovered code"

    context "when the uncovered lines include the current changes" do
      it "exits with an error"
      it "sends an email"
    end

    context "when the uncovered lines do not include the current changes" do
      it "proceeds normally"
    end
  end

  describe "#uncovered( result )" do
    subject { described_class.new.uncovered result }

    it { should be_an_instance_of Array }
    it { should_not be_empty }

    it "includes a code set for the file in the result" do
      subject.first.path.should eq File.expand_path("./lib/matron/spike.rb")
    end

    it "provides the uncovered source lines to the code set" do
      code_set = subject.first
      code_set.source.first.should =~ /@var/
    end
  end
end
