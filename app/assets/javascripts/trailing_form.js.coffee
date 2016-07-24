@BrainDamage ?= {}

class @BrainDamage.TrailingForm
  constructor: (wrapper_selector, partial_to_show, hideable_args = {}) ->
    hideable_args.wrapper_selector = wrapper_selector unless hideable_args.wrapper_selector?

    @hideable_content = new BrainDamage.HideableContent hideable_args.wrapper_selector, hideable_args
    form = $ 'form', $ wrapper_selector

    BrainDamage.SinglePageManager.register_ajax_form_callback form, 'success', @hide_form

    if partial_to_show
      form.append "<input type='hidden' name='partial_to_show' value='#{partial_to_show}' />"

  hide_form: =>
    @hideable_content.hide()
