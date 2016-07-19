@BrainDamage ?= {}

class BrainDamage.LabelFileFieldUiInitializer
  constructor: (wrapper_selector = '.label-file-field-wrapper') ->

  setup: ->

  install: ->
    $('.label-file-field-wrapper').each (i, wrapper) ->
      new BrainDamage.LabelFileField wrapper
