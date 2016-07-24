@BrainDamage ?= {}

class @BrainDamage.SinglePageManager
  constructor: (wrapper_selector) ->
    @wrapper = $ wrapper_selector

    if @wrapper.is '.brain-damage-list'
      @list = @wrapper

    else
      @list = $ '.brain-damage-list', @wrapper

    @forms_wrappers = $ '.brain-damage-add-form-wrapper', @wrapper

    $('.brain-damage-list-item-wrapper', @list).each @iterate_install

    @forms_wrappers.each (i, _form_wrapper) =>
      form_wrapper = $ _form_wrapper
      form = $ 'form', form_wrapper

      callbacks = BrainDamage.SinglePageManager.registered_ajax_forms_callbacks form
      callbacks.complete = @install_list_item

      if 'leading_form' == form.attr 'data-single-page-manager-form-context'
        options =
          target: form.parents 'tbody'
          strategy: 'after'
          callbacks: callbacks

      else
        options =
          target: $ '.brain-damage-list-header', @list
          strategy: 'after'
          callbacks: callbacks

      BrainDamage.SinglePageManager.register_form form, new BrainDamage.AjaxForm(form_wrapper, options)

  iterate_install: (i, _item_wrapper) =>
    @install_list_item _item_wrapper

  install_list_item: (item_wrapper) =>
    new BrainDamage.ListItem item_wrapper

  @register_form: (form, ajax_form) ->
    BrainDamage.SinglePageManager.forms ?= {}
    BrainDamage.SinglePageManager.forms[form.attr('id')] = ajax_form

  @ajax_form_for: (form) ->
    BrainDamage.SinglePageManager.forms[form.attr('id')]

  @register_ajax_form_callback: (form, name, f) ->
    BrainDamage.SinglePageManager.ajax_forms_callbacks ?= {}
    BrainDamage.SinglePageManager.ajax_forms_callbacks[form.attr 'id'] ?= {}
    BrainDamage.SinglePageManager.ajax_forms_callbacks[form.attr 'id'][name] = f

  @registered_ajax_forms_callbacks: (form) ->
    return {} unless BrainDamage.SinglePageManager.ajax_forms_callbacks and
      BrainDamage.SinglePageManager.ajax_forms_callbacks[form.attr 'id']

    $.extend {}, BrainDamage.SinglePageManager.ajax_forms_callbacks[form.attr 'id']
