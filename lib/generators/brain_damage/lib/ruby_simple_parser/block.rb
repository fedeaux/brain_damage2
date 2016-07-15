module RubySimpleParser
  class Block
    def initialize(definition)
      @lines = [definition]
    end

    def add_line(line)
      @lines << line
    end

    def print
      @lines.join "\n"
    end
  end
end
