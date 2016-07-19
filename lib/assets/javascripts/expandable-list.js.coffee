@BrainDamage ?= {}

class @BrainDamage.ExpandableList
  constructor: (wrapper_selector) ->
    @wrapper = $ wrapper_selector
    @list = $ '.brain-damage-list', @wrapper
    @form = $ '[id^=new]', @wrapper

  #   $('.brain-damage-list-item-wrapper', @list).each @iterateInstall
  #   new BrainDamage.AjaxForm @form, $('thead', @list), 'after', complete: @installListItem

  # iterateInstall: (i, _item_wrapper) =>
  #   @installListItem _item_wrapper

  # installListItem: (item_wrapper) =>
  #   new BrainDamage.ListItem item_wrapper
