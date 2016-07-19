module BrainDamage
  module View
    module Base
      class Form < Base
        def initialize(resource, options = {})
          options = {
            multipart: false,
            remote: true
          }.merge options

          super resource, options
        end

        def multipart?
          @options[:multipart]
        end

        def remote?
          @options[:remote]
        end
      end
    end
  end
end
