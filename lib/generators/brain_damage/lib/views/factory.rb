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

        require_relative "#{type.pluralize}/#{subtype}"
        eval("#{type.camelize.singularize}::#{subtype.camelize}").new field, options
      end
    end
  end
end
