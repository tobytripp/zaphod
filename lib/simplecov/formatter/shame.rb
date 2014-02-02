require "matron/change_set"

module SimpleCov
  module Formatter
    # Send a set of File:Line tuples to a Matron class that intersects
    # it with a set from the last git commit. Blow up and send an
    # email if the intersection reveals lines in the current commit
    # that are uncovered.
    #
    # Aborting with a non-zero exit code should propagate properly
    # through SimpleCov.
    #
    class Shame
      attr_accessor :source_control

      def initialize()
        @source_control = Matron::SourceControl.git Dir.pwd
      end

      def format( result )
        uncovered_codeset = uncovered result
        changed_codeset   = source_control.changes

        diff = uncovered_codeset.intersection( changed_codeset )
        unless diff.empty?
          Matron.configuration.on_failure.call diff
        end
      end

      def uncovered( result )
        Matron::ChangeSet.new result.files.map { |source_file|
          Matron::CodeChange.new(
            source_file.filename,
            source_file.missed_lines.map( &:src )
            )
        }
      end
    end
  end
end
