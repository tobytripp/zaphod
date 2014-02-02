require "spec_helper"
require "matron/configuration"

describe Matron::Configuration do
  subject( :config ) { described_class.new }

  describe "#on_failure" do
    it "stores a proc, if given" do
      proc =  Proc.new { :foo }
      config.on_failure( &proc )
      expect( config.on_failure ).to eq( proc )
    end

    it "defaults to a SystemExit" do
      expect do
        config.on_failure.call
      end.to raise_error( SystemExit )
    end
  end
end
