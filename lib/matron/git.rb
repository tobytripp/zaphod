require 'grit'

module Matron
  class Git
    attr_reader :repo

    def initialize( repository )
      @repo = repository
    end

    def changes()
      # TODO: extract git-specific commands to another class
      diffs = repo.git.diff_index( { p: true }, "HEAD" ).
        split /^diff --git .* b(.*)$/
      diffs = diffs.drop_while &:empty?

      Hash[*diffs].map do |path, diff|
        CodeSet.new File.expand_path( ".#{path}" ), additions_from( diff )
      end
    end

    def additions_from( diff )
      diff.lines.
        select { |l| addition? l }.
        map    { |l| l.gsub /^[+]/, "" }
    end

    def addition?( line )
      line =~ /^[+][^+]/
    end
  end
end
