class @DocumentValidityInput
  constructor: (wrapper_selector, @types_with_validity) ->
    @wrapper = $ wrapper_selector

    @outer_wrapper = @wrapper.parents '.field'
    @form = @wrapper.parents 'form'
    @kind_field = $ "#document_kind"

    @kind_field.change @update_validity_visibility
    @update_validity_visibility()

  update_validity_visibility: =>
    if @kind_field.val() in @types_with_validity
      @outer_wrapper.show()
    else
      @outer_wrapper.hide()
