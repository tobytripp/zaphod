require "spec_helper"

require 'simplecov/formatter/zaphod_formatter'

describe SimpleCov::Formatter::ZaphodFormatter do
  let( :result ) do
    SimpleCov::Result.new(
      File.expand_path( "./lib/zaphod/spike.rb" ) => [1, 1, 1, 0, nil, nil, nil]
      )
  end

  let!( :source_control ) { Object.new }

  before :each do
    stub( Zaphod::SourceControl ).git { source_control }
    stub( source_control ).changes { Zaphod::ChangeSet.new([]) }
  end

  describe "#format( result )" do
    it "gets the current changes from source control" do
      mock( Zaphod::SourceControl ).git( Dir.pwd ) { source_control }
      subject.format result
    end

    context "when the uncovered lines include the current changes" do
      let( :source_changes ) do
        Zaphod::ChangeSet.new([
            Zaphod::CodeChange.new( "./lib/zaphod/spike.rb", ["      @var = \"foo\"\n"] )
          ])
      end

      before :each do
        stub( source_control ).changes { source_changes }
      end

      it "runs the configured on_failure action, passing uncovered changes" do
        failed = false
        Zaphod.configure do |config|
          config.on_failure { |diff| failed = diff }
        end

        subject.format result

        expect( failed ).to eq( source_changes.changes )
      end
    end

    context "when the uncovered lines do not include the current changes" do
      before :each do
        stub( source_control ).changes { Hash.new }
      end

      it "proceeds normally" do
        subject.format result
      end
    end
  end

  describe "#uncovered( result )" do
    subject { described_class.new.uncovered result }

    it { should_not be_empty }

    it "includes a code set for the file in the result" do
      subject.first.path.should eq File.expand_path("./lib/zaphod/spike.rb")
    end

    it "provides the uncovered source lines to the code set" do
      code_change = subject.first
      code_change.source.first.should =~ /@var/
    end
  end
end
