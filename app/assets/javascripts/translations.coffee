# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$("button.edit").click () -> alert "Handler for click() called"

baseSelector = (rootElement) -> "#" + rootElement.id

getElement = (rootElement, classStr) ->
  return $(baseSelector(rootElement) + " ." + classStr)

getForm = (rootElement) ->
  return getElement(rootElement, "editContainer")
getWait = (rootElement) ->
  return getElement(rootElement, "wait")
getSuccess = (rootElement) ->
  return getElement(rootElement, "success")
getFail = (rootElement) ->
  return getElement(rootElement, "fail")
getSave = (rootElement) ->
  return getElement(rootElement, "save")
getEdit = (rootElement) ->
  return getElement(rootElement, "edit")
getId = (rootElement) ->
  return getElement(rootElement, "idHolder")[0]
getLanguage = (rootElement) ->
  return getElement(rootElement, "languageContainer")
getTextId = (rootElement) ->
  return getElement(rootElement, "idContainer")
getText = (rootElement) ->
  return getElement(rootElement, "translationText")
getNewText = (rootElement) ->
  return getElement(rootElement, "translationInput")[0]

parentTr = (element) ->
  return element if element.nodeName is 'TR' || element is null
  return parentTr(element.parentElement)

editTranslation = (event) ->
  rowElement = parentTr(event.toElement)
  $(".edit").hide() # Hide all edit buttons -> edit only one at a time
  getSuccess(rowElement).hide()
  getFail(rowElement).hide()
  getForm(rowElement).show()
  getSave(rowElement).show()

saveTranslation = (event) ->
  rowElement = parentTr(event.toElement)
  $(".save").hide()
  getFail(rowElement).hide()
  getWait(rowElement).show()
  text = getNewText(rowElement).value
  $.ajax
    url: "/translations/" + getId(rowElement).value + "/edit"
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
      getForm(rowElement).hide()
      console.log(getText(rowElement))
      getText(rowElement).html(text)
      $(".edit").show()


$(document).on 'ready page:load', ->
  $(".edit").click (event) -> editTranslation(event)
  $(".save").click (event) -> saveTranslation(event)
