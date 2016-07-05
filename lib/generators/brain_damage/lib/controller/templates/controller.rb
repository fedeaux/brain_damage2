<% cg = @resource.controller %>

class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: <%= cg.set_member_before_action_list.inspect %>

  <%= cg.public_methods %>

  private
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def <%= "#{singular_table_name}_params" %>
      params.require(:<%= singular_table_name %>).permit(<%= cg.attribute_white_list %>)
    end

    def get_partial_locals
      params['partial_locals'] || {}
    end
end
