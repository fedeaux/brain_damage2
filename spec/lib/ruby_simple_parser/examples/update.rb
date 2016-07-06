  def update
    @contact.assign_attributes contact_params

    @contact.save

    respond_to do |format|
      format.json {
        partial = params[:partial_to_show] ? params[:partial_to_show] : 'table.item'
        render json: { html: render_to_string( partial: partial, formats: [:html], locals: get_partial_locals ),
                          errors: @contact.errors }
      }

      format.html {
        if @contact.errors.empty?
          redirect_to @contact, notice: t('common.updated').capitalize
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
