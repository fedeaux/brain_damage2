module BrainDamage
  module ViewSchemas
    class SinglePageManager < Base
      def initialize(resource)
        super
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
