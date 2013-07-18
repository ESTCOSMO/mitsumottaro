$ ->
  $(".btn-new-project-task").on "click", ->
    $("#new-project-task-modal").modal()
    false

  $("#new-project-task-modal").find("button.close, button.close_btn").on "click", () ->
    $("#new-project-task-modal").modal "hide"

  $("[id^=btn-edit-project-task_]").on "click", ->
    modal = $("#edit-project-task-modal")
    modal.find(".alert").addClass("hidden")
    css_id = $(this).attr("id")
    ps_id = css_id.replace("btn-edit-project-task_", "")
    url_template = modal.find(".url_template").text()
    url = url_template.replace("___PSID___", ps_id)

    modal.find("input[name=project_task\\[name\\]]").val $(this).parent().find(".project_task_name").text()
    modal.find("input[name=project_task\\[price_per_day\\]]").val $(this).parent().find(".project_task_price_per_day").text()
    modal.find("form").attr("action", url)
    modal.modal()
    false

  $("#edit-project-task-modal").find("button.close, button.close_btn").on "click", () ->
    $("#edit-project-task-modal").modal "hide"

  $("#edit_project_task_modal_form").on('ajax:success', (xhr, data, status) ->
      location.reload()
    ).bind('ajax:error', (xhr, data, status) ->
      messages = jQuery.parseJSON(data.responseText)
      message_str = ""
      messages.forEach((m, i) ->
       message_str += _.escape(m) + "<br>"
      )
      $("#edit-project-task-modal").find(".alert").removeClass("hidden").html(message_str))

  $("#new-project-task-modal").find("select#template_task_id").change ->
    model = $("#new-project-task-modal")
    selected = model.find("select#template_task_id option:selected")
    model.find("input[name=project_task\\[name\\]]").val selected.text()
    model.find("input[name=project_task\\[price_per_day\\]]").val model.find("input[name=template_tasks_price_#{selected.val()}]").val()

  $("#new_project_task_modal_form").on('ajax:success', (xhr, data, status) ->
      location.reload()
     ).bind('ajax:error', (xhr, data, status) ->
      messages = jQuery.parseJSON(data.responseText)
      message_str = ""
      messages.forEach((m, i) ->
       message_str += _.escape(m) + "<br>"
      )
      $("#new-project-task-modal").find(".alert").removeClass("hidden").html(message_str))
