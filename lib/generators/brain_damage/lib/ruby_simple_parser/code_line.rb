module RubySimpleParser
  class CodeLine
    attr_accessor :line

    def initialize(line)
      @line = line
    end

    def print
      @line
    end
  end
end
