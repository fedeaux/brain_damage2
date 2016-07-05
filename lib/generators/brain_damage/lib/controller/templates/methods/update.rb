# PATCH/PUT <%= route_url %>/1
def update
  @<%= orm_instance.name %>.assign_attributes <%= singular_table_name %>_params
<%= template_hook('before controller/update/save').indent 1 %>
  @<%= orm_instance.save %>

  respond_to do |format|
    format.json {
      partial = params[:partial_to_show] ? params[:partial_to_show] : 'table.item'
      render :json => { :html => render_to_string( partial: partial, formats: [:html], locals: get_partial_locals ),
                        :errors => @<%= singular_table_name %>.errors }
    }

    format.html {
      if @<%= singular_table_name %>.errors.empty?
        redirect_to @<%= singular_table_name %>, notice: t('common.updated').capitalize
      else
        if params[:request_source]
          render params[:request_source]
        else
          render :edit
        end
      end
    }
  end
end
