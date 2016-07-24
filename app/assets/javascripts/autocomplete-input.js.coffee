@BrainDamage ?= {}

class @BrainDamage.AutocompleteInput
  constructor: (wrapper_selector, url, @action, @partial_to_show) ->
    @wrapper = $ wrapper_selector

    @results_list = $ '.autocomplete-results', @wrapper
    @results_list_wrapper = @results_list.parent()

    @autocomplete = new BrainDamage.Autocomplete url, @show, partial_to_show: @partial_to_show
    @selectable_list = new BrainDamage.SelectableList @results_list, @wrapper, 'autocomplete-result-item-selected', @action_on_selected_item

    @query_input = $ '.autocomplete-query', @wrapper
    @query_input_wrapper = $ '.autocomplete-query-wrapper', @wrapper

    @query_input.keyup @keyup
    @query_input.focus @show
    @query_input.blur @hide

    @debounced_make_query = _.debounce @make_query, 300
    @last_query = ''

  keyup: =>
    @debounced_make_query @query_input.val()

  make_query: (new_query) ->
    if new_query != @last_query and new_query.length > 0
      @query_input_wrapper.addClass 'loading'
      @autocomplete.fetch @query_input.val()
      @last_query = new_query

  action_on_selected_item: (item) =>
    @action item if @action and item

  show: (response_json) =>
    @query_input_wrapper.removeClass 'loading'
    @selectable_list.html response_json.html if response_json

    if $('.autocomplete-result-item', @results_list_wrapper).length > 0
      @results_list_wrapper.show()

  hide: (e) =>
    @results_list_wrapper.hide()
