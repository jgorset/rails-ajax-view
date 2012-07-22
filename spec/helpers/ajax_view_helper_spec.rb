require 'spec_helper'

describe AjaxViewHelper do
  describe "ajax_body" do
    it "should generate a proper html" do
      block = lambda {TestData::CONTENT}
      helper.ajax_body(&block).should == TestData::AJAX_BODY
    end
  end
  describe "ajax_container" do
    it "should generate a proper html" do
      block = lambda {TestData::CONTENT}
      args = TestData::CONTAINER_PARAMS
      helper.ajax_container(args,&block).should == TestData::CONTAINER_BODY
    end
  end
  describe "ajax_link" do
    it "should generate a proper html" do
      LINK_PARAMS = [ "tab1", tab1_path, { :class => 'css_class', :id =>'tab1_id', :target=>"tab1_container" } ]
      block = nil
      helper.ajax_link(*LINK_PARAMS,&block).should == TestData::LINK_BODY
    end
  end
  describe "ajax_button" do
    it "should generate a proper html" do
      BUTTON_PARAMS = [ "button1", button1_path,{ :target=>"button2_container", :class=>"css_class", :id=>"button_1_id" } ]
      block = nil
      helper.ajax_button(*BUTTON_PARAMS,&block).should == TestData::BUTTON_BODY
    end
  end
end

