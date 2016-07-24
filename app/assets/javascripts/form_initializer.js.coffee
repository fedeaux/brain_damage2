@BrainDamage ?= {}

class @BrainDamage.UIInitializer
  constructor: ->
    add_function
    @initialize()

  initialize: (context = 'body') =>
