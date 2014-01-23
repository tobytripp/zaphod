require 'spec_helper'
require 'matron/code_change'
module Matron
  describe CodeChange do
    describe "construction" do
      it "accepts a list of source lines" do
        source = ["require 'foo'", "puts 'bar'"]
        set = Matron::CodeChange.new "./lib/matron/spike.rb", source
        set.source.should == source
      end

      it "expands the given path" do
        path = "./lib/matron/spike.rb"
        expect( CodeChange.new( path ).path ).
          to eq( File.expand_path( path ) )
      end
    end

    describe "#eql?" do
      let( :change1 ) { CodeChange.new ".lib/matron/spike.rb" }

      context "when the paths and source are equal" do
        let( :change2 ) { CodeChange.new ".lib/matron/spike.rb" }
        it { expect( change1 ).to eql( change2 ) }
      end

      context "when the sources differ" do
        let( :change3 ) { CodeChange.new ".lib/matron/spike.rb", ["+foo"] }
        it { expect( change1 ).to_not eql( change3 ) }
      end

      context "when the sources overlap" do

      end
    end

    describe "#hash" do
      let( :change1 ) { CodeChange.new ".lib/matron/spike.rb" }
      let( :change2 ) { CodeChange.new ".lib/matron/spike.rb" }
      let( :change3 ) { CodeChange.new ".lib/matron/spike.rb", ["+foo"] }

      it "is the same for two changes that are eql" do
        expect( change1.hash ).to eq( change2.hash )
      end

      it "differs for two changes that have inequal sources" do
        expect( change2.hash ).to_not eq( change3.hash )
      end
    end

  end
end
