# coding: utf-8
require 'pathname'
require_relative '../../../templateable/view_templateable'

module BrainDamage
  module View
    module Base
      class Base < Templateable::ViewTemplateable
        attr_reader :file_name

        def initialize(resource, options = {})
          set_file_and_template_names(options)
          @schema = options[:schema]
          super resource, options
        end

        def set_file_and_template_names(options)
          @file_name ||= options[:file_name]
          @template_file ||= options[:template_name]

          unless @template_file
            @template_file = infer_file_name

            unless self.class.has_template? @template_file or Pathname.new(@template_file).absolute?
              partial_version = partialize_file_name @template_file
              if self.class.has_template? partial_version
                @template_file = partial_version
              end
            end
          end

          unless @file_name
            @file_name = infer_file_name

            if is_partial_file_name? @template_file
              @file_name = partialize_file_name @file_name
            end
          end
        end

        def is_partial_file_name?(file_name)
          file_name.split('/').last[0] == '_'
        end

        def partialize_file_name(file_name)
          parts = file_name.split '/'

          if parts.length == 1
            "_#{parts.first.gsub('^_*', '')}"
          else
            (parts[0...-1] + ["_#{parts.last.gsub('^_', '')}"]).join '/'
          end
        end

        def fields(only: nil, except: nil)
          @resource.fields
        end

        def infer_file_name
          "#{self.class.name.split('::')[3..-1].map(&:underscore).join('/')}.html.haml"
        end

        def self.has_template?(name)
          File.exists? File.join(dir, 'templates', "#{name.to_s.gsub('.html.haml', '')}.html.haml")
        end

        def method_missing(method, *args, &block)
          if @schema and @schema.respond_to? method
            @schema.send method, *args, &block
          else
            super
          end
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
