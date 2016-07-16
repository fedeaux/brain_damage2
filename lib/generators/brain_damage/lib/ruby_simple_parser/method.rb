module RubySimpleParser
  class Method < Block
    METHOD_REGEX = /def\s+(?<method_name>(self\.)?\w+[?!]?)/

    def initialize(definition, visibility, parent = nil)
      super definition, parent
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
