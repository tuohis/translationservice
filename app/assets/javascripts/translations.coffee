# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$("button.edit").click () -> alert "Handler for click() called"

getWait = (rootElement) ->
  return $("#" + rootElement.id + " .wait")
getSuccess = (rootElement) ->
  return $("#" + rootElement.id + " .success")
getFail = (rootElement) ->
  return $("#" + rootElement.id + " .fail")
getSave = (rootElement) ->
  return $("#" + rootElement.id + " .save")
getEdit = (rootElement) ->
  return $("#" + rootElement.id + " .edit")

parentTr = (element) ->
  return element if element.nodeName is 'TR' || element is null
  return parentTr(element.parentElement)

editTranslation = (event) ->
  rowElement = parentTr(event.toElement)
  elementId = rowElement.id

  translationId = $("#" + elementId + " > .idContainer").text()
  language = $("#" + elementId + " > .languageContainer").text()
  #textElement = $("#" + elementId + " > .translationContainer")
  formElement = $("#" + elementId + " > .editContainer")
  #buttonElement = $("#" + elementId + " > .buttonContainer")
  #buttonElement.hide()
  $(".edit").hide() # Hide all edit buttons -> edit only one at a time
  getSuccess(rowElement).hide()
  getFail(rowElement).hide()
  #textElement.hide()
  formElement.show()
  $("#" + elementId + " > .buttonContainer > .save").show()

saveTranslation = (event) ->
  rowElement = parentTr(event.toElement)
  elementId = rowElement.id
  selectorBase = "#" + elementId + " "
  id = $(selectorBase + ".idHolder")[0].value
  textId = $(selectorBase + ".idContainer").text()
  language = $(selectorBase + ".languageContainer").text()
  text = $(selectorBase + ".translationInput")[0].value
  textElement = $(selectorBase + ".translationText")
  formElement = $(selectorBase + ".editContainer")
  $(".save").hide()
  getFail(rowElement).hide()
  getWait(rowElement).show()
  $.ajax
    url: "/translations/" + id + "/edit"
    type: "get"
    dataType: 'html'
    data: { 'api' : 1, 'text' : text }
    error: (jqXHR, textStatus, errorThrown) ->
      getWait(rowElement).hide()
      getFail(rowElement).show()
      getSave(rowElement).show()
      alert(textStatus)
    success: (data, textStatus, jqHXR) ->
      getWait(rowElement).hide()
      getSuccess(rowElement).show()
      formElement.hide()
      textElement.html(text)
      #textElement.show()
      $(".edit").show()


$(document).on 'ready page:load', ->
  $(".edit").click (event) -> editTranslation(event)
  $(".save").click (event) -> saveTranslation(event)
