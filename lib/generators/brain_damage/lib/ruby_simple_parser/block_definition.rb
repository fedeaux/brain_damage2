module RubySimpleParser
  class Block
    attr_reader :parent

    def initialize(definition, parent = nil)
      @lines = [definition]
      @parent = parent
    end

    def add_line(line)
      @lines << line
    end

    def print
      @lines.join "\n"
    end
  end
end
