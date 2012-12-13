deploy_point_form = (l_item_id, m_item_id, s_item_id, project_subject_id, subject_point_id, point_50, point_90) ->
  project_id = $(".project_id").text()
  modal = $("#point-modal")
  form = modal.find("form")
  url_for_create = modal.find(".url_for_create").text().replace("___PID___", project_id).replace("___LID___", l_item_id).replace("___MID___", m_item_id).replace("___SID___", s_item_id)
  modal.find(".url_for_create").text(url_for_create)
  url_for_destroy = modal.find(".url_for_destroy").text().replace("___PID___", project_id).replace("___LID___", l_item_id).replace("___MID___", m_item_id).replace("___SID___", s_item_id).replace("__SPID__", subject_point_id)
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
