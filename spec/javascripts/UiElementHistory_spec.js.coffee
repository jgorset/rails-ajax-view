#= require ajaxView

describe "UiElement", ->
  beforeEach ->
    @ajaxManager = new AjaxManager()
    @uiElement  = new UiHistoryElement("href","target",@ajaxManager)
  
  it "should contain proper data", ->
    expect(@uiElement.href).toEqual("href")
    expect(@uiElement.target).toEqual("target")
    expect(@uiElement.ajaxManager).toEqual(@ajaxManager)