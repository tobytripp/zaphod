require "spec_helper"

describe Matron do
  describe ".configure" do
    it "takes a block" do
      Matron.configure { :foo }
    end

    it "yields a configuration object" do
      Matron.configure do |config|
        expect( config ).to be_an_instance_of( Matron::Configuration )
      end
    end

    it "yields the same object on repeated calls" do
      config = nil
      Matron.configure { |c| config = c }
      Matron.configure do |c|
        expect( c ).to be( config )
      end
    end
  end

  describe ".setup" do
    it "sets the SimpleCov formatter to include the Shame formatter" do
      Matron.setup

      expected_formatters = [
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::Shame
      ]

      expect( SimpleCov.formatter.new.formatters ).to eq( expected_formatters )
    end

    it "starts simplecov" do
      mock( SimpleCov ).start

      Matron.setup
    end

    it "accepts a configuration block" do
      configuration = nil
      Matron.setup do |config|
        configuration = config
      end
      expect( configuration ).to be_an_instance_of( Matron::Configuration )
    end
  end
end
