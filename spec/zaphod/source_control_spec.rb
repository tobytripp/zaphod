require 'spec_helper'
require 'pp'

describe Zaphod::SourceControl do
  REPO_PATH = File.dirname(
    File.expand_path( File.join __FILE__, "..", ".." )
    )

  describe "#initialize" do
    it "accepts a repository" do
      described_class.new Git.open( REPO_PATH )
    end
  end

  describe "#changes" do
    let( :patch_map ) do
      {
        "./spec/spec_helper.rb" => "require 'rspec'\n",
        "./spec/zaphod/source_control_spec.rb" => "require 'spec_helper'\n"
      }
    end
    let( :repository ) do
      repo = Object.new
      stub( repo ) do |allow|
        allow.diff { patch_map }
        allow.user { "bob smith smith@mailinator.com" }
      end
      repo
    end

    subject { described_class.new repository }

    it do
      subject.changes.should be_an_instance_of( Zaphod::ChangeSet )
      subject.changes.should_not be_empty

      subject.changes.each do |change|
        File.exist?( change.path ).should be_true, change.path
      end
    end

    it "generates a row for each file in the diff" do
      subject.changes.length.should eq 2
    end

    it "passes the additions to each code set" do
      subject.changes.first.source.length.should eq(
        patch_map["./spec/spec_helper.rb"].length
        )
    end

    it "provides the change set with the name of the alleged slacker" do
      expect( subject.changes.user ).to eq( "bob smith smith@mailinator.com" )
    end
  end
end
