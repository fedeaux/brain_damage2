# coding: utf-8
class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  validates :kind, presence: true
  validates :owner, presence: true

  belongs_to :owner, polymorphic: true
  belongs_to :created_by, class_name: 'User'

  BILL_OF_SALE = 'BillOfSaleDocument'
  BILL_OF_SERVICE = 'BillOfServiceDocument'
  CLIENT_PO = 'ClientPODocument'
  EXPORTER_PO = 'ExporterPODocument'
  IMPORT_DECLARATION = 'ImportDeclarationDocument'
  INSTRUTEC_PO = 'InstrutecPODocument'
  OTHER = 'OtherDocument'
  PROFORM = 'ProformDocument'
  PROPOSAL = 'ProposalDocument'
  SERVICE_ORDER = 'ServiceOrderDocument'
  SALES_ORDER = 'SalesOrderDocument'
  SHIPMENT = 'ShipmentDocument'

  KIND_NAMES = {
    Document::BILL_OF_SALE => 'Nota Fiscal',
    Document::BILL_OF_SERVICE => 'Nota Fiscal do Serviço',
    Document::CLIENT_PO => 'PO Cliente',
    Document::EXPORTER_PO => 'PO Exportador',
    Document::IMPORT_DECLARATION => 'Declaração de Importação',
    Document::INSTRUTEC_PO => 'PO Instrutec',
    Document::OTHER => 'Outro',
    Document::PROFORM => 'Proforma',
    Document::PROPOSAL => 'Proposta',
    Document::SALES_ORDER => 'Sales Order',
    Document::SERVICE_ORDER => 'Ordem de Serviço',
    Document::SHIPMENT => 'Documentação de Embarque'
  }

  belongs_to :lead, foreign_key: :owner_id

  mount_uploader :archive, ArchiveUploader

  default_scope -> { order('created_at DESC') }

  scope :by_kind, -> (kind) {
    where(:kind => kind)
  }

  scope :expires_in, -> (date) {
    joins(:lead).where('leads.level < 3 AND documents.validity = ?', date)
  }

  scope :expires_today, -> {
    expires_in Date.today
  }

  scope :expires_in_20_days, -> {
    expires_in Date.today - 20.days
  }

  scope :expirable, -> {
    joins(:lead).where('leads.level < 3 AND documents.validity IS NOT NULL')
  }

  before_save :zip_file

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
    end # end respond_to
  end # end def create

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
