require "brain_damage/version"

module BrainDamage
  if defined?(Rails)
    require 'rails'
    class Engine < Rails::Engine
    end
  end
end
