module Matron
  class Configuration
    def initialize()
      self.on_failure { raise SystemExit.new( -1 ) }
    end

    def on_failure( &block )
      if block_given?
        @on_failure_action = block
      else
        @on_failure_action
      end
    end
  end
end
