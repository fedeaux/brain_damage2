module BrainDamage
  module ViewSchemas
    class SinglePageManager < Base
      attr_accessor :list_layout

      def initialize(resource)
        super
        @list_layout = :list
        describe_view '_form', { remote: true }
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
