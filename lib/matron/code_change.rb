module Matron
  class CodeChange
    attr_reader :path, :source
    def initialize( path, source_lines=[] )
      @path   = File.expand_path path
      @source = source_lines
    end

    def eql?( other )
      path.eql?( other.path ) && source.eql?( other.source )
    end

    def hash()
      [path, source].hash
    end
  end
end
