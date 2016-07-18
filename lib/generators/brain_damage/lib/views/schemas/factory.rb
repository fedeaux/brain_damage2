require_relative 'base'

module BrainDamage
  module ViewSchemas
    class Factory
      def self.create(name, resource)
        name = name.to_s
        require_relative name
        eval("BrainDamage::ViewSchemas::#{name.camelize}").new resource
      end
    end
  end
end
