# coding: utf-8
require_relative '../../../templateable/view_templateable'

module BrainDamage
  module View
    module Base
      class Base < Templateable::ViewTemplateable
        attr_reader :file_name

        def initialize(resource, options = {})
          set_file_and_template_names(options)
          super resource, options
        end

        def set_file_and_template_names(options)
          @file_name = (options[:file_name] || infer_file_name)
          @template_file = (options[:template_name] || infer_file_name) unless @template_file

          unless self.class.has_template? @template_file
            partial_version = partialize_file_name @template_file
            if self.class.has_template? partial_version
              @template_file = partial_version
            end

            @file_name = partialize_file_name @file_name
          end
        end

        def partialize_file_name(file_name)
          parts = file_name.split '/'

          if parts.length == 1
            "_#{parts.first.gsub('^_', '')}"
          else
            (parts[0...-1] + ["_#{parts.last.gsub('^_', '')}"]).join '/'
          end
        end

        def fields(only: nil, except: nil)
          @resource.fields.values
        end

        def infer_file_name
          "#{self.class.name.split('::')[3..-1].map(&:underscore).join('/')}.html.haml"
        end

        def self.has_template?(name)
          file_name = File.join(dir, 'templates', "#{name.to_s.gsub('.html.haml', '')}.html.haml")
          File.exists? file_name
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
