require "brain_damage/version"
require "brain_damage/brain_damage_helper"

module BrainDamage
  if defined?(Rails)
    require 'rails'
    class Engine < Rails::Engine
    end

    class Railtie < Rails::Railtie
      initializer "brain_damage.brain_damage_helper" do
        ActionView::Base.send :include, BrainDamageHelper
      end
    end
  end
end
