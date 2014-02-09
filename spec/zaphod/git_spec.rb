require 'spec_helper'
require 'zaphod/git'

describe Zaphod::Git do
  let( :path ) { "." }
  let( :repo ) do
    gitrb = Object.new
    stub( gitrb ) do |allow|
      allow.dir.stub!.path       { path }
      allow.diff( "HEAD", path ) { DIFF }
    end
    gitrb
  end

  subject { described_class.new repo }

  describe "to get current changes in the git repository" do
    it "calls #diff on the Git repository object" do
      mock( repo ).diff( "HEAD", "." ) { DIFF }
      subject.diff
    end

    it "returns the patch split into a Hash of file => patch sets" do
      subject.diff.keys.should include(
        "./spec/spec_helper.rb",
        "./spec/zaphod/source_control_spec.rb"
        )
    end

    it "includes only the additions from the patch" do
      additions = DIFF.first.patch.lines.select { |l| l =~ /^[+][^+]/ }
      expect( subject.diff["./spec/spec_helper.rb"].size ).
        to eq( additions.size )
    end

    it "strips the '+'" do
      subject.diff.each do |path, additions|
        expect( additions.all? { |l| ! l.start_with?( "+" ) } ).to be_true
      end
    end
  end

  describe "#user" do
    it "retrieves the user info from the git config" do
      mock( repo ).config { Hash.new }
      subject.user
    end

    it "returns the concatenation of the user name and email" do
      stub( repo ).config do
        {
          "user.name" => "Bob Shlob",
          "user.email" => "bob@mailinator.com"
        }
      end

      expect( subject.user ).to eq( "Bob Shlob bob@mailinator.com" )
    end
  end

  DiffFile = Struct.new :path, :patch
  DIFF = [
    DiffFile.new( "spec/spec_helper.rb", <<-EOS ),
diff --git /dev/null b/spec/spec_helper.rb
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
+require 'zaphod'
+
+SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
+  SimpleCov::Formatter::HTMLFormatter,
+  SimpleCov::Formatter::ZaphodFormatter
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
EOS
    DiffFile.new( "spec/zaphod/source_control_spec.rb", <<-EOS ),
diff --git a/spec/zaphod/source_control_spec.rbf b/spec/zaphod/source_control_spec.rb
index 73d4e77..8ef378d 100644
--- a/spec/zaphod/source_control_spec.rb
+++ b/spec/zaphod/source_control_spec.rb
@@ -6,6 +6,7 @@ describe Zaphod::Git do
     File.expand_path( File.join __FILE__, "..", ".." )
     )

+
   describe "#initialize" do
     it "accepts a repository" do
       described_class.new Grit::Repo.new REPO_PATH
@@ -13,10 +14,9 @@ describe Zaphod::Git do
   end

   describe "#changes", integrated: true do
-    let( :first_commit ) { stub diffs: [last_diff] }
-    let( :commits )      { [first_commit] }
-    let( :repository )   { stub commits: commits }
-    let( :last_diff )    { stub diff: DIFF, b_path: "spec/spec_helper.rb" }
+    let( :patch )        { DIFF }
+    let( :git_native )   { stub diff_index: patch }
+    let( :repository )   { stub git: git_native }

     let( :git )          { described_class.new repository }
EOS
  ]
end
