require 'grit'

module Matron
  class Git
    attr_reader :repo

    def initialize( repository )
      @repo = repository
    end

    def diff()
      diffs = repo.git.diff_index( { p: true }, "HEAD" ).
        split( /^diff --git .* b(.*)$/ )

      as_hash diffs
    end

    protected

    def as_hash( diff )
      diffs = diff.drop_while( &:empty? )
      relativize_paths Hash[*diffs]
    end

    def relativize_paths( patch_map )
      patch_map.dup.each_with_object( map = {}) do |pair, h|
        h[".#{pair.first}"] = pair.last
      end
      map
    end
  end
end
