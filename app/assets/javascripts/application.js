// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
/**classes**/

/**AjaxManager**/
function AjaxManager() {
	this.address = "/";
	ajaxManager = this;
   	$.address.externalChange(function(event) {  
    	ajaxManager.onExternalAddressChange(event);
    });  
   	$.address.internalChange(function(event) {  
    	ajaxManager.onInternalAddressChange(event);
    });  
	this.body = $('#ui_body_id').html();
	this.handleUiElements('body');
}

/**UiElement**/
function UiElement(href,target,ajaxManager){
	this.href = href;
	this.target = target;
	this.ajaxManager=ajaxManager
	this.history=false;
}


/**UiHistoryElement**/
UiHistoryElement.prototype = new UiElement();
UiHistoryElement.prototype.constructor = UiHistoryElement;
function UiHistoryElement(href,target,ajaxManager) {
	UiElement.prototype.constructor.call(this,href,target,ajaxManager);
	this.history=true;  
}

/**AjaxMenager Body**/

AjaxManager.prototype.getUiElement = function(selector){
	var href = $(selector).attr('href')
	var target = $(selector).attr('target')
	if ($(selector).is('.ui_history_element')) {						
			return new UiHistoryElement(href,target,this);
	}
	return new UiElement(href,target,this);	
}

AjaxManager.prototype.handleUiElements = function(parent_selector) {
	var ob = this;
	$(parent_selector).find('.ui_element').each(function(){
		$(this).click(function(){
			var elem = ob.getUiElement(this);
			ob.serviceClickEvent(elem);
			return false;
		});
	});
}

AjaxManager.prototype.onExternalAddressChange = function(event) {
	var oldAddress = this.address;
	var newAddress = event.value;
	if(oldAddress == "/" && newAddress == "/") {
		return;
	}
	console.log("external");
	var links = this.getLinks(newAddress);
	var i;
	var ob = this;
	$("#ui_body_id").html(this.body);
	this.handleUiElements('body');
	for(i=0;i<links.length;i++) {
		//must be synchronous
		var jQueryElem = $("[href='/"+links[i]+"'] , [href='/"+links[i]+"/']");
		var href = jQueryElem.attr('href');
		var target = jQueryElem.attr('target');
		var elem = new UiHistoryElement(href,target,this)
		elem.loadOnExtetrnalContent();
	}
	this.address=newAddress;
}

AjaxManager.prototype.onInternalAddressChange = function(event) {
	var oldAddress = this.address;
	var newAddress = event.value;
	//logic	
	this.address=newAddress;
}


AjaxManager.prototype.serviceClickEvent = function(uiElem) {
	uiElem.loadContent();
}

AjaxManager.prototype.getLinks = function(address) {
	var addressesList = address.split("/#/");
	var i;
	var links = [];
	for (i=0;i<addressesList.length;i++) {
		var processedAddress = this.getPoorAddress(addressesList[i]);
		if(processedAddress==""){
			continue;
		}
		if(processedAddress==""){
			continue;
		}
		links.push(this.getPoorAddress(addressesList[i]));
	}
	return links;
}

/**UiElement Body**/
UiElement.prototype.loadContent = function(){
	var ob = this;
	$.get(this.href,function(data){
		$('#' + ob.target).html(data);
		ob.ajaxManager.handleUiElements('#'+ob.target);
	});
}
AjaxManager.prototype.prepareNewAddressOnUiElementClick = function(newAddress) {
	var i; 
	var currentAddressesList = this.address.split("/#/");
	var newAddressesList = [];
	for (i=0;i<currentAddressesList.length;i++) {
		if(currentAddressesList[i] == "" || currentAddressesList[i] == "/") {
			continue;
		}
		var ob = this;
		var different = true;
		var newAddressTarget = $("a[href='"+newAddress+"']").attr('target');
			$("a[target='"+newAddressTarget+"']").each(function(){
				//if there is no this same target
				if(ob.AddressesEqual(currentAddressesList[i],$(this).attr('href'))){
					different = false;
				}
			});
			$("#"+newAddressTarget).find("a").each(function(){
				//if there are inside the target
				if(ob.AddressesEqual(currentAddressesList[i],$(this).attr('href'))){
					different = false;
				}
			});
		if(different){
			newAddressesList.push(currentAddressesList[i]);
		}
	}
	newAddressesList.push(newAddress);
	return newAddressesList;
}

AjaxManager.prototype.AddressesEqual = function(first,second){
	
	var a = first;
	var b = second;
	if(first.substring(0,1) == "/") {
		a = a.substring(1);
	}
	if(first.substring(first.length-1,first.length) == "/") {
		a = a.substring(0,a.length-1);
	}
	if(second.substring(0,1) == "/") {
		b = b.substring(1);
	}
	if(second.substring(second.length-1,second.length) == "/") {
		b = b.substring(0,b.length-1);
	}
	return a == b;
}

AjaxManager.prototype.getPoorAddress = function(address){
	var result = address;
	if(result.substring(0,1) == "/") {
		result = result.substring(1);
	}
	if(result.substring(result.length-1,result.length) == "/") {
		result = result.substring(0,result.length-1);
	}
	return result;
}
/**UiElementHistory Body**/
UiHistoryElement.prototype.loadContent = function(){
	UiElement.prototype.loadContent.call(this);
	var requestAddress=this.href;	
	var addressesArray = this.ajaxManager.prepareNewAddressOnUiElementClick(requestAddress);
	var i;
	var newAddress="";
	for(i=0;i<addressesArray.length;i++) {
		if(i!=0){
			newAddress+="/#/";
		}
		newAddress+=ajaxManager.getPoorAddress(addressesArray[i]);
	}
	$.address.value(newAddress);
}

UiHistoryElement.prototype.loadOnExtetrnalContent = function(){
	ob = this;
	$.ajax({
		url:ob.href,
		async:false,
		success:function(data){
			$('#'+ob.target).html(data);
			ob.ajaxManager.handleUiElements('#'+ob.target);	
		}
	});
}
/**Activator**/
$(document).ready(function(){
	var ajaxManager = new AjaxManager();
});  