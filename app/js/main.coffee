jQuery ->
  generate_url = (data) ->
    base = "#{location.protocol}//#{location.hostname}#{if location.port then ':'+location.port else ''}"
    "#{base}/#{data.width}x#{data.height}"

  update_example = (data) ->
    url = generate_url(data)
    link = $("<a>",{ href: url, text: url })
    tag = "<img src=\"#{url}\">"
    $('#example-link-wrapper').html(link)
    $('#example-tag-wrapper').text(tag)

  example_form = $("#example-form")
  example_form.validate {
    focusInvalid: false
    submitHandler: (form) ->
      form_data = $(form).serializeArray().reduce (obj, entry) ->
        obj[entry.name] = entry.value
        obj
      , {}
      update_example(form_data)
    showErrors: (errorMap) ->
  }
  example_form.find(":input").keyup (e) ->
    example_form.submit()
