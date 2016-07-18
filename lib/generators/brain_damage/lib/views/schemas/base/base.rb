# coding: utf-8
require_relative '../../../templateable/base'

module BrainDamage
  module View
    module Base
      class Base < Templateable::Base
        attr_reader :file_name

        def initialize(resource, options = {})
          set_file_and_template_names(options)
          super resource, options
        end

        def set_file_and_template_names(options)
          @file_name = (options[:file_name] || "#{self.class.name.split('::').last.underscore}.html.haml") unless @file_name
          @template_file = (options[:template_name] || "#{self.class.name.split('::').last.underscore}.html.haml") unless @template_file
        end

        def fields
          @resource.fields
        end

        def self.has_template?(name)
          File.exists? File.join(dir, 'templates', "#{name}.html.haml")
        end

        private
        def self.dir
          __dir__
        end

        def dir
          __dir__
        end
      end
    end
  end
end
