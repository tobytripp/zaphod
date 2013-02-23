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
        diff.diff.lines.map do |line|
          [diff.b_path, line]
        end
      end.flatten 1
    end
  end
end
