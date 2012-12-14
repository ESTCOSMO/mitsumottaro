deploy_point_form = (l_item_id, m_item_id, s_item_id, project_subject_id, subject_point_id, point_50, point_90) ->
  project_id = $(".project_id").text()
  modal = $("#point-modal")
  form = modal.find("form")
  url_for_create = modal.find(".url_template_for_create").text().replace("___PID___", project_id).replace("___LID___", l_item_id).replace("___MID___", m_item_id).replace("___SID___", s_item_id)
  modal.find(".url_for_create").text(url_for_create)
  url_for_destroy = modal.find(".url_template_for_destroy").text().replace("___PID___", project_id).replace("___LID___", l_item_id).replace("___MID___", m_item_id).replace("___SID___", s_item_id).replace("__SPID__", subject_point_id)
  modal.find(".url_for_destroy").text(url_for_destroy)
  form.find("#subject_point_project_subject_id").val(project_subject_id)
  form.find("#subject_point_point_50").val(point_50)
  form.find("#subject_point_point_90").val(point_90)
  modal.find(".alert").addClass("hidden")
  modal.modal "show"

$ () ->
  $("#new_subject_point").bind('ajax:success', (xhr, data, status) ->
      location.reload()
    ).bind('ajax:error', (xhr, data, status) ->
      messages = jQuery.parseJSON(data.responseText)
      message_str = ""
      messages.forEach((m, i) ->
       message_str += _.escape(m) + "<br>"
      )
      $("#point-modal").find(".alert").removeClass("hidden").html(message_str)
    )

  $("#point-modal").find(".close_btn").on "click", () ->
    $("#point-modal").modal "hide"

  $("#point-modal").find("button.close").on "click", () ->
    $("#point-modal").modal "hide"

  $("#point-modal").find(".btn-create").on "click", () ->
    modal = $("#point-modal")
    url = modal.find(".url_for_create").text()
    form = modal.find("form")
    form.attr("action", url)
    form.find("input[name=_method]").val("POST")

  $("#point-modal").find(".btn-delete").on "click", () ->
    modal = $("#point-modal")
    url = modal.find(".url_for_destroy").text()
    form = modal.find("form")
    form.attr("action", url)
    form.find("input[name='_method']").val("DELETE")

  $('#point-modal').on 'shown', ->
    $("#subject_point_point_50").focus()

  $('#subject_point_point_50').focus ->
    $(this).select()

  $(".point_area").on "click", () ->
    css_id_50 = $(this).children("[id^='point_50_']").attr("id")
    css_id_90 = $(this).children("[id^='point_90_']").attr("id")
    data = css_id_50.split("_")
    point_type = data[1]
    large_item_id = data[2]
    medium_item_id = data[3]
    small_item_id = data[4]
    project_subject_id = data[5]
    subject_point_id = data[6]
    selector_suffix = "#{large_item_id}_#{medium_item_id}_#{small_item_id}_#{project_subject_id}_#{subject_point_id}"
    point_50 = $("##{css_id_50}").text()
    point_90 = $("##{css_id_90}").text()
    if point_50 == "-"
      point_50 = ""
    if point_90 == "-"
      point_90 = ""
    modalform = $("#point-modal").find("form")
    deploy_point_form large_item_id, medium_item_id, small_item_id, project_subject_id, subject_point_id, point_50, point_90

  #
  # Item Modal (common)
  #
  $('#item-modal').on 'shown', ->
    $("#item-modal").find("input[type=text]").focus()

  $("#item-modal").find("button.close, button.close_btn").on "click", () ->
    $("#item-modal").modal "hide"

  $("#item_modal_form").on('ajax:success', (xhr, data, status) ->
      location.reload()
    ).bind('ajax:error', (xhr, data, status) ->
      messages = jQuery.parseJSON(data.responseText)
      message_str = ""
      messages.forEach((m, i) ->
       message_str += _.escape(m) + "<br>"
      )
      $("#item-modal").find(".alert").removeClass("hidden").html(message_str))

  $("#item-modal").find(".btn-save").on "click", ->
    item_modal = $("#item-modal")
    action = item_modal.find(".url_for_save").text()
    method = item_modal.find(".method_for_save").text()
    item_modal.find("form").attr("action", action)
    item_modal.find("input[name=_method]").val(method)

  $("#item-modal").find(".btn-destroy").on "click", ->
    item_modal = $("#item-modal")
    action = item_modal.find(".url_for_save").text()
    method = "DELETE"
    item_modal.find("form").attr("action", action)
    item_modal.find("input[name=_method]").val(method)

  #
  # Add item
  #
  $("[id^=add_item]").on "click", ->
    item_modal = $("#item-modal")
    project_id = $(".project_id").text()
    css_id = $(this).attr("id")
    splitted = css_id.replace("add_item", "").split("_")
    if splitted.length == 1
      template_url = item_modal.find(".url_template_for_create_large").text()
      url_for_create = template_url.replace("___PID___", project_id)
      text_field_name = "large_item[name]"
    else if splitted.length == 2
      template_url = item_modal.find(".url_template_for_create_medium").text()
      url_for_create = template_url.replace("___PID___", project_id).replace("___LID___", splitted[1])
      text_field_name = "medium_item[name]"
    else
      template_url = item_modal.find(".url_template_for_create_small").text()
      url_for_create = template_url.replace("___PID___", project_id).replace("___LID___", splitted[1]).replace("___MID___", splitted[2])
      text_field_name = "small_item[name]"

    item_modal.find(".url_for_save").text(url_for_create)
    item_modal.find(".method_for_save").text("POST")
    item_modal.find(".alert").addClass("hidden")
    item_modal.find("#large_item_name").val("")
    item_modal.find(".btn-destroy").addClass("hidden")
    item_modal.find("#large_item_name").attr("name", text_field_name)
    item_modal.modal("show")
    false

  #
  # edit item
  #
  $("[id^=item_name_]").on "click", ->
    item_modal = $("#item-modal")
    project_id = $(".project_id").text()
    css_id = $(this).attr("id")
    splitted = css_id.replace("item_name_", "").split("_")
    if splitted.length == 1
      template_url = item_modal.find(".url_template_for_update_large").text()
      url_for_update = template_url.replace("___PID___", project_id).replace("___LID___", splitted[0])
      text_field_name = "large_item[name]"
    else if splitted.length == 2
      template_url = item_modal.find(".url_template_for_update_medium").text()
      url_for_update = template_url.replace("___PID___", project_id).replace("___LID___", splitted[0]).replace("___MID___", splitted[1])
      text_field_name = "medium_item[name]"
    else
      template_url = item_modal.find(".url_template_for_update_small").text()
      url_for_update = template_url.replace("___PID___", project_id).replace("___LID___", splitted[0]).replace("___MID___", splitted[1]).replace("___SID___", splitted[2])
      text_field_name = "small_item[name]"

    item_modal.find(".url_for_save").text(url_for_update)
    item_modal.find(".method_for_save").text("PUT")
    item_modal.find(".alert").addClass("hidden")
    item_modal.find(".btn-destroy").removeClass("hidden")
    orig_item_name = $(this).find(".plain_item_name").text()
    item_modal.find("#large_item_name").val(orig_item_name)
    item_modal.find("#large_item_name").attr("name", text_field_name)
    item_modal.modal("show")
