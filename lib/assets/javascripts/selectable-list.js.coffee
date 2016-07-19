@BrainDamage ?= {}

class @BrainDamage.SelectableList
  constructor: (list_selector, wrapper_selector, @selected_class, @action) ->
    @list = $ list_selector
    @wrapper = $ wrapper_selector

    @list.on 'mouseenter', '.selectable-list-item', @mouse_over_item
    @list.on 'mousedown', '.selectable-list-item', @prevent_outside_focus_loss
    @list.on 'click', '.selectable-list-item', @take_action

    @list_scrollable_container = @list.parent()

    @wrapper.on 'keyup', @keyup
    @wrapper.on 'keydown', @prevent_form_submission

  prevent_outside_focus_loss: (e) ->
    e.preventDefault()

  html: (itens) ->
    @list.html itens
    @select $ '.selectable-list-item:first', @results_list

  select: (item) ->
    @selected_item.removeClass 'autocomplete-result-item-selected' if @selected_item

    if item.length > 0
      item.addClass 'autocomplete-result-item-selected'
      @selected_item = item
    else
      @selected_item = false

    @scroll_to_selected_item()

  scroll_to_selected_item: ->
    if @selected_item
      item_top = @selected_item.position().top
      item_height = @selected_item.outerHeight true
      wrapper_scroll = @list_scrollable_container.scrollTop()
      wrapper_height = @list_scrollable_container.height()
      position_difference = 0

      if item_top < wrapper_scroll
        position_difference = item_top - wrapper_scroll

      else if (item_top + item_height) > (wrapper_scroll + wrapper_height)
        position_difference = (item_top + item_height) - (wrapper_scroll + wrapper_height)

      @list_scrollable_container.scrollTop @list_scrollable_container.scrollTop() + position_difference if position_difference != 0

  mouse_over_item: (e) =>
    @select $ e.target

  take_action: =>
    @action @selected_item if @action and @selected_item

  keyup: (e) =>
    if e.which == 38
      @select_above()

    else if e.which == 40 #bottom
      @select_below()

    else if e.which == 13 #enter
      @take_action()
      return false

  prevent_form_submission: (e) =>
    if e.which == 13 #enter
      e.preventDefault()
      e.stopPropagation()
      return false

  select_above: =>
    if @selected_item
      prev = @selected_item.prevAll('.selectable-list-item:visible').first()

      if prev.length > 0
        @select prev
        return

    @select $ '.selectable-list-item:last', @results_list

  select_below: =>
    if @selected_item
      next = @selected_item.nextAll('.selectable-list-item:visible').first()

      if next.length > 0
        @select next
        return

    @select $ '.selectable-list-item:first', @results_list
