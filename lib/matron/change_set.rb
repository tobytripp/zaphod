require "forwardable"
require "set"

module Matron
  class ChangeSet
    extend Forwardable
    attr_reader :changes
    def_delegators :@changes, :empty?, :each, :map, :first, :length, :intersection

    def initialize( changes )
      @changes = Set.new changes
    end
  end
end
