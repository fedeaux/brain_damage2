@BrainDamage ?= {}

class @BrainDamage.DatepickerUIInitializer
  setup: ->
    oldMethod = $.datepicker._generateMonthYearHeader
    $.datepicker._generateMonthYearHeader = ->
      html = $("<div />").html oldMethod.apply(this, arguments)
      monthselect = html.find ".ui-datepicker-month"
      monthselect.insertAfter monthselect.next()
      html.html()

    $.datepicker.setDefaults $.datepicker.regional['pt-br']

    $.datepicker.setDefaults
      dateFormat: "yy-mm-dd"
      changeMonth: true
      changeYear: true
      yearRange: '1900:2100'

  custom_datepicker_id: (original_id) ->
    @unique_id "datepicker-#{original_id}"

  unique_id: (prefix = false) ->
    prefix = "#{prefix}-" if prefix
    id = (([1...16].map (i) -> String.fromCharCode parseInt(65 + Math.random()*26)).join '').toLowerCase()

    "#{prefix}#{id}"

  install: (context = 'body') ->
    $('.birthday-datepicker, .past-datepicker, .future-datepicker, .datepicker', context).each (i, _f) =>
      f = $ _f
      id = f.attr 'id'

      unless id.indexOf('datepicker-') > -1
        f.attr 'id', @custom_datepicker_id id

    $('.birthday-datepicker', context).datepicker
      minDate: moment().subtract(100, 'years').toDate()
      maxDate: moment().subtract(18, 'years').toDate()

    $('.past-datepicker', context).datepicker
      minDate: moment().subtract(15, 'years').toDate()
      maxDate: moment().toDate()

    $('.future-datepicker', context).datepicker
      minDate: moment().toDate()
      maxDate: moment().add(18, 'years').toDate()

    $('.datepicker', context).datepicker()
