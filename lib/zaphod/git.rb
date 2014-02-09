require "git"
require "logger"

module Zaphod
  class Git
    attr_reader :repo
    attr_accessor :diff_against

    def self.from_path( path )
      new ::Git.open( path, log: Logger.new( "log/zaphod-git.log" ) )
    end

    def initialize( repository, diff_against="HEAD" )
      @repo = repository
      @diff_against = diff_against
    end

    def diff()
      path  = repo.dir.path
      diffs = repo.diff( diff_against, path )
      as_hash diffs
    end

    def user()
      config = repo.config
      [config["user.name"], config["user.email"]].join " "
    end

    protected

    def as_hash( diffs )
      pairs  = diffs.flat_map { |diff_file|
        [diff_file.path, additions( diff_file.patch )]
      }
      relativize_paths Hash[*pairs]
    end

    def additions( patch )
      patch.lines.select { |l| l =~ /^[+][^+]/ }.
        map { |l| l.gsub( /^[+]/, "" ) }
    end

    def relativize_paths( patch_map )
      patch_map.each_with_object( map = {} ) do |pair, h|
        h["./#{pair.first}"] = pair.last
      end
      map
    end
  end
end
