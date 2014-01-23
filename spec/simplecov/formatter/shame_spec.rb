require "spec_helper"

require 'simplecov/formatter/shame'

describe SimpleCov::Formatter::Shame do
  let( :result ) do
    SimpleCov::Result.new(
      File.expand_path( "./lib/matron/spike.rb" ) => [1, 1, 1, 0, nil, nil, nil]
      )
  end

  let( :diff ) do
    {
      "./spec/spec_helper.rb" => "+ require 'rspec'\n",
      "./spec/matron/source_control_spec.rb" => "+ require 'spec_helper'\n"
    }
  end

  let( :repository ) do
    stub( Object.new )
  end

  def source_control
    Matron::SourceControl.new repository
  end

  before :each do
    sc = source_control
    stub( Grit::Repo ).new { repository }
    stub( Matron::SourceControl ).new { sc }

    stub( repository ).diff { diff }
  end

  describe "#format( result )" do
    it "instantiates SourceControl with the current repository path" do
      mock( Grit::Repo ).new( Dir.pwd ) { repository }
      subject.format result
    end

    it "gets the current changes from source control" do
      sc = source_control
      mock( Matron::SourceControl ).new( anything ) { sc }
      subject.format result
    end

    context "when the uncovered lines include the current changes" do
      let( :source_changes ) do
        Matron::ChangeSet.new([
            Matron::CodeChange.new( "./lib/matron/spike.rb", ["      @var = \"foo\"\n"] )
          ])
      end

      before :each do
        stub( source_control ).changes { source_changes }
      end

      it "exits with an error" do
        pp source_changes, subject.uncovered( result )
        expect {
          subject.format result
        }.to raise_error( SystemExit )
      end

      it "sends an email"
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
      subject.first.path.should eq File.expand_path("./lib/matron/spike.rb")
    end

    it "provides the uncovered source lines to the code set" do
      code_change = subject.first
      code_change.source.first.should =~ /@var/
    end
  end
end
