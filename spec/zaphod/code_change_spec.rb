require 'spec_helper'
require 'zaphod/code_change'
module Zaphod
  describe CodeChange do
    describe "construction" do
      it "accepts a list of source lines" do
        source = ["require 'foo'", "puts 'bar'"]
        set = Zaphod::CodeChange.new "./lib/zaphod/spike.rb", source
        set.source.should == source
      end

      it "expands the given path" do
        path = "./lib/zaphod/spike.rb"
        expect( CodeChange.new( path ).path ).
          to eq( File.expand_path( path ) )
      end
    end

    describe "#eql?" do
      context "when the paths and source are equal" do
        let( :change1 ) { CodeChange.new ".lib/zaphod/spike.rb", ["foo"] }
        let( :change2 ) { CodeChange.new ".lib/zaphod/spike.rb", ["foo"] }

        it( "is true" ) { expect( change1 ).to eql( change2 ) }
      end

      context "when the source list is empty" do
        let( :change1 ) { CodeChange.new ".lib/zaphod/spike.rb" }
        let( :change2 ) { CodeChange.new ".lib/zaphod/spike.rb" }

        it( "is not true" ) { expect( change1 ).to_not eql( change2 ) }
      end

      context "when the sources differ" do
        let( :change1 ) { CodeChange.new ".lib/zaphod/spike.rb", ["bar"] }
        let( :change3 ) { CodeChange.new ".lib/zaphod/spike.rb", ["foo"] }

        it( "is not true" ) { expect( change1 ).to_not eql( change3 ) }
      end

      context "when the sources overlap" do
        let( :change1 ) do
          CodeChange.new "./lib/zaphod/spike.rb", [
            "require 'foo'",
            "Foo.bar!"
          ]
        end

        let( :change2 ) do
          CodeChange.new "./lib/zaphod/spike.rb", [
            "require 'foo'",
            "Foo.bar!",
            "Bar.baz"
          ]
        end

        it( "is true" ) { expect( change1 ).to eql( change2 ) }
      end
    end

    describe "#hash" do
      let( :change1 ) { CodeChange.new ".lib/zaphod/spike.rb" }
      let( :change2 ) { CodeChange.new ".lib/zaphod/spike.rb" }
      let( :change3 ) { CodeChange.new ".lib/zaphod/spike.rb", ["+foo"] }

      it "is the same for two changes that are eql" do
        expect( change1.hash ).to eq( change2.hash )
      end

      it "differs for two changes that have inequal sources" do
        expect( change2.hash ).to_not eq( change3.hash )
      end
    end

  end
end
