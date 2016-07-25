# coding: utf-8

module BrainDamage
  module View
    class Factory
      def self.create(type, field, options = {})
        if options.is_a? Symbol
          subtype = options
          options = { type: options }
        else
          subtype = options[:type]
        end

        type = type.to_s
        subtype = subtype.to_s

        if File.exists?  __dir__+"/#{type.pluralize}/#{subtype}.rb"
          require_relative "#{type.pluralize}/#{subtype}"
          eval("#{type.camelize.singularize}::#{subtype.camelize}").new field, options

        else
          require_relative "#{type.pluralize}/base"
          options[:template_file] = "#{subtype.underscore}.html.haml"
          eval("#{type.camelize.singularize}::Base").new field, options
        end
      end
    end
  end
end
