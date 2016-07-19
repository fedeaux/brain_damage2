@BrainDamage ?= {}

class @BrainDamage.SensibleToAjaxView
  constructor: (wrapper_selector) ->
    @wrapper = $ wrapper_selector
    @wrapper.on 'ajax:success', @replaceSensible

    @displaySelector = '.best_in_place, .sensible-to-ajax-display'

  $: (selector) ->
    $ selector, @wrapper

  replaceSensible: (response, responseText) =>
    # try
    @newHtmls = $ JSON.parse(responseText).html

    # find changes
    @changed = $()
    @removed = $()

    @$('.sensible-to-ajax').each @checkForReplacement

    @changed.show()
    @changed.transition
      animation: 'shake'
      duration: '1s'
      interval: 200

    @removed.fadeOut
      complete: (e) =>
        @removed.html ''

  checkForReplacement: (i, _e) =>
    withCurrentValue = $ _e
    fieldName = withCurrentValue.attr 'data-ajax-sensibility-field'

    cl = (fieldName == 'secondary_instrutec_paid_value')

    unless fieldName
      return true

    withNewValue = $ "[data-ajax-sensibility-field=#{fieldName}]", @newHtmls

    newDisplay = $ @displaySelector, withNewValue
    currentDisplay = $ @displaySelector, withCurrentValue

    if cl
      console.log fieldName, withCurrentValue, newDisplay, currentDisplay

    if newDisplay.length == 0 and currentDisplay.length > 0
      @removed = @removed.add withCurrentValue

    else if newDisplay.length > 0 and currentDisplay.length == 0
      withCurrentValue.html withNewValue.html()
      @changed = @changed.add withCurrentValue

    else if newDisplay.html() != currentDisplay.html()
      withCurrentValue.after withNewValue
      withCurrentValue.remove()
      @changed = @changed.add withNewValue
