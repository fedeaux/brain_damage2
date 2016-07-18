require_relative 'base'

module BrainDamage
  module ViewSchemas
    class Factory
      def self.create(name)
        name = name.to_s
        require_relative name
        eval("BrainDamage::ViewSchemas::#{name.camelize}").new
      end
    end
  end
end
