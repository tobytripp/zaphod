module Matron
  class CodeSet
    attr_reader :path, :source
    def initialize( path, source_lines=[] )
      @path   = path
      @source = source_lines
    end
  end
end
