def <%= "#{singular_table_name}_params" %>
  params.require(:<%= singular_table_name %>).permit(<%= attribute_white_list %>)
end
