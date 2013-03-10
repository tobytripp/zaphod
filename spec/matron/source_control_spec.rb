require 'spec_helper'
require 'pp'

describe Matron::SourceControl do
  REPO_PATH = File.dirname(
    File.expand_path( File.join __FILE__, "..", ".." )
    )


  describe "#initialize" do
    it "accepts a repository" do
      described_class.new Grit::Repo.new REPO_PATH
    end
  end

  describe "#changes" do
    let( :patch_map ) do
      {
        "./spec/spec_helper.rb" => "+ require 'rspec'\n",
        "./spec/matron/source_control_spec.rb" => "+ require 'spec_helper'\n"
      }
    end
    let( :repository )   { stub diff: patch_map }

    subject { described_class.new repository }

    it "returns a list of CodeSets" do
      subject.changes.should be_an_instance_of( Array )
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
        patch_map["./spec/spec_helper.rb"].lines.select { |l| l =~ /^[+][^+]/ }.to_a.size
        )
    end

    it "strips the plusses off the lines" do
      subject.changes.first.source.first.should_not start_with( "+" )
    end
  end
end
