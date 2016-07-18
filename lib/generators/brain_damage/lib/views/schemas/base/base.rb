require_relative '../../../templateable/base'

module BrainDamage
  module View
    module Base
      class Base < Templateable::Base
        attr_reader :file_name

        def initialize(resource, options = {})
          @file_name = "#{self.class.name.split('::').last.underscore}.html.haml" unless @file_name
          @template_file = "#{self.class.name.split('::').last.underscore}.html.haml" unless @template_file
          super resource, options
        end

        private
        def dir
          __dir__
        end
      end
    end
  end
end
