@BrainDamage ?= {}

class @BrainDamage.AutocompleteSimpleSelect
  constructor: (wrapper_selector, url, value, @partial_to_show) ->
    @wrapper = $ wrapper_selector
    @autocomplete_input = new BrainDamage.AutocompleteInput @wrapper, url, @set_item, @partial_to_show

    @value_input = $ '.autocomplete-value', @wrapper

    @display = $ '.autocomplete-display', @wrapper

    @display_text = $ '.autocomplete-display-text', @display
    @edit_button = $ '.autocomplete-edit', @display

    @display.click @edit

    if value
      @set value.display, value.value

  set_item: (item) =>
    @set item.text(), item.attr 'data-value'
    @autocomplete_input.hide()

  set: (display, value) ->
    if display != '' and value != ''
      @autocomplete_input.query_input_wrapper.hide()
      @display.show()
      @display_text.text display
      @value_input.val value

  edit: =>
    if @value_input.val()
      text = @display_text.text()
    else
      text = ''

    @autocomplete_input.query_input_wrapper.show()
    @autocomplete_input.query_input.text ''
    @display.hide()
