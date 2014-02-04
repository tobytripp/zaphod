require "spec_helper"

describe Zaphod do
  describe ".configure" do
    it "takes a block" do
      Zaphod.configure { :foo }
    end

    it "yields a configuration object" do
      Zaphod.configure do |config|
        expect( config ).to be_an_instance_of( Zaphod::Configuration )
      end
    end

    it "yields the same object on repeated calls" do
      config = nil
      Zaphod.configure { |c| config = c }
      Zaphod.configure do |c|
        expect( c ).to be( config )
      end
    end
  end

  describe ".setup" do
    it "sets the SimpleCov formatter to include the Zaphod formatter" do
      Zaphod.setup

      expected_formatters = [
        SimpleCov::Formatter::HTMLFormatter,
        SimpleCov::Formatter::ZaphodFormatter
      ]

      expect( SimpleCov.formatter.new.formatters ).to eq( expected_formatters )
    end

    it "starts simplecov" do
      mock( SimpleCov ).start

      Zaphod.setup
    end

    it "accepts a configuration block" do
      configuration = nil
      Zaphod.setup do |config|
        configuration = config
      end
      expect( configuration ).to be_an_instance_of( Zaphod::Configuration )
    end
  end
end
