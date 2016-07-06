<%= class_definition %>
  <%= leading_class_method_calls -%>
  <%= public_methods -%>
  <% private_methods_code = private_methods %>
  <% if private_methods_code.present? %>
  private
    <%= private_methods %>
  <% end %>

end
