# GET <%= route_url %>
def index
  @<%= plural_table_name %> = <%= orm_class.all(class_name) %>
end
