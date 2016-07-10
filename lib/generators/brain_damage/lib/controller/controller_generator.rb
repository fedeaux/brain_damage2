require_relative '../templateable/class_templateable'

module BrainDamage
  class ControllerGenerator < Templateable::ClassTemplateable
    attr_accessor :set_member_before_action_list

    def initialize(resource, options = {})
      @template_file = 'controller.rb'
      @set_member_before_action_list = [:show, :edit, :update, :destroy]
      super
    end

    def generate
      add_before_filters
      render
    end

    def add_before_filters
      @parser.leading_class_method_calls << RubySimpleParser::CodeLine.new(render_erb_string('before_action :set_<%= singular_table_name %>, only: <%= set_member_before_action_list.inspect %>').indent)
    end

    def attribute_white_list
      @resource.fields.values.map(&:attr_white_list).reject(&:nil?).sort { |field_a, field_b|
        is_hash_a = (field_a.index '=>') || 0
        is_hash_b = (field_b.index '=>') || 0

        if is_hash_a == is_hash_b
          field_a <=> field_b
        else
          is_hash_a <=> is_hash_b
        end

      }.join(', ')
    end

    private
    def dir
      __dir__
    end
  end
end
