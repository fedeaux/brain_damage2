@BrainDamage ?= {}

class @BrainDamage.AutocompleteList
  constructor: (wrapper_selector, url, values = [], @partial_to_show) ->
    @wrapper = $ wrapper_selector
    @autocomplete_input = new BrainDamage.AutocompleteInput @wrapper, url, @add_item, @partial_to_show

    @itens_collection_wrapper = $ '.autocomplete-itens-collection-wrapper', @wrapper

    @wrapper.on 'click', '.autocomplete-list-remove', @remove_item

    @prepare_item_prototype()

    for value in values
      @add_item value.display, value.value

  prepare_item_prototype: ->
    item_prototype = $ '.autocomplete-display-prototype', @wrapper
    @item_prototype_html = item_prototype.get(0).outerHTML
    item_prototype.remove()

  add_item: (item_or_display, value = null) =>
    if value
      display = item_or_display
    else
      display = item_or_display.text()
      value = item_or_display.attr 'data-value'

    item_html = $ @item_prototype_html
    @itens_collection_wrapper.append item_html

    $('.autocomplete-display-text', item_html).text display
    $('.autocomplete-value', item_html).val value

    item_html.show()

  remove_item: (e) =>
    item = $(e.target).parents '.autocomplete-display-prototype'

    item.fadeOut
      complete: => item.remove()
