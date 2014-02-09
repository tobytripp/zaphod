require "forwardable"
require "set"

module Zaphod
  class ChangeSet
    extend Forwardable
    attr_reader :changes, :user
    def_delegators :@changes, :empty?, :each, :map, :first, :length, :include?, :add, :any?

    def initialize( changes=[], user="unknown" )
      @changes, @user = Set.new( changes ), user
    end

    def intersection( other )
      changes.each_with_object( self.class.new ) do |change, set|
        set.add( change ) if other.any? { |c| c.eql? change }
      end
    end

    def ==( other )
      changes == other.changes
    end

    def to_s()
      ["## #{user}", changes.map( &:to_s )].join "\n"
    end
  end
end
