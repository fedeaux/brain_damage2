@BrainDamage ?= {}

class @BrainDamage.InlineEdit
  constructor: (wrapper_selector, @options = {}) ->

    @options = $.extend {
      cancel_button_selector: '.brain-damage-inline-edit-cancel'
      edit_button_selector: '.brain-damage-inline-edit-edit'

      display_selector: '.brain-damage-inline-edit-display'
      edition_selector: '.brain-damage-inline-edit-form'
      edit_complete: null
      partial_to_show: null
    }, @options

    @wrapper = $ wrapper_selector

    @install()

  install: =>
    @display = $ @options.display_selector, @wrapper
    @edition = $ @options.edition_selector, @wrapper

    inner_inline_edit_form = $(".brain-damage-inline-edit form", @wrapper)
    inner_inline_edit_buttons = $(".brain-damage-inline-edit #{@options.edit_button_selector}", @wrapper)

    @form = $('form', @edition).not inner_inline_edit_form

    $(@options.edit_button_selector, @wrapper).not(inner_inline_edit_buttons).click @show_form
    $(@options.cancel_button_selector, @wrapper).click @hide_form

    new BrainDamage.AjaxDelete @wrapper
    new BrainDamage.AjaxForm @edition,
      target: @wrapper
      strategy: 'replace'
      callbacks:
        complete: @edit_complete

    if @options.partial_to_show
      @form.append "<input type='hidden' name='partial_to_show' value='#{@options.partial_to_show}' />"

    @form.enableClientSideValidations()

  show_form: =>
    @display.hide()
    @edition.fadeIn()

  hide_form: =>
    @edition.hide()
    @display.fadeIn()

  edit_complete: (item) =>
    if @options.edit_complete
      @options.edit_complete item

    else
      @install()
      @hide_form()
