@BrainDamage ?= {}

class @BrainDamage.AjaxForm
  constructor: (wrapper_selector, @args = {}) ->
    @wrapper = $ wrapper_selector

    @form = $ 'form', @wrapper

    @strategy = @args.strategy or 'prepend'
    @callbacks = @args.callbacks or {}

    if @args.target
      @target = @args.target

    else if @args.target_selector
      @target = $ @args.target_selector

    else
      @target = @wrapper

    @wrapper.on 'ajax:before', @block_wrapper
    @wrapper.on 'ajax:complete', @ajax_complete

    @wrapper.addClass 'dimmable'
    @dimmer = $ '<div class="ui dimmer">
                   <div class="ui loader"></div>
                 </div>'

    @form.append @dimmer

  ajax_complete: (event, data) =>
    @unblock_wrapper()

    unless @display_errors data
      @add_to_target event, data
      @clear_form()
      @callbacks.success() if @callbacks.success

  display_errors: (data) ->
    has_errors = false

    if data and data.responseJSON and data.responseJSON.errors
      for field, errors of data.responseJSON.errors
        if errors.length > 0
          has_errors = true
          @form[0].ClientSideValidations.addError $("[name $= '\[#{field}\]']", @form), errors

      has_errors

  clear_form: =>
    @form.resetClientSideValidations()
    @form[0].reset()

  block_wrapper: =>
    @dimmer.dimmer 'show'

  unblock_wrapper: =>
    @dimmer.dimmer 'hide'

  add_to_target: (event, data) =>
    try
      item = $ data.responseJSON.html

    catch
      return

    item.hide()

    if @strategy == 'prepend'
      @target.prepend item

    else if @strategy == 'before similar'
      $(".#{item.attr('class')}").first().before item

    else if @strategy == 'append'
      @target.append item

    else if @strategy == 'before wrapper'
      @wrapper.before item

    else if @strategy == 'after'
      @target.after item

    else if @strategy == 'replace'
      @target.html item.html()

    item.fadeIn()
    @callbacks.complete(item) if @callbacks.complete

  # add_callback: (name, f) ->
  #   @callbacks[name] = f

  prepend_to_list: (item) ->
    # target is interpreted as a list
