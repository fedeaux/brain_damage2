# GET <%= route_url %>/new
def new
  @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
end
