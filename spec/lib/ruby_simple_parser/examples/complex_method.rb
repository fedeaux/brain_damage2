class Document
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
end
