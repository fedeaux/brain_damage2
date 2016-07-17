# coding: utf-8
class Document < ActiveRecord::Base
  BILL_OF_SALE = 'BillOfSaleDocument'
  BILL_OF_SERVICE = 'BillOfServiceDocument'
  CLIENT_PO = 'ClientPODocument'
  EXPORTER_PO = 'ExporterPODocument'
  IMPORT_DECLARATION = 'ImportDeclarationDocument'
  INSTRUTEC_PO = 'InstrutecPODocument'
  OTHER = 'OtherDocument'
  PROFORM = 'ProformDocument'
  PROPOSAL = 'ProposalDocument'
  SALES_ORDER = 'SalesOrderDocument'
  SERVICE_ORDER = 'ServiceOrderDocument'
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

  default_scope -> { order('created_at DESC') }

  scope :by_kind, -> (kind) {
    where(:kind => kind)
  }

  scope :expirable, -> {
    joins(:lead).where('leads.level < 3 AND documents.validity IS NOT NULL')
  }

  scope :expires_in, -> (date) {
    joins(:lead).where('leads.level < 3 AND documents.validity = ?', date)
  }

  scope :expires_in_20_days, -> {
    expires_in Date.today - 20.days
  }

  scope :expires_today, -> {
    expires_in Date.today
  }

  validates :kind, {:presence => true}
  validates :owner, {:presence => true}

  belongs_to :created_by, class_name: 'User'
  belongs_to :lead, foreign_key: :owner_id
  belongs_to :owner, polymorphic: true

  before_save :zip_file
  mount_uploader :archive, ArchiveUploader

  def self.options_for_kind
    KIND_NAMES.keys.map { |kind|
      [ Document.kind_name(kind), kind ]
    }.sort { |kind_a, kind_b|
      kind_a <=> kind_b
    }
  end

  def self.options_for_visibility
    [[ 'Histórico', :lead ], [ 'Financeiro', :financial ]]
  end

  def visibility_name
    Document.options_for_visibility.to_h.invert[visibility]
  end

  def self.first_of_kind_as_array(kind)
    docs = by_kind kind

    if docs.length > 0
      return [docs.first]
    end

    []
  end

  def number_of_the_same_kind_within_its_owner
    owner.documents.by_kind(kind).length
  end

  def zip_file
    if has_file? and ! is_zip_file?
      new_path = File.dirname(archive.current_path)+"/#{archive.filename}"
      system("zip -j -P #{ENV['FILE_PASSWORD']} '#{new_path}' '#{archive.current_path}'")
      self.archive = Rails.root.join(new_path).open
    end
  end

  def self.kind_name(kind)
    Document::KIND_NAMES[kind]
  end

  def kind_name
    Document.kind_name(kind)
  end

  def signature
    "#{kind_name}: #{name}"
  end

  def has_file?
    archive and archive.current_path
  end

  def is_zip_file?
    archive.current_path =~ /.zip$/
  end

  def has_validity?
    Document.has_validity? kind
  end

  def self.has_validity?(kind)
    with_validity.include? kind
  end

  def self.with_validity
    ['ProformDocument', 'ProposalDocument']
  end

  def self.legacy_tables_names
    {
      Document::CLIENT_PO => 'fileinfo_po_po_cliente',
      Document::BILL_OF_SALE => 'fileinfo_po_nota_fiscal',
      Document::BILL_OF_SERVICE => 'fileinfo_po_nota_fiscal_serv',
      Document::EXPORTER_PO => 'fileinfo_po_po_no_exportador',
      Document::IMPORT_DECLARATION => 'fileinfo_po_declaracao_de_importacao',
      Document::INSTRUTEC_PO => 'fileinfo_po_po_instrutecnica',
      Document::OTHER => 'fileinfo_generic',
      Document::PROFORM => 'fileinfo_po_proforma',
      Document::PROPOSAL => 'fileinfo_po_proposta',
      Document::SALES_ORDER => 'fileinfo_po_sales_order',
      Document::SERVICE_ORDER => 'fileinfo_po_ordem_de_servico',
      Document::SHIPMENT => 'fileinfo_po_documentacao_de_embarque'
    }
  end

  def self.from_upload(attributes)
    owner = Lead.find_by(id: attributes['owner_id'])

    if owner
      begin
        Document.new(
          owner: owner,
          created_by_id: attributes['created_by_id'],
          description: attributes['description'],
          name: attributes['name'],
          kind: attributes['kind']
        ) do |doc|

          doc.validity = attributes['validade'] if attributes['validade']
          doc.archive = attributes[:archive] unless attributes[:archive].blank?

          doc.save
        end
      rescue
        puts "ERROR: #{folder}/#{attributes['purchase_order']}/[#{attributes['filename']}]"
      end
    end
  end

  def file_name
    [name.nil? ? '' : name.parameterize, owner.file_name_for(self), "#{created_at.strftime('%Y%m%d')}.zip"].join('_')
  end

  def self.users_emails_related_to_owners(documents)
    documents.map{ |document| document.owner.users }.flatten.map(&:email).uniq
  end

  def child_of?(local_or_local_id)
    local = if local_or_local_id.is_a? Local
              local_or_local_id
            else
              Local.find local_or_local_id
            end

    ancestry.split('/').map(&:to_i).include? local_or_local_id
  end
end
