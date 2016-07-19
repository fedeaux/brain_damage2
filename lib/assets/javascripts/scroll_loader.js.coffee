class @ScrollLoader
  constructor: (@url = document.URL, scrollable_selector = window, list_selector = '.brain-damage-list', status_selector = '.scroll-loader-status') ->

    @scrollable = $ scrollable_selector
    @list = $ list_selector
    @status = $ status_selector
    @offset = 0

    @url = @url.replace('.json', '')+'.json'

    @scrollable.scroll () =>
      if @scrollable.scrollTop() == ($(document).height() - @scrollable.height())
        @load_entries()

  load_entries: =>
    @offset += 1
    @status.addClass 'loading'

    $.ajax
      url: @url
      method: 'get'
      data: { offset: @offset }
      complete: @entries_loaded
      type: 'json'

  entries_loaded: (data) =>
    @status.removeClass 'loading'
    @list.append data.responseJSON.html
