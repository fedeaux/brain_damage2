<% if namespaced? -%>
require_dependency "<%= namespaced_file_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: <%= @resource.controller_manager.set_member_before_action_list.inspect %>
<% @resource.controller_manager.plugins_lines.each do |line| -%>
  <%= line %>
<% end -%>

<% %w[index show new edit create update destroy].each do |method_name| -%>
<%= @resource.controller_method(method_name).indent 1 %>

<% end %>

<%= @resource.controller_custom_code -%>

  private
<%= @resource.controller_manager.plugins_private_methods -%>

    # Use callbacks to share common setup or constraints between actions.
    def set_<%= singular_table_name %>
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      <%- if attributes_names.empty? -%>
      params[:<%= singular_table_name %>]
      <%- else -%>
      params.require(:<%= singular_table_name %>).permit(<%= attribute_white_list %>)
      <%- end -%>
    end

    def get_partial_locals
      params['partial_locals'] || {}
    end
end
<% end -%>
