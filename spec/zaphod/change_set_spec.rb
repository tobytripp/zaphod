require 'spec_helper'

require 'zaphod/code_change'
require 'zaphod/change_set'

module Zaphod
  describe ChangeSet do
    let( :changes ) do
      [
        Zaphod::CodeChange.new( "/dev/null", ["stuff"] ),
        Zaphod::CodeChange.new( "/dev/null", ["stuff"] ),
      ]
    end

    describe "construction" do
      it "accepts a list of CodeChanges" do
        described_class.new changes
      end

      it "rejects duplicates" do
        expect( described_class.new( changes ) ).to have( 1 ).item
      end
    end

    describe "iteration" do
      subject do
        described_class.new changes
      end

      it "yields each change to a given block" do
        subject.map { |c| c.class }.uniq.should == [Zaphod::CodeChange]
      end

      it "returns an iterator if no block is given" do
        i = subject.map
        i.should be_an_instance_of Enumerator
      end
    end

    describe "#intersection" do
      let( :set1 ) do
        described_class.new([
            CodeChange.new( "/dev/null", ["baz"] ),
            CodeChange.new( "./lib/zaphod/spike.rb", ["+ foo"] )
          ])
      end
      let( :set2 ) do
        described_class.new([
            CodeChange.new( "/dev/null", ["baz"] )
          ])
      end

      it do
        expect( set1.intersection( set2 ) ).
          to eq( ChangeSet.new([ CodeChange.new( "/dev/null", ["baz"] ) ]) )
      end

      context "when the changes are 'eql' but not identical" do
        let( :coverage_change ) do
          CodeChange.new(
            "/app/controllers/tags_controller.rb", [
              "      ) unless Tag.find_by_name(params[:tag_name])\n",
              "    respond_to do |format|\n",
              "      if tag.valid?\n",
              "        format.js {render :json => {:success => true, :message => \"Tag Creation Successful!\"}}\n",
              "        format.js {render :json => {:success => false, :message => tag.errors.inspect}}\n",
              "    puts \"ha HA! I'm a cheater!\"\n"])
        end

        let( :git_change ) do
          CodeChange.new(
            "/app/controllers/tags_controller.rb", [
              "\n",
              "  def uncovered_method\n",
              "    puts \"ha HA! I'm a cheater!\"\n",
              "  end\n"])
        end

        let( :set1 ) { described_class.new([ coverage_change ]) }
        let( :set2 ) { described_class.new([ git_change ]) }

        it "does content based intersection" do
          expect( set1.intersection( set2 ) ).to_not be_empty
        end
      end
    end

    describe "#to_s" do
      subject( :set ) do
        described_class.new([
            CodeChange.new( "/dev/null", ["baz"] ),
            CodeChange.new( "./lib/zaphod/spike.rb", ["foo"] )
          ])
      end

      it do
        expect( set.to_s ).to eq( set.changes.map( &:to_s ).join( "\n" ) )
      end
    end
  end
end
