#= require ajaxView
#= require jquery.address-1.4.min

class window.AjaxManager
  constructor: () ->
    @address = "/"
    ajaxManager = this
    $.address.externalChange (event) ->  
      ajaxManager.onExternalAddressChange(event)
    $.address.internalChange (event) ->
      ajaxManager.onInternalAddressChange(event)
    @body = $('#ui_body_id').html()
    @handleUiElements('body')
  
  getUiElement: (selector) ->
    href = $(selector).attr('href')
    target = $(selector).attr('target')
    if $(selector).is('.ui_history_element')            
      return new UiHistoryElement(href,target,this);
    return new UiElement(href,target,this); 
    
  handleUiElements: (parentSelector) ->
    ob = this
    $(parentSelector).find('.ui_element').each ->
      $(this).click ->
        elem = ob.getUiElement(this)
        ob.serviceClickEvent(elem)
        return false;
  
  onExternalAddressChange: (event) ->
    oldAddress = @address;
    newAddress = event.value;
    if oldAddress == "/" and newAddress == "/"
      return
    links = @getLinks(newAddress)
    ob = this
    $("#ui_body_id").html(this.body)
    @handleUiElements('body')
    for link in links
      jQueryElem = $("[href='/"+link+"'] , [href='/"+link+"/']");
      href = jQueryElem.attr('href')
      target = jQueryElem.attr('target')
      elem = new UiHistoryElement(href,target,this)
      elem.loadOnExtetrnalContent()
    @address=newAddress

  onInternalAddressChange: (event) ->
    oldAddress = @address
    newAddress = event.value
    @address=newAddress

  serviceClickEvent: (uiElem) ->
    uiElem.loadContent()
  
  getLinks: (address) ->
    addressesList = address.split("/#/")
    links = [];
    for link in addressesList
      processedAddress = @getPoorAddress(link)
      if(processedAddress=="")
        continue
      links.push(processedAddress)
    return links

  prepareNewAddressOnUiElementClick: (newAddress) -> 
    currentAddressesList = @address.split("/#/")
    newAddressesList = []
    
    for processedAddress in currentAddressesList
      if processedAddress == "" or processedAddress == "/"
        continue
      ob = this
      different = true
      newAddressTarget = $("a[href='"+newAddress+"']").attr('target');
      $("a[target='"+newAddressTarget+"']").each ->
        #if there is no this same target
        if ob.AddressesEqual(processedAddress,$(this).attr('href'))
          different = false
      $("#"+newAddressTarget).find("a").each ->
        #if there are inside the target
        if ob.AddressesEqual(processedAddress,$(this).attr('href'))
          different = false   
      if different
        newAddressesList.push(processedAddress)
        
    newAddressesList.push(newAddress);
    return newAddressesList;

  AddressesEqual: (first,second) ->
    a = first
    b = second
    if first.substring(0,1) == "/"
      a = a.substring(1);
    if first.substring(first.length-1,first.length) == "/"
      a = a.substring(0,a.length-1)
    if second.substring(0,1) == "/"
      b = b.substring(1);
    if second.substring(second.length-1,second.length) == "/"
      b = b.substring(0,b.length-1);
    return a == b;

  getPoorAddress: (address) ->
    result = address
    if result.substring(0,1) == "/"
      result = result.substring(1)
    if result.substring(result.length-1,result.length) == "/"
      result = result.substring(0,result.length-1)
    return result;


class window.UiElement
  constructor: (href, target, ajaxManager) ->
    @href = href
    @target = target 
    @ajaxManager = ajaxManager
 
  loadContent: () ->
    ob = this
    $.get @href, (data) ->
      $('#' + ob.target).html(data)
      ob.ajaxManager.handleUiElements('#'+ob.target)
  
  
class window.UiHistoryElement extends UiElement

  loadContent: () ->
    super()
    requestAddress = @href; 
    addressesArray = @ajaxManager.prepareNewAddressOnUiElementClick(requestAddress);
    newAddress=""
    first = true      
    for processedAddres in addressesArray
      if not first
        newAddress+="/#/";
      newAddress+=@ajaxManager.getPoorAddress(processedAddres)
      first = false;
    $.address.value(newAddress);

  loadOnExtetrnalContent: ->
    ob = this
    $.ajax
      url: ob.href,
      async: false,
      success: (data) ->
        $('#'+ob.target).html(data);
        ob.ajaxManager.handleUiElements('#'+ob.target)

$(document).ready ->
  ajaxManager = new AjaxManager()
