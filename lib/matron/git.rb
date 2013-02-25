require 'grit'

module Matron
  class Git
    attr_reader :repo

    def initialize( repository )
      @repo = repository
    end

    def changes()
      head = repo.commits.first

      head.diffs.map do |diff|
        CodeSet.new diff.b_path, additions_from( diff.diff )
      end
    end

    def additions_from( diff )
      diff.lines.select { |l| addition? l }.map { |l|
        l.gsub /^[+]/, ""
      }
    end

    def addition?( line )
      line =~ /^[+][^+]/
    end
  end
end
