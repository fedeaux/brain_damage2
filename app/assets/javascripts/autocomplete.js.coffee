@BrainDamage ?= {}

class @BrainDamage.Autocomplete
  constructor: (@url, @action, @custom_data = {}) ->

  fetch: (query) ->
    data = $.extend @custom_data, query: query

    $.ajax
      url: @url
      method: 'get'
      complete: @complete
      type: 'json'
      data: data

  complete: (response) =>
    @action response.responseJSON
