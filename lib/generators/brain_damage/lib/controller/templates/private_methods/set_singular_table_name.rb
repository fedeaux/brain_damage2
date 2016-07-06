def set_<%= singular_table_name %>
  @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
end
