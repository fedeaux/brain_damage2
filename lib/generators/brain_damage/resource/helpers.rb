module BrainDamage
  module ResourceHelpers
    attr_accessor :default_indentation

    def display_field_names(field_names, options = {})
      options = {
        indentation: default_indentation,
        join: "\n"
      }.merge options

      field_names.map { |field_name|
        display_for(field_name, options[:indentation])
      }.join options[:join]
    end

    def display_for(field_name, options = {})
      indentation = default_indentation

      if options.is_a? Numeric
        indentation = options
        options = {}
      elsif options.has_key? :indentation
        indentation = options[:indentation]
        options.delete :indentation
      end

      options[:identifier] ||= :default

      indent_or_die @resource.fields[field_name].display(options[:identifier]).render, indentation
    end

    def input_for(field_name, indentation = default_indentation, &block)
      args = {}

      if block_given?
        args[:encapsulated_block] = encapsulate_block_in_view_context(&block)
      end

      unless @resource.fields[field_name]
        puts "ERROR: can't find #{field_name}"
        return ''
      else
        indent_or_die @resource.fields[field_name].input.render, indentation
      end
    end

    def input_with_label_for(field_name, indentation = default_indentation)
      unless @resource.fields[field_name]
        puts "ERROR: can't find field #{field_name}"
        return ''
      else
        inner_html = [@resource.fields[field_name].label.render, @resource.fields[field_name].input.render].join "\n"
        indent_or_die inner_html, indentation
      end
    end

    def display_with_label_for(field_name, indentation = default_indentation, context = :default)
      inner_html = [@resource.fields[field_name].label(context).render, @resource.fields[field_name].display(context).render].join "\n"
      indent_or_die inner_html, indentation
    end

    def label_text_for(field_name)
      @resource.fields[field_name].label.text
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

    def template_hook(arg)
      ''
    end
  end
end
