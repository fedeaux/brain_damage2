@BrainDamage ?= {}

class @BrainDamage.ListItem
  constructor: (item_wrapper_selector) ->
    new BrainDamage.InlineEdit item_wrapper_selector,
      display_selector: '.brain-damage-list-item'
      edition_selector: '.brain-damage-edit-list-item'
      partial_to_show: 'table.item'

      cancel_button_selector: '.brain-damage-cancel'
      edit_button_selector: '.brain-damage-edit'
