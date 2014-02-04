require "zaphod/change_set"

module SimpleCov
  module Formatter
    # Send a set of File:Line tuples to a Zaphod class that intersects
    # it with a set from the last git commit. Call the failure hook if
    # the intersection reveals lines in the current changeset that are
    # uncovered.
    #
    # Aborting with a non-zero exit code should propagate properly
    # through SimpleCov.
    #
    class ZaphodFormatter
      attr_accessor :source_control

      def initialize()
        @source_control = Zaphod::SourceControl.git Dir.pwd
      end

      def format( result )
        uncovered_codeset = uncovered result
        changed_codeset   = source_control.changes

        diff = uncovered_codeset.intersection( changed_codeset )
        if $DEBUG || ENV["DEBUG"]
          require "pp"
          pp(
            "--- UNCOVERED ---", uncovered_codeset,
            "---  CHANGED  ---", changed_codeset,
            "---    DIFF   ---", diff
            )
        end
        unless diff.empty?
          Zaphod.configuration.on_failure.call diff
        end
      end

      def uncovered( result )
        Zaphod::ChangeSet.new result.files.map { |source_file|
          Zaphod::CodeChange.new(
            source_file.filename,
            source_file.missed_lines.map( &:src )
            )
        }
      end
    end
  end
end
