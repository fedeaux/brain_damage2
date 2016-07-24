@BrainDamage ?= {}

class @BrainDamage.UIInitializer
  constructor: (@initializers = []) ->
    @setup()
    @install()

  setup: (context = 'body') ->
    window.showLoading = ->
      $('#page-dimmer').addClass 'active'

    window.hideLoading = ->
      $('#page-dimmer').removeClass 'active'

    initializer.setup(context) for initializer in @initializers

  install: (context = 'body') =>
    $('select', context).dropdown()

    $('.dropdown', context).dropdown
      on: 'hover'

    initializer.install(context) for initializer in @initializers
