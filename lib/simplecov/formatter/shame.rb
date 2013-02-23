module SimpleCov
  module Formatter
    class Shame
      def initialize()
      end

      def format( result )
        result.files.each do |source_file|
          pp source_file.missed_lines.map &:src
        end
      end
    end
  end
end

# Send a set of File:Line tuples to a Matron class that intersects it
# with a set from the last git commit.  Blow up and send an email if
# the intersection reveals lines in the current commit that are
# uncovered.
#
# Aborting with a non-zero exit code should propagate properly through
# SimpleCov.
