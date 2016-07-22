<% if conditions? %>
- if <%= conditions %>
  = r '<%= plural_table_name %>/inline_edit', field: :<%= name %>, <%= singular_table_name %>: <%= singular_table_name %>
- else
<%= display.indent 1 %>
<% else %>
= r '<%= plural_table_name %>/inline_edit', field: :<%= name %>, <%= singular_table_name %>: <%= singular_table_name %>
<% end %>
