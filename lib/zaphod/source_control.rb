require "zaphod/git"

module Zaphod
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
        CodeChange.new File.expand_path( path ), diff
      }
    end
  end
end
