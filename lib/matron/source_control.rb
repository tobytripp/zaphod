require 'grit'

module Matron
  class SourceControl
    attr_reader :repo

    def initialize( repository )
      @repo = repository
    end

    def changes()
      repo.diff.map do |path, diff|
        CodeSet.new File.expand_path( path ), additions_from( diff.lines )
      end
    end

    def additions_from( lines )
      lines.
        select { |l| addition? l }.
        map    { |l| l.gsub /^[+]/, "" }
    end

    def addition?( line )
      line =~ /^[+][^+]/
    end
  end
end
