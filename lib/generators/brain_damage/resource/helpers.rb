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
      indentation = options[:indentation] || default_indentation
      options = options.except :indentation

      options[:identifier] ||= :default

      display = @resource.fields[field_name].display(options[:identifier])

      if display
        html = display.render
      else
        html = ''
        puts "ERROR: Unable to find a suitable display for #{field_name} (@ #{options[:identifier]})"
      end

      indent_or_die html, indentation
    end

    def label_for(field_name, options = {})
      indentation = options[:indentation] || default_indentation
      options = options.except :indentation

      options[:identifier] ||= :default

      begin
        indent_or_die @resource.fields[field_name].label(options[:identifier]).render, indentation
      rescue
        puts "ERROR on #{field_name}"
      end
    end

    def display_with_label_for(field_name, options = {})
      indentation = options[:indentation] || default_indentation
      options[:indentation] = 0

      inner_html = [label_for(field_name, options), display_for(field_name, options)].join "\n"
      indent_or_die inner_html, indentation
    end

    def input_for(field_name, options = {})
      indentation = options[:indentation] || default_indentation
      options = options.except :indentation

      options[:identifier] ||= :default

      # if block_given?
      #   args[:encapsulated_block] = encapsulate_block_in_view_context(&block)
      # end

      unless @resource.fields[field_name]
        puts "ERROR: can't find field #{field_name}"
        return ''
      end

      input = @resource.fields[field_name].input(options[:identifier])

      if input
        html = input.render
      else
        html = ''
        puts "ERROR: Unable to find a suitable input for #{field_name} (@ #{options[:identifier]})"
      end

      indent_or_die html, indentation
    end

    def input_with_label_for(field_name, options = {})
      indentation = options[:indentation] || default_indentation
      options[:indentation] = 0

      inner_html = [label_for(field_name, options), input_for(field_name, options)].join "\n"
      indent_or_die inner_html, indentation
    end

    def label_text_for(field_name, options = {})
      options[:context] ||= :default

      label = @resource.fields[field_name].label(options[:context])
      if label
        label.rendered_text
      else
        puts "ERROR: Unable to find a suitable label for #{field_name} (@ #{options[:identifier]})"
        ''
      end
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
