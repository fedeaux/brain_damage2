module BrainDamage
  class FieldWhiteList
    def initialize(field, white_list)
      @field = field
      @white_list = white_list
    end

    def list
      if @white_list
        return ":#{@white_list.keys.first} => #{@white_list.values.first.inspect}" if @white_list.is_a? Hash
        return @white_list.map{ |item| ":#{item}" } if @white_list.is_a? Array
        return nil if @white_list == ''
        return ":#{@white_list.to_s}"
      end

      return @field.relation.white_list if @field.relation

      return ":#{@field.name}"
    end
  end
end
