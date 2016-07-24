window.ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'] =
  add: (input, settings, messages) ->
    window.ClientSideValidations.formBuilders['ActionView::Helpers::FormBuilder'].remove input, settings

    input_wrapper = input.parents '.field'
    messages = [ messages ] unless $.isArray messages
    contents = messages.join "<br />"

    input_wrapper.addClass 'error'
    input_wrapper.append "<p class=\"ui red fluid small pointing label client-side-validations-error-message\">#{contents}</p>"

  remove: (input, settings) ->
    input_wrapper = input.parents '.field'

    if input_wrapper.length > 0
      # console.log input, input_wrapper, $('.client-side-validations-error-message', input_wrapper)
      $('.client-side-validations-error-message', input_wrapper).remove()
      input_wrapper.removeClass 'error'
