module Matron
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
      [path, source].hash
    end

    def inspect()
      "<#{self.class.name} #{path}>\n" + source.join( "\n" )
    end
  end
end
