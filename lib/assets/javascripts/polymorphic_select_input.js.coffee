@BrainDamage ?= {}

class @BrainDamage.PolymorphicSelectInput
  constructor: (wrapper_selector) ->
    @wrapper = $ wrapper_selector
    @form = @wrapper.parents 'form'

    @type_selector = $ '.polymorphic-select-type-selector', @wrapper
    @object_selectors_wrappers = $ '.polymorphic-select-object-selector-wrapper', @wrapper

    @toggle_object_selectors_visibility()
    @type_selector.change @toggle_object_selectors_visibility
    @form.submit @remove_unused_inputs

  toggle_object_selectors_visibility: =>
    @object_selectors_wrappers.hide()

    @object_selectors_wrappers.filter(@current_object_selector_selector()).show()

  current_object_selector_selector: ->
    if @type_selector.val() == ''
      ':first'
    else
      ".polymorphic-select-object-selector-#{@type_selector.val()}-wrapper"

  remove_unused_inputs: =>
    @object_selectors_wrappers.not(@current_object_selector_selector()).remove()
    true
