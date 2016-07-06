module RubySimpleParser
  class Method
    METHOD_REGEX = /def\s+(?<method_name>\w+[?!]?)/
    attr_reader :name

    def initialize(definition, visibility)
      @lines = [definition]
      @visibility = visibility
      @name = Method.extract_method_name definition
    end

    def add_line(line)
      @lines << line
    end

    def print
      @lines.join "\n"
    end

    def private?
      @visibility == :private
    end

    def public?
      @visibility == :public
    end

    def self.extract_method_name(code)
      (code.match METHOD_REGEX)[:method_name].to_sym
    end
  end
end
