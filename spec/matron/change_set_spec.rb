require 'spec_helper'

require 'matron/code_change'
require 'matron/change_set'

module Matron
  describe ChangeSet do
    let( :changes ) do
      [
        Matron::CodeChange.new( "/dev/null", ["stuff"] ),
        Matron::CodeChange.new( "/dev/null", ["stuff"] ),
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
        subject.map { |c| c.class }.uniq.should == [Matron::CodeChange]
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
            CodeChange.new( "./lib/matron/spike.rb", ["+ foo"] )
          ])
      end
      let( :set2 ) do
        described_class.new([
            CodeChange.new( "/dev/null", ["baz"] )
          ])
      end

      it do
        expect( set1.intersection( set2 ) ).
          to eq( Set.new([ CodeChange.new( "/dev/null", ["baz"] ) ]) )
      end
    end
  end
end
