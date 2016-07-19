@BrainDamage ?= {}

class @BrainDamage.NestedFormControls
  @configuration = {
    after_add_line: []
  }

  constructor: (wrapper_selector, @config = {}) ->
    _.defaults @config, {
      context: 'new',
      prototype_selector: '.brain-damage-nested-form-prototype'
      add_button_selector: '.brain-damage-nested-form-add-button'
      remove_button_selector: '.brain-damage-nested-form-remove-button'
      line_selector: '.brain-damage-nested-form-line'
    }

    @wrapper = $ wrapper_selector
    @submit = $ ':submit', @wrapper

    @prototype = $ @config.prototype_selector, @wrapper
    @add_button = $ @config.add_button_selector, @wrapper
    @container = @prototype.parent()

    @init()
    @check_submit_visibility()
    @add_button.on 'click', @add_line
    @container.on 'click', @config.remove_button_selector, @remove_this_line

  check_submit_visibility: =>
    if @number_of_lines() > 0
      @submit.parent().append(@submit)
      @submit.fadeIn()

    else
      @submit.hide()

  number_of_lines: ->
    $(@config.prototype_selector, @wrapper).length

  prepare_prototype_html: ->
    replacements = []

    $('[name]', @prototype).each (i, _input) =>
      input = $ _input
      name = input.attr('name')
      input.attr 'name', name.replace('[0]', "[#{@placeholder}]")

    @prototype_html = @prototype.get(0).outerHTML
    @prototype.remove()

    @add_line() if @config.context == 'new'

  add_line: =>
    @i = (new Date).getTime()

    line = $ @prototype_html.replace(@placeholder_regexp, @i)
    line.hide()
    @container.append line
    line.fadeIn()

    @check_submit_visibility()

    if BrainDamage.NestedFormControls.configuration.after_add_line?
      for f in BrainDamage.NestedFormControls.configuration.after_add_line
        f line

  remove_this_line: (e) =>
    line = $(e.target).parents @config.line_selector

    line.fadeOut =>
      line.remove()
      @check_submit_visibility()

  add_ajax_delete_to_edit_lines: ->
    $('.brain-damage-nested-form-edit-line', @wrapper).each (i, _e) =>
      new BrainDamage.AjaxDelete _e

  init: ->
    @placeholder = @config.name+'-index'
    @placeholder_regexp = new RegExp(@placeholder, 'g')

    @i = 0
    @prepare_prototype_html()
    @add_ajax_delete_to_edit_lines()
