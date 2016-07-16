class ContactsController < ApplicationController
  def create
    @contact = Contact.new(contact_params)

    @contact.save

    respond_to do |format|
      format.json {
        partial = params[:partial_to_show] ? params[:partial_to_show] : 'table.item'
        render json: { html: render_to_string(partial: partial, formats: [:html], locals: get_partial_locals ),
                       errors: @contact.errors }
      }

      format.html {
        if @contact.errors.empty?
          notice = t('common.created').capitalize

          if params[:new]
            redirect_to new_contact_path, notice: notice

          elsif params[:new_same_local]
            redirect_to new_contact_path(local_id: @contact.local_id), notice: notice

          else
            redirect_to @contact, notice: notice
          end
        else
          redirect_to new_contact_path
        end
      }
    end # end respond_to
  end # end def create

  def destroy
    @contact.destroy

    respond_to do |format|
      format.json {
        render nothing: true, status: 200
      }

      format.html {
        redirect_to contacts_url, notice: t('common.destroyed').capitalize
      }
    end
  end
end
