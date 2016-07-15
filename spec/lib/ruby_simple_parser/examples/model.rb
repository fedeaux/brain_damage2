# coding: utf-8
class Document < ActiveRecord::Base
  validates :owner, {:presence => true}
  belongs_to :owner, polymorphic: true

  BILL_OF_SALE = 'BillOfSaleDocument'
  BILL_OF_SERVICE = 'BillOfServiceDocument'
  CLIENT_PO = 'ClientPODocument'

  KIND_NAMES = {
    Document::BILL_OF_SALE => 'Nota Fiscal',
    Document::BILL_OF_SERVICE => 'Nota Fiscal do Serviço',
    Document::CLIENT_PO => 'PO Cliente',
  }

  default_scope -> { order('created_at DESC') }

  scope :by_kind, -> (kind) {
    where(:kind => kind)
  }

  some_call_with_a_block do
    something
    anything
  end

  def self.options_for_visibility
    [[ 'Histórico', :lead ], [ 'Financeiro', :financial ]]
  end
end
