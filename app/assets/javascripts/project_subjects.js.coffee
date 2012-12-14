$ ->
  $(".btn-new-project-subject").on "click", ->
    $("#new-project-subject-modal").modal()
    false

  $("#new-project-subject-modal").find("button.close, button.close_btn").on "click", () ->
    $("#new-project-subject-modal").modal "hide"

  $("[id^=btn-edit-project-subject_]").on "click", ->
    modal = $("#edit-project-subject-modal")
    modal.find(".alert").addClass("hidden")
    css_id = $(this).attr("id")
    ps_id = css_id.replace("btn-edit-project-subject_", "")
    url_template = modal.find(".url_template").text()
    url = url_template.replace("___PSID___", ps_id)

    modal.find("input[name=project_subject\\[name\\]]").val $(this).parent().find(".project_subject_name").text()
    modal.find("input[name=project_subject\\[price_per_day\\]]").val $(this).parent().find(".project_subject_price_per_day").text()
    modal.find("form").attr("action", url)
    modal.modal()
    false

  $("#edit-project-subject-modal").find("button.close, button.close_btn").on "click", () ->
    $("#edit-project-subject-modal").modal "hide"

  $("#edit_project_subject_modal_form").on('ajax:success', (xhr, data, status) ->
      location.reload()
    ).bind('ajax:error', (xhr, data, status) ->
      messages = jQuery.parseJSON(data.responseText)
      message_str = ""
      messages.forEach((m, i) ->
       message_str += _.escape(m) + "<br>"
      )
      $("#edit-project-subject-modal").find(".alert").removeClass("hidden").html(message_str))
