class @ConditionallyVisibleField
  constructor: (@field, @dependsOn, @condition) ->
    @dependsOn.change @verifyFieldVisibility
    @verifyFieldVisibility()

  verifyFieldVisibility: =>
    if @shouldBeVisible()
      @field.fadeIn()
    else
      @field.hide()

  shouldBeVisible: ->
    @dependsOn.val() == @condition
