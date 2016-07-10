def create
  @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>
<%= template_hook('after controller/create/save').indent 1 %>
  @<%= orm_instance.save %>

  respond_to do |format|
    format.json {
      partial = params[:partial_to_show] ? params[:partial_to_show] : 'table.item'
      render json: { html: render_to_string(partial: partial, formats: [:html], locals: get_partial_locals ),
                     errors: @<%= singular_table_name %>.errors }
    }

    format.html {
      if @<%= singular_table_name %>.errors.empty?
        redirect_to @<%= singular_table_name %>, notice: t('common.created').capitalize
      else
        render :new
      end
    }
  end
end
