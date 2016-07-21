require_relative 'base'

module BrainDamage
  module Templateable
    class ViewTemplateable < Templateable::Base
      OVERWRITEABLE_HEADER = '-# BrainDamage::Overwriteable'

      def self.skip_overwrite? file_name
        ! overwrite? file_name
      end

      def self.overwrite?(file_name)
        !File.exists?(file_name) or File.readlines(file_name).first.strip == OVERWRITEABLE_HEADER
      end

      def render
        OVERWRITEABLE_HEADER + "\n" + super
      end
    end
  end
end
