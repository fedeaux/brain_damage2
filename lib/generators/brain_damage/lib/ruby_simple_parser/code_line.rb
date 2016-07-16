module RubySimpleParser
  class CodeLine
    attr_accessor :line
    attr_reader :parent

    def initialize(line, parent)
      @parent = parent
      @line = line
      @parent.add_line self
    end

    def print
      @line
    end
  end
end
