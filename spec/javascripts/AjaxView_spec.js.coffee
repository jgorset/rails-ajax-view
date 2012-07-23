#= require ajaxView

describe "AjaxManager", ->
  beforeEach ->
    @ajaxManager = new AjaxManager()
    setFixtures(HTML_BODY)

  it "get proper UiElement", ->
      result = @ajaxManager.getUiElement('#elem_id_1')
      expect(result.href).toEqual("/")
      expect(result.target).toEqual("elem_id_1_container")
    
     it "get proper UiHistoryElements", ->
      result = @ajaxManager.getUiElement('#elem_id_2')
      expect(result.href).toEqual("/tab1");
      expect(result.target).toEqual("elem_id_2_container")

    it "Control click events of ui_elements", ->
      spyOn(@ajaxManager, 'serviceClickEvent')
      $('#elem_id_1').click();
      expect(@ajaxManager.serviceClickEvent).toHaveBeenCalled

    it "Control click events of ui_history_elements", ->
      spyOn(@ajaxManager, 'serviceClickEvent')
      $('#elem_id_2').click()
      expect(@ajaxManager.serviceClickEvent).toHaveBeenCalled
      
  it "Comapre two addresses", ->
      expect(@ajaxManager.AddressesEqual("/tab1/","tab1")).toEqual(true)
      expect(@ajaxManager.AddressesEqual("tab1","tab1")).toEqual(true)
      expect(@ajaxManager.AddressesEqual("tab1/","tab1")).toEqual(true)
      expect(@ajaxManager.AddressesEqual("tab1/","/tab1")).toEqual(true)
      expect(@ajaxManager.AddressesEqual("/tab1","tab1/")).toEqual(true)
    
    it "Remove addresses from history", ->
      setFixtures(HTML_BODY_HISTORY_TEST1)
      @ajaxManager.address="/tab2/#/tab3"
      result = @ajaxManager.prepareNewAddressOnUiElementClick("/tab1")
      expect(result).toEqual(["/tab1"])
      @ajaxManager.address="/tab3"
      result = @ajaxManager.prepareNewAddressOnUiElementClick("/tab1")
      expect(result).toEqual(["/tab1"])  
      @ajaxManager.address=""
      result = @ajaxManager.prepareNewAddressOnUiElementClick("/tab1")
      expect(result).toEqual(["/tab1"])
    
    it "Does not remove addresses from history if the paths do not cover each other", ->
      setFixtures(HTML_BODY_HISTORY_TEST1)
      @ajaxManager.address="/tab6"
      result = @ajaxManager.prepareNewAddressOnUiElementClick("/tab1")
      expect(result).toEqual(["/tab6", "/tab1"])
    
      @ajaxManager.address="/tab6/#/tab10"
      result = @ajaxManager.prepareNewAddressOnUiElementClick("/tab1")
      expect(result).toEqual(["/tab6","tab10","/tab1"])
    
    it "Give poor address", ->
      result = @ajaxManager.getPoorAddress("/tab1")
      expect(result).toEqual("tab1")
      result = @ajaxManager.getPoorAddress("tab1")
      expect(result).toEqual("tab1")
      result = @ajaxManager.getPoorAddress("tab1/")
      expect(result).toEqual("tab1")
      result = @ajaxManager.getPoorAddress("/tab1/")
      expect(result).toEqual("tab1")
    
    it "Give links list", ->
      result = @ajaxManager.getLinks("tab1/#/tab2")
      expect(result[0]).toEqual("tab1")
      expect(result[1]).toEqual("tab2")