module BrainDamage
  module ViewSchemas
    class SinglePageManager < Base
      def initialize(resource)
        super
        @views_names += ['index', '_list', '_item'] # , '_list.header', '_item', '_item.display', '_item.form']
      end
    end
  end
end
