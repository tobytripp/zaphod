module Zaphod
  class CodeChange
    attr_reader :path, :source
    def initialize( path, source_lines=[] )
      @path   = File.expand_path path
      @source = source_lines
    end

    def eql?( other )
      return false if source.empty?
      path.eql?( other.path ) &&
        !(source & other.source ).empty?
    end

    def hash()
      [path].hash
    end

    def inspect()
      "#{self.class.name}.new(\"#{path}\", [\n" +
        source.map( &:inspect ).join( ",\n" ) +
        "])"
    end

    def to_s()
      ["### #{path}", source.join].join "\n"
    end
  end
end
