module RubySimpleParser
  class Method < Block
    METHOD_REGEX = /def\s+(?<method_name>(self\.)?\w+[?!]?)/
    attr_reader :name

    def initialize(definition, visibility)
      super definition
      @visibility = visibility
      @name = Method.extract_method_name definition
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
