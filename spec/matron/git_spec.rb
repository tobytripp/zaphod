require 'spec_helper'
require 'pp'

describe Matron::Git do
  REPO_PATH = File.dirname(
    File.expand_path( File.join __FILE__, "..", ".." )
    )

  describe "#initialize" do
    it "accepts a repository" do
      described_class.new Grit::Repo.new REPO_PATH
    end
  end

  describe "#changes", integrated: true do
    let( :first_commit ) { stub diffs: [last_diff] }
    let( :commits )      { [first_commit] }
    let( :repository )   { stub commits: commits }
    let( :last_diff )    { stub diff: DIFF, b_path: "spec/spec_helper.rb" }

    let( :git )          { described_class.new repository }

    it "returns a list of CodeSets" do
      git.changes.should be_an_instance_of( Array )
      git.changes.should_not be_empty

      git.changes.each do |change|
        File.exist?( change.path ).should be_true
      end
    end

    it "generates a row for each file in the diff" do
      git.changes.length.should eq 1
    end

    it "passes the additions to each code set" do
      git.changes.first.source.length.should eq(
        DIFF.lines.select { |l| l =~ /^[+][^+]/ }.to_a.size
        )
    end

    it "strips the plusses off the lines" do
      git.changes.first.source.first.should_not start_with( "+" )
    end
  end


  DIFF = <<-EOS
--- /dev/null
+++ b/spec/spec_helper.rb
@@ -1 +1,29 @@
+# This file was generated by the `rspec --init` command. Conventionally, all
+# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
+# Require this file using `require "spec_helper"` to ensure that it is only
+# loaded once.
+#
+# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
+
+require 'simplecov'
+require 'matron'
+
+SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
+  SimpleCov::Formatter::HTMLFormatter,
+  SimpleCov::Formatter::Shame
+]
+
+SimpleCov.start
+
+RSpec.configure do |config|
+  config.treat_symbols_as_metadata_keys_with_true_values = true
+  config.run_all_when_everything_filtered = true
+  config.filter_run :focus
+
+  # Run specs in random order to surface order dependencies. If you find an
+  # order dependency and want to debug it, you can fix the order by providing
+  # the seed, which is printed after each run.
+  #     --seed 1234
+  config.order = 'random'
+end
...
  EOS
end
