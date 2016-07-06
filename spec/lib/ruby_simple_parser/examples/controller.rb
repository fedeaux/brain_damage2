class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # POST /contacts
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
    end
  end

  # DELETE /contacts/1
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

  # GET /contacts/1/edit
  def edit
  end

  # GET /contacts
  def index
    @contacts = Contact.all
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1
  def show
  end

  # PATCH/PUT /contacts/1
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

  private
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def contact_params
      params.require(:contact).permit(:ac_info, :title, :name, :local, :contact_role, :observations)
    end

    def get_partial_locals
      params['partial_locals'] || {}
    end
end
