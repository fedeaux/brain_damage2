@BrainDamage ?= {}

class @BrainDamage.PolymorphicHibridInput
  constructor: (wrapper_selector, url, @action, @partial_to_show) ->
    @wrapper = $ wrapper_selector
    @form = @wrapper.parents 'form'
    @inputs_items = $ '.polymorphic-hybrid-input-tabbed-menu .item', @wrapper

    @inputs_items.tab()
    @form.submit @remove_unused_inputs

  remove_unused_inputs: =>
    $('.tab.segment:not(.active)', @wrapper).remove()
    true
