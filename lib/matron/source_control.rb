require "matron/git"

module Matron
  class SourceControl
    attr_reader :repo

    def self.git( path )
      new Git.from_path( path )
    end

    def initialize( repository )
      @repo = repository
    end

    def changes()
      ChangeSet.new repo.diff.map { |path, diff|
        CodeChange.new File.expand_path( path ), additions_from( diff.lines )
      }
    end

    def additions_from( lines )
      lines.
        select { |l| addition? l }.
        map    { |l| l.gsub( /^[+]/, "" ) }
    end

    def addition?( line )
      line =~ /^[+][^+]/
    end
  end
end
