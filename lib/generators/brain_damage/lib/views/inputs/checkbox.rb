require 'erb'
require_relative 'base'

module BrainDamage
  module View
    module Input
      class Checkbox < Base
        def show_label?
          false
        end
      end
    end
  end
end
