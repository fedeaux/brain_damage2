module BrainDamage
  module ResourceHelpers
    attr_accessor :default_indentation

    def display_attributes(attributes, options = {})
      options = {
        indentation: default_indentation,
        join: "\n"
      }.merge options

      attributes.map { |attribute|
        display_attribute(attribute, options[:indentation])
      }.join options[:join]
    end

    def display_attribute(attribute, options = {})
      indentation = default_indentation

      if options.is_a? Numeric
        indentation = options
        options = {}
      elsif options.has_key? :indentation
        indentation = options[:indentation]
        options.delete :indentation
      end

      indent_or_die @resource.display_attribute(attribute, options), indentation
    end

    def input_for(attribute, indentation = default_indentation, &block)
      args = {}

      if block_given?
        args[:encapsulated_block] = encapsulate_block_in_view_context(&block)
      end

      indent_or_die @resource.input_for(attribute, args), indentation
    end

    def indent_or_die(html, indentation = default_indentation)
      return html.indent indentation if html
      false
    end

    def encapsulate_block_in_view_context(&block)
      Proc.new do |*args|
        self.send(:capture, *args, &block)
      end
    end
  end
end
