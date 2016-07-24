@BrainDamage ?= {}

class BrainDamage.LabelFileField
  constructor: (wrapper_selector = '.label-file-field-wrapper') ->
    @wrapper = $ wrapper_selector

    @input = $ 'input', @wrapper
    @label = $ 'label', @wrapper
    @label_text = $ ".text", @label
    @original_label = @label_text.text()

    @input.change @update_label
    @update_label()

  update_label: =>
    if @input.val() == ''
      @label_text.text @original_label
      @label.removeClass('green').addClass 'basic'

    else
      @label_text.text @input.val()
      @label.addClass('green').removeClass 'basic'
