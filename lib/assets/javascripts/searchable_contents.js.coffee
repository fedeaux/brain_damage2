@BrainDamage = @BrainDamage or {}

class BrainDamage.SearchableContent
  constructor: (wrapper_selector, @item_selector = '.searchable-item', @args = {}) ->
    @wrapper = $ wrapper_selector
    @input_wrapper = $ '.searchable-input-wrapper', @wrapper

    @input = $ '.searchable-input', @input_wrapper
    @input.on 'keyup', _.throttle @filter, 200, leading: false

    @input_wrapper.on 'click', '.icon', =>
      @input.val('').keyup()

    @query = false
    @update_items()
    @state()

  state: ->
    if @query
      $('.close', @input_wrapper).show()
      $('.search', @input_wrapper).hide()

    else
      $('.close', @input_wrapper).hide()
      $('.search', @input_wrapper).show()

  update_items: ->
    @items = []

    $(@item_selector, @wrapper).each (index, _item) =>
      item = $ _item

      @items.push
        match_text: item.attr 'data-searchable-text'
        item: item

  filter: =>
    if @input.val() != ''
      @query = new RegExp(@input.val(), 'i')
    else
      @query = false

    @state()
    @filter_items()

  filter_items: ->
    for item in @items
      if @query and !item.match_text.match @query
        item.item.hide()
      else
        item.item.show()

  evalCandidate: (item) =>
    matcheable_item = $ '> .hierarchy-view-item-name .hierarchy-search-matcheable-string', item

    if @query and matcheable_item.text().match @query
      Hierarchy.View.showHierarchyToItem item
      matcheable_item.addClass 'hierarchy-search-match'

    else if matcheable_item.is '.hierarchy-search-match'
      Hierarchy.View.closeHierarchyToItem item
      matcheable_item.removeClass 'hierarchy-search-match'
